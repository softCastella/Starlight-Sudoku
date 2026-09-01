import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_game/presentation/notifiers/game_notifier.dart';
import 'package:sudoku_game/presentation/widgets/sudoku_cell_widget.dart';

/// Sudoku 게임 보드 전체 위젯 (9x9 그리드)
class SudokuBoardWidget extends StatefulWidget {
  final VoidCallback onCellSelected;

  const SudokuBoardWidget({
    super.key,
    required this.onCellSelected,
  });

  @override
  State<SudokuBoardWidget> createState() => SudokuBoardWidgetState();
}

class SudokuBoardWidgetState extends State<SudokuBoardWidget> {
  int? _selectedRow;
  int? _selectedCol;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameNotifier>(
      builder: (context, gameNotifier, _) {
        final board = gameNotifier.board;
        final invalidCells = gameNotifier.invalidCells.toList().toSet();

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: GridView.count(
                crossAxisCount: 9,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(81, (index) {
                  final row = index ~/ 9;
                  final col = index % 9;
                  final value = board.getValue(row, col);
                  final isFixed = board.isFixedCell(row, col);
                  final isInvalid = invalidCells.contains((row, col));
                  final isSelected = _selectedRow == row && _selectedCol == col;
                  final memos = board.getMemo(row, col);

                  return SudokuCellWidget(
                    row: row,
                    col: col,
                    value: value,
                    memos: memos,
                    isFixed: isFixed,
                    isInvalid: isInvalid,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedRow = row;
                        _selectedCol = col;
                      });
                      widget.onCellSelected();
                    },
                    onLongPress: () {
                      // 장시간 누르면 힌트 표시
                      if (value == 0) {
                        gameNotifier.showHint(row, col);
                      }
                    },
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  int? getSelectedRow() => _selectedRow;
  int? getSelectedCol() => _selectedCol;

  void clearSelection() {
    setState(() {
      _selectedRow = null;
      _selectedCol = null;
    });
  }
}
