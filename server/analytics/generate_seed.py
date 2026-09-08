#!/usr/bin/env python3
"""Deterministic anonymous analytics seed for the Starlight Sudoku dashboard.

No Google accounts. Instance IDs are app-install IDs, same idea as GA4.
Copy server/analytics/public to the Vultr host when the box is ready.
DNS for tycheworks.com is already on Vultr. Gabia is the registrar only.
"""

from __future__ import annotations

import json
import random
from collections import defaultdict
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SEED_DIR = ROOT / "seed"
PUBLIC_DIR = ROOT / "public"

START = date(2026, 8, 15)
END = date(2026, 9, 4)
RNG = random.Random(20260904)

PLATFORMS = [("android", 0.86), ("web", 0.14)]
LOCALES = [
    ("ko", 0.54),
    ("en", 0.21),
    ("ja", 0.13),
    ("zh", 0.07),
    ("zh_TW", 0.05),
]
EVENTS = (
    "app_open",
    "puzzle_start",
    "puzzle_clear",
    "puzzle_give_up",
    "village_open",
    "trial_end_shown",
    "trial_end_send",
    "settings_open",
)


def pick(weights: list[tuple[str, float]]) -> str:
    roll = RNG.random()
    acc = 0.0
    for name, weight in weights:
        acc += weight
        if roll <= acc:
            return name
    return weights[-1][0]


def daterange() -> list[date]:
    days = []
    cursor = START
    while cursor <= END:
        days.append(cursor)
        cursor += timedelta(days=1)
    return days


def dau_for(day: date) -> int:
    index = (day - START).days
    weekend = 1.18 if day.weekday() >= 5 else 1.0
    base = 9 + index * 1.35
    return max(6, int(base * weekend + RNG.randint(-2, 3)))


def new_instance(day: date, n: int) -> dict:
    token = f"{RNG.getrandbits(48):012X}"
    return {
        "instance_id": f"A-{token}",
        "first_seen": day.isoformat(),
        "platform": pick(PLATFORMS),
        "locale": pick(LOCALES),
    }


def simulate() -> dict:
    days = daterange()
    instances: list[dict] = []
    returning: list[dict] = []
    daily = []
    funnel = defaultdict(int)
    stages = {str(stage): {"starts": 0, "clears": 0, "give_ups": 0} for stage in range(1, 11)}
    platforms = defaultdict(lambda: {"dau": 0, "opens": 0})
    locales = defaultdict(lambda: {"dau": 0, "opens": 0})
    sample_events: list[dict] = []

    for day in days:
        target = dau_for(day)
        newcomers = max(2, int(target * (0.55 - (day - START).days * 0.012)))
        for _ in range(newcomers):
            inst = new_instance(day, len(instances))
            instances.append(inst)
            returning.append(inst)

        pool = [row for row in returning if row["first_seen"] <= day.isoformat()]
        RNG.shuffle(pool)
        active = pool[:target]
        seen_platform: set[str] = set()
        seen_locale: set[str] = set()
        opens = 0
        starts = 0
        clears = 0
        give_ups = 0
        village = 0
        trial_shown = 0
        trial_send = 0
        settings = 0

        for inst in active:
            opens += 1
            funnel["app_open"] += 1
            platforms[inst["platform"]]["opens"] += 1
            locales[inst["locale"]]["opens"] += 1
            if inst["platform"] not in seen_platform:
                platforms[inst["platform"]]["dau"] += 1
                seen_platform.add(inst["platform"])
            if inst["locale"] not in seen_locale:
                locales[inst["locale"]]["dau"] += 1
                seen_locale.add(inst["locale"])

            hour = RNG.choice([8, 12, 13, 19, 20, 21, 22])
            stamp = datetime(
                day.year,
                day.month,
                day.day,
                hour,
                RNG.randint(0, 59),
                tzinfo=timezone.utc,
            )
            push_event(sample_events, stamp, inst, "app_open", {})

            if RNG.random() > 0.18:
                settings += 1
                funnel["settings_open"] += 1
                push_event(sample_events, stamp + timedelta(seconds=20), inst, "settings_open", {})

            if RNG.random() > 0.38:
                funnel["puzzle_start"] += 1
                starts += 1
                stage = 10 if RNG.random() < 0.12 else pick_stage()
                stages[str(stage)]["starts"] += 1
                push_event(
                    sample_events,
                    stamp + timedelta(minutes=1),
                    inst,
                    "puzzle_start",
                    {"difficulty": "easy", "stage": stage},
                )
                roll = RNG.random()
                if roll < clear_rate(stage):
                    stages[str(stage)]["clears"] += 1
                    clears += 1
                    funnel["puzzle_clear"] += 1
                    duration = 90 + stage * 35 + RNG.randint(0, 180)
                    push_event(
                        sample_events,
                        stamp + timedelta(seconds=duration),
                        inst,
                        "puzzle_clear",
                        {
                            "difficulty": "easy",
                            "stage": stage,
                            "duration_sec": duration,
                            "hints": RNG.choice([0, 0, 0, 1, 2]),
                        },
                    )
                    if stage == 10:
                        trial_shown += 1
                        funnel["trial_end_shown"] += 1
                        push_event(
                            sample_events,
                            stamp + timedelta(seconds=duration + 8),
                            inst,
                            "trial_end_shown",
                            {},
                        )
                        if RNG.random() < 0.38:
                            trial_send += 1
                            funnel["trial_end_send"] += 1
                            push_event(
                                sample_events,
                                stamp + timedelta(seconds=duration + 20),
                                inst,
                                "trial_end_send",
                                {},
                            )
                    if RNG.random() < 0.42:
                        village += 1
                        funnel["village_open"] += 1
                        push_event(
                            sample_events,
                            stamp + timedelta(seconds=duration + 40),
                            inst,
                            "village_open",
                            {},
                        )
                elif roll < clear_rate(stage) + 0.22:
                    stages[str(stage)]["give_ups"] += 1
                    give_ups += 1
                    funnel["puzzle_give_up"] += 1
                    push_event(
                        sample_events,
                        stamp + timedelta(minutes=4),
                        inst,
                        "puzzle_give_up",
                        {"difficulty": "easy", "stage": stage},
                    )

        daily.append(
            {
                "date": day.isoformat(),
                "dau": len(active),
                "new_instances": newcomers,
                "app_open": opens,
                "puzzle_start": starts,
                "puzzle_clear": clears,
                "puzzle_give_up": give_ups,
                "village_open": village,
                "trial_end_shown": trial_shown,
                "trial_end_send": trial_send,
                "settings_open": settings,
            }
        )

    sample_events.sort(key=lambda row: row["ts"])
    return {
        "meta": {
            "product": "starlight-sudoku",
            "package": "com.tychespark.starlightsudoku",
            "source": "seed",
            "identity": "anonymous_app_instance",
            "google_sign_in": False,
            "host": "vultr",
            "from": START.isoformat(),
            "to": END.isoformat(),
            "generated_at": "2026-09-04T02:00:00Z",
            "note": "Internal QA seed. Swap source to ga4 when the app sends Analytics.",
        },
        "overview": {
            "unique_instances": len(instances),
            "dau_last": daily[-1]["dau"],
            "dau_avg": round(sum(row["dau"] for row in daily) / len(daily), 1),
            "app_open": funnel["app_open"],
            "puzzle_start": funnel["puzzle_start"],
            "puzzle_clear": funnel["puzzle_clear"],
            "trial_end_shown": funnel["trial_end_shown"],
            "trial_end_send": funnel["trial_end_send"],
            "start_rate": ratio(funnel["puzzle_start"], funnel["app_open"]),
            "clear_rate": ratio(funnel["puzzle_clear"], funnel["puzzle_start"]),
            "trial_finish_rate": ratio(funnel["trial_end_shown"], funnel["puzzle_start"]),
            "review_send_rate": ratio(funnel["trial_end_send"], funnel["trial_end_shown"]),
        },
        "daily": daily,
        "funnel": [
            {"step": "app_open", "count": funnel["app_open"]},
            {"step": "puzzle_start", "count": funnel["puzzle_start"]},
            {"step": "puzzle_clear", "count": funnel["puzzle_clear"]},
            {"step": "village_open", "count": funnel["village_open"]},
            {"step": "trial_end_shown", "count": funnel["trial_end_shown"]},
            {"step": "trial_end_send", "count": funnel["trial_end_send"]},
        ],
        "stages": [
            {"stage": int(stage), "difficulty": "easy", **counts}
            for stage, counts in stages.items()
        ],
        "platforms": [
            {"platform": name, **platforms[name]} for name, _ in PLATFORMS
        ],
        "locales": [{"locale": name, **locales[name]} for name, _ in LOCALES],
        "events_sample": sample_events[-240:],
    }


def pick_stage() -> int:
    # Early stages dominate, but enough stage 10 so the trial-end funnel is visible.
    weights = [0.18, 0.14, 0.12, 0.11, 0.10, 0.09, 0.08, 0.07, 0.06, 0.05]
    return int(pick([(str(i + 1), w) for i, w in enumerate(weights)]))


def clear_rate(stage: int) -> float:
    return max(0.28, 0.86 - (stage - 1) * 0.055)


def ratio(num: int, den: int) -> float:
    if den == 0:
        return 0.0
    return round(num / den, 3)


def push_event(bucket: list[dict], ts: datetime, inst: dict, name: str, params: dict) -> None:
    bucket.append(
        {
            "ts": ts.isoformat().replace("+00:00", "Z"),
            "instance_id": inst["instance_id"],
            "platform": inst["platform"],
            "locale": inst["locale"],
            "event": name,
            "params": params,
        }
    )


def write_json(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def render_html(data: dict) -> str:
    payload = json.dumps(
        {
            "meta": data["meta"],
            "overview": data["overview"],
            "daily": data["daily"],
            "funnel": data["funnel"],
            "stages": data["stages"],
            "platforms": data["platforms"],
            "locales": data["locales"],
        },
        ensure_ascii=False,
    )
    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#0E2040">
  <title>별빛 스도쿠 · 시드 대시보드</title>
  <style>
    body {{ margin: 0; background: #0E2040; color: #FBF7EC; font-family: "Malgun Gothic", sans-serif; }}
    main {{ max-width: 960px; margin: 0 auto; padding: 40px 20px 80px; }}
    h1 {{ font-size: 1.5rem; margin: 0 0 6px; }}
    .meta {{ color: #C9D4E0; font-size: 0.85rem; }}
    .kpis {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 12px; margin: 24px 0; }}
    .card {{ background: #152a4d; padding: 14px 16px; border-radius: 8px; }}
    .card b {{ display: block; font-size: 1.35rem; color: #F5CC3D; }}
    .card span {{ font-size: 0.8rem; color: #C9D4E0; }}
    h2 {{ font-size: 1.05rem; margin: 28px 0 10px; }}
    table {{ width: 100%; border-collapse: collapse; font-size: 0.9rem; }}
    th, td {{ text-align: left; padding: 7px 6px; border-bottom: 1px solid #2a446c; }}
    .bar {{ height: 8px; background: #F5CC3D; border-radius: 4px; }}
    .row {{ display: flex; align-items: center; gap: 10px; margin: 6px 0; }}
    .label {{ width: 140px; font-size: 0.85rem; }}
  </style>
</head>
<body>
  <main>
    <p class="meta">티케웍스 · 별빛 스도쿠 · 익명 설치 ID · 가입 없음</p>
    <h1>초기 테스트 데이터</h1>
    <p class="meta" id="range"></p>
    <div class="kpis" id="kpis"></div>
    <h2>일자별 DAU</h2>
    <div id="daily"></div>
    <h2>퍼널</h2>
    <div id="funnel"></div>
    <h2>Easy 스테이지</h2>
    <table id="stages"></table>
  </main>
  <script>
    const DATA = {payload};
    document.getElementById('range').textContent =
      DATA.meta.from + ' ~ ' + DATA.meta.to + ' · source=' + DATA.meta.source;
    const o = DATA.overview;
    const kpis = [
      ['고유 설치', o.unique_instances],
      ['최근 DAU', o.dau_last],
      ['평균 DAU', o.dau_avg],
      ['퍼즐 시작률', Math.round(o.start_rate * 100) + '%'],
      ['클리어율', Math.round(o.clear_rate * 100) + '%'],
      ['10판 도달', Math.round(o.trial_finish_rate * 100) + '%'],
    ];
    document.getElementById('kpis').innerHTML = kpis.map(([k, v]) =>
      '<div class="card"><b>' + v + '</b><span>' + k + '</span></div>'
    ).join('');
    const maxDau = Math.max(...DATA.daily.map(d => d.dau));
    document.getElementById('daily').innerHTML = DATA.daily.map(d =>
      '<div class="row"><div class="label">' + d.date.slice(5) + ' · ' + d.dau +
      '</div><div class="bar" style="width:' + (d.dau / maxDau * 100) + '%"></div></div>'
    ).join('');
    const maxFunnel = DATA.funnel[0].count;
    document.getElementById('funnel').innerHTML = DATA.funnel.map(s =>
      '<div class="row"><div class="label">' + s.step + ' · ' + s.count +
      '</div><div class="bar" style="width:' + (s.count / maxFunnel * 100) + '%"></div></div>'
    ).join('');
    document.getElementById('stages').innerHTML =
      '<tr><th>스테이지</th><th>시작</th><th>클리어</th><th>포기</th></tr>' +
      DATA.stages.map(s => '<tr><td>Easy ' + s.stage + '</td><td>' + s.starts +
      '</td><td>' + s.clears + '</td><td>' + s.give_ups + '</td></tr>').join('');
  </script>
</body>
</html>
"""


def main() -> None:
    data = simulate()
    write_json(SEED_DIR / "overview.json", {"meta": data["meta"], **data["overview"]})
    write_json(SEED_DIR / "daily.json", {"meta": data["meta"], "rows": data["daily"]})
    write_json(SEED_DIR / "funnel.json", {"meta": data["meta"], "steps": data["funnel"]})
    write_json(SEED_DIR / "stages.json", {"meta": data["meta"], "rows": data["stages"]})
    write_json(SEED_DIR / "platforms.json", {"meta": data["meta"], "rows": data["platforms"]})
    write_json(SEED_DIR / "locales.json", {"meta": data["meta"], "rows": data["locales"]})
    write_json(SEED_DIR / "events.sample.json", {"meta": data["meta"], "rows": data["events_sample"]})
    PUBLIC_DIR.mkdir(parents=True, exist_ok=True)
    (PUBLIC_DIR / "index.html").write_text(render_html(data), encoding="utf-8")
    print(json.dumps(data["overview"], ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
