import { spawn } from 'node:child_process';
import { createReadStream, existsSync, statSync } from 'node:fs';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { createServer } from 'node:http';
import { tmpdir } from 'node:os';
import { extname, isAbsolute, join, normalize, resolve } from 'node:path';

const browserPath = process.argv[2];
const buildRoot = resolve(process.argv[3] ?? 'build/web');
const basePath = '/Starlight-Sudoku/';

if (!browserPath || !isAbsolute(browserPath) || !existsSync(browserPath)) {
  throw new Error('Pass an absolute Chrome or Edge executable path.');
}
if (!existsSync(join(buildRoot, 'index.html'))) {
  throw new Error(`Missing release build at ${buildRoot}`);
}

const mimeTypes = {
  '.css': 'text/css; charset=utf-8',
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.ogg': 'audio/ogg',
  '.png': 'image/png',
  '.wasm': 'application/wasm',
};

const audioRequests = [];
const server = createServer((request, response) => {
  const incoming = new URL(request.url, 'http://127.0.0.1');
  let pathname = decodeURIComponent(incoming.pathname);
  if (!pathname.startsWith(basePath)) {
    response.writeHead(404).end();
    return;
  }
  pathname = pathname.slice(basePath.length);
  if (!pathname || pathname.endsWith('/')) pathname += 'index.html';
  const filePath = resolve(buildRoot, normalize(pathname));
  if (!filePath.startsWith(`${buildRoot}\\`) && filePath !== buildRoot) {
    response.writeHead(403).end();
    return;
  }
  if (!existsSync(filePath) || !statSync(filePath).isFile()) {
    response.writeHead(404).end();
    return;
  }

  const size = statSync(filePath).size;
  const headers = {
    'Accept-Ranges': 'bytes',
    'Cache-Control': 'no-store',
    'Content-Type': mimeTypes[extname(filePath)] ?? 'application/octet-stream',
  };
  const range = request.headers.range;
  let status = 200;
  let start = 0;
  let end = size - 1;
  if (range) {
    const match = /^bytes=(\d+)-(\d*)$/.exec(range);
    if (match) {
      start = Number(match[1]);
      end = match[2] ? Math.min(Number(match[2]), end) : end;
      status = 206;
      headers['Content-Range'] = `bytes ${start}-${end}/${size}`;
    }
  }
  headers['Content-Length'] = String(end - start + 1);

  if (filePath.endsWith('.ogg')) {
    audioRequests.push({
      path: pathname,
      range: range ?? null,
      status,
      time: Date.now(),
    });
  }
  response.writeHead(status, headers);
  createReadStream(filePath, { start, end }).pipe(response);
});

await new Promise((resolveListen) => server.listen(0, '127.0.0.1', resolveListen));
const webPort = server.address().port;
const profilePath = await mkdtemp(join(tmpdir(), 'starlight-audio-check-'));
if (!resolve(profilePath).startsWith(resolve(tmpdir()))) {
  throw new Error(`Unsafe temporary profile path: ${profilePath}`);
}

const pageUrl = `http://127.0.0.1:${webPort}${basePath}`;
const browser = spawn(
  browserPath,
  [
    '--headless=new',
    '--disable-gpu',
    '--no-first-run',
    '--no-default-browser-check',
    '--remote-debugging-port=0',
    `--user-data-dir=${profilePath}`,
    '--window-size=430,900',
    pageUrl,
  ],
  { stdio: ['ignore', 'ignore', 'pipe'] },
);

let stderr = '';
browser.stderr.setEncoding('utf8');
browser.stderr.on('data', (chunk) => {
  stderr += chunk;
});

const delay = (milliseconds) =>
  new Promise((resolveDelay) => setTimeout(resolveDelay, milliseconds));

async function waitFor(check, description, timeoutMs = 30000) {
  const deadline = Date.now() + timeoutMs;
  while (Date.now() < deadline) {
    const value = await check();
    if (value) return value;
    await delay(100);
  }
  throw new Error(`Timed out waiting for ${description}`);
}

async function readDevToolsPort() {
  const file = join(profilePath, 'DevToolsActivePort');
  return waitFor(async () => {
    try {
      const contents = await readFile(file, 'utf8');
      return Number(contents.split(/\r?\n/)[0]);
    } catch (_) {
      return null;
    }
  }, 'Chrome DevTools port');
}

let socket;
let nextId = 0;
const pending = new Map();

async function connectCdp(port) {
  const targets = await waitFor(async () => {
    try {
      const response = await fetch(`http://127.0.0.1:${port}/json`);
      const entries = await response.json();
      return entries.find((entry) => entry.type === 'page');
    } catch (_) {
      return null;
    }
  }, 'page target');
  socket = new WebSocket(targets.webSocketDebuggerUrl);
  await new Promise((resolveOpen, rejectOpen) => {
    socket.addEventListener('open', resolveOpen, { once: true });
    socket.addEventListener('error', rejectOpen, { once: true });
  });
  socket.addEventListener('message', (event) => {
    const message = JSON.parse(event.data);
    if (!message.id) return;
    const callbacks = pending.get(message.id);
    if (!callbacks) return;
    pending.delete(message.id);
    if (message.error) callbacks.reject(new Error(JSON.stringify(message.error)));
    else callbacks.resolve(message.result);
  });
}

function cdp(method, params = {}) {
  const id = ++nextId;
  return new Promise((resolveCall, rejectCall) => {
    pending.set(id, { resolve: resolveCall, reject: rejectCall });
    socket.send(JSON.stringify({ id, method, params }));
  });
}

async function evaluate(expression) {
  const result = await cdp('Runtime.evaluate', {
    expression,
    awaitPromise: true,
    returnByValue: true,
  });
  if (result.exceptionDetails) {
    throw new Error(result.exceptionDetails.text ?? 'Runtime evaluation failed');
  }
  return result.result.value;
}

async function pointerClick(rect) {
  const x = rect.x + rect.width / 2;
  const y = rect.y + rect.height / 2;
  await cdp('Input.dispatchMouseEvent', {
    type: 'mousePressed',
    x,
    y,
    button: 'left',
    buttons: 1,
    clickCount: 1,
  });
  await cdp('Input.dispatchMouseEvent', {
    type: 'mouseReleased',
    x,
    y,
    button: 'left',
    buttons: 0,
    clickCount: 1,
  });
}

async function semanticsRect(labelPart) {
  const encoded = JSON.stringify(labelPart);
  return evaluate(`(() => {
    const wanted = ${encoded};
    const elements = [];
    const visit = (root) => {
      elements.push(...root.querySelectorAll('flt-semantics, [aria-label]'));
      for (const item of root.querySelectorAll('*')) {
        if (item.shadowRoot) visit(item.shadowRoot);
      }
    };
    visit(document);
    const candidates = elements.filter((item) =>
      ((item.getAttribute('aria-label') || '') + ' ' + (item.textContent || ''))
        .includes(wanted));
    candidates.sort((left, right) => {
      const leftRect = left.getBoundingClientRect();
      const rightRect = right.getBoundingClientRect();
      return leftRect.width * leftRect.height - rightRect.width * rightRect.height;
    });
    const element = candidates[0];
    if (!element) return null;
    const rect = element.getBoundingClientRect();
    return { x: rect.x, y: rect.y, width: rect.width, height: rect.height,
      label: element.getAttribute('aria-label') };
  })()`);
}

try {
  const devToolsPort = await readDevToolsPort();
  await connectCdp(devToolsPort);
  await cdp('Runtime.enable');
  await cdp('Page.enable');

  await waitFor(
    () => evaluate("document.getElementById('starlight-html-bgm') !== null"),
    'release app audio elements',
    60000,
  );
  await waitFor(
    () => evaluate("document.getElementById('launch-splash') === null"),
    'Flutter first frame',
    60000,
  );
  await delay(500);

  const before = await evaluate(`(() => {
    const bgm = document.getElementById('starlight-html-bgm');
    const sfx = document.getElementById('starlight-html-sfx');
    return {
      bgmPreload: bgm?.preload,
      bgmSrc: bgm?.getAttribute('src'),
      sfxPreload: sfx?.preload,
      sfxSrc: sfx?.getAttribute('src'),
    };
  })()`);
  if (
    before.bgmPreload !== 'none' ||
    before.sfxPreload !== 'none' ||
    before.bgmSrc !== null ||
    before.sfxSrc !== null ||
    audioRequests.length !== 0
  ) {
    throw new Error(`Audio loaded before consent: ${JSON.stringify({ before, audioRequests })}`);
  }

  const viewport = await evaluate(`({
    width: window.innerWidth,
    height: window.innerHeight,
  })`);
  const bgmPoint = {
    x: viewport.width / 2,
    y: viewport.height * 0.472,
    width: 0,
    height: 0,
  };

  const bgmPointerStart = Date.now();
  await pointerClick(bgmPoint);
  const bgmRequest = await waitFor(
    () => audioRequests.find((item) =>
      item.time >= bgmPointerStart && item.path.includes('1_Title_Lamplight')),
    'BGM range request from normal pointer input',
  );
  if (bgmRequest.status !== 206 || !bgmRequest.range) {
    throw new Error(`Pointer BGM did not use range streaming: ${JSON.stringify(bgmRequest)}`);
  }
  await waitFor(
    () => evaluate(`(() => {
      const audio = document.getElementById('starlight-html-bgm');
      return audio && !audio.paused && audio.currentTime > 0;
    })()`),
    'BGM playback start and gate dismissal',
  );
  await delay(500);

  const accessibilityEnabled = await evaluate(`(() => {
    const placeholder = document.querySelector('flt-semantics-placeholder');
    if (!placeholder) return false;
    placeholder.click();
    return true;
  })()`);
  if (!accessibilityEnabled) {
    throw new Error('Flutter accessibility placeholder was not available');
  }
  const startPoint = await waitFor(async () => {
    for (const label of ['New puzzle', '새 퍼즐', '新しいパズル', '新的谜题', '新的謎題']) {
      const rect = await semanticsRect(label);
      if (rect) return rect;
    }
    return null;
  }, 'new-puzzle semantics rectangle');

  const previousTimeOrigin = await evaluate('performance.timeOrigin');
  await cdp('Page.reload', { ignoreCache: true });
  await waitFor(
    () => evaluate(`performance.timeOrigin !== ${previousTimeOrigin}`),
    'clean page reload',
  );
  await waitFor(
    () => evaluate("document.getElementById('launch-splash') === null"),
    'Flutter first frame after reload',
    60000,
  );
  const secondBgmPointerStart = Date.now();
  await pointerClick(bgmPoint);
  const secondBgmRequest = await waitFor(
    () => audioRequests.find((item) =>
      item.time >= secondBgmPointerStart && item.path.includes('1_Title_Lamplight')),
    'BGM range request after reload',
  );
  if (secondBgmRequest.status !== 206 || !secondBgmRequest.range) {
    throw new Error(`Reloaded BGM did not use range streaming: ${JSON.stringify(secondBgmRequest)}`);
  }
  await waitFor(
    () => evaluate(`(() => {
      const audio = document.getElementById('starlight-html-bgm');
      return audio && !audio.paused && audio.currentTime > 0;
    })()`),
    'BGM playback start after reload',
  );
  await delay(500);

  const x = startPoint.x + startPoint.width / 2;
  const y = startPoint.y + startPoint.height / 2;
  const sfxPointerStart = Date.now();
  await cdp('Input.dispatchTouchEvent', {
    type: 'touchStart',
    touchPoints: [{ x, y, radiusX: 1, radiusY: 1, force: 1 }],
  });
  const sfxRequest = await waitFor(
    () => audioRequests.find((item) =>
      item.time >= sfxPointerStart &&
      decodeURIComponent(item.path).includes('title button twinkle')),
    'SFX range request during pointer-down',
    5000,
  );
  const releaseTime = Date.now();
  await cdp('Input.dispatchTouchEvent', {
    type: 'touchEnd',
    touchPoints: [],
  });
  if (sfxRequest.status !== 206 || !sfxRequest.range) {
    throw new Error(`SFX did not use range streaming: ${JSON.stringify(sfxRequest)}`);
  }
  if (sfxRequest.time >= releaseTime) {
    throw new Error(`SFX started only after pointer release: ${JSON.stringify(sfxRequest)}`);
  }

  console.log(
    JSON.stringify(
      {
        result: 'PASS',
        viewport,
        beforeConsent: before,
        bgmFromNormalPointer: secondBgmRequest,
        startButtonRect: startPoint,
        sfxBeforeNavigationRelease: sfxRequest,
      },
      null,
      2,
    ),
  );
} catch (error) {
  console.error(stderr);
  throw error;
} finally {
  if (socket?.readyState === WebSocket.OPEN) socket.close();
  const browserExited = new Promise((resolveExit) =>
    browser.once('exit', resolveExit),
  );
  browser.kill('SIGKILL');
  await Promise.race([browserExited, delay(3000)]);
  await new Promise((resolveClose) => server.close(resolveClose));
  try {
    await rm(profilePath, { recursive: true, force: true, maxRetries: 5, retryDelay: 200 });
  } catch (cleanupError) {
    console.warn(`Temporary Chrome profile cleanup deferred: ${cleanupError.message}`);
  }
}
