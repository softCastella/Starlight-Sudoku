import 'package:flutter/material.dart';

/// Sudoku 게임 보드의 개별 셀 위젯
class SudokuCellWidget extends StatelessWidget {
  final int row;
  final int col;
  final int value;
  final List<int> memos;
  final bool isFixed;
  final bool isInvalid;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SudokuCellWidget({
    super.key,
    required this.row,
    required this.col,
    required this.value,
    required this.memos,
    required this.isFixed,
    required this.isInvalid,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: row % 3 == 0 ? 2.0 : 0.5,
              color: const Color(0xFF315042),
            ),
            left: BorderSide(
              width: col % 3 == 0 ? 2.0 : 0.5,
              color: const Color(0xFF315042),
            ),
            right: BorderSide(
              width: col == 8 ? 2.0 : 0.5,
              color: const Color(0xFF315042),
            ),
            bottom: BorderSide(
              width: row == 8 ? 2.0 : 0.5,
              color: const Color(0xFF315042),
            ),
          ),
          color: _getCellColor(),
        ),
        child: value == 0
            ? _buildMemoGrid()
            : _buildValueDisplay(),
      ),
    );
  }

  Color _getCellColor() {
    if (isInvalid) return const Color(0xFFFFD9D2);
    if (isSelected) return const Color(0xFFFFF0BB);
    if (isFixed) return const Color(0xFFEAF0E6);
    return const Color(0xFFFFFDF8);
  }

  Widget _buildValueDisplay() {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$value',
          style: TextStyle(
            fontSize: 34,
            fontWeight: isFixed ? FontWeight.bold : FontWeight.w700,
            color: isFixed
                ? const Color(0xFF24452D)
                : isInvalid
                    ? const Color(0xFFB85C38)
                    : const Color(0xFF2A8A4A),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoGrid() {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.all(2),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: List.generate(9, (index) {
        final number = index + 1;
        final hasMemo = memos.contains(number);
        return Center(
          child: Text(
            hasMemo ? '$number' : '',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF69766D),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }
}
