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
              color: Colors.black87,
            ),
            left: BorderSide(
              width: col % 3 == 0 ? 2.0 : 0.5,
              color: Colors.black87,
            ),
            right: BorderSide(
              width: col == 8 ? 2.0 : 0.5,
              color: Colors.black87,
            ),
            bottom: BorderSide(
              width: row == 8 ? 2.0 : 0.5,
              color: Colors.black87,
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
    if (isInvalid) return Colors.red.withValues(alpha: 0.3);
    if (isSelected) return Colors.blue.withValues(alpha: 0.3);
    if (isFixed) return Colors.grey.withValues(alpha: 0.1);
    return Colors.white;
  }

  Widget _buildValueDisplay() {
    return Center(
      child: Text(
        '$value',
        style: TextStyle(
          fontSize: 24,
          fontWeight: isFixed ? FontWeight.bold : FontWeight.w500,
          color: isFixed ? Colors.black87 : Colors.blue[700],
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
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }
}
