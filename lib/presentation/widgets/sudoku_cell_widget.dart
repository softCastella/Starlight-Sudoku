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
  final bool isLineHint;
  final bool isSameNumber;
  final bool showFocusRing;
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
    this.isLineHint = false,
    this.isSameNumber = false,
    this.showFocusRing = false,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
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
            child: value == 0 ? _buildMemoGrid() : _buildValueDisplay(),
          ),
          if (showFocusRing)
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.fromBorderSide(
                    BorderSide(color: Color(0xFFFFFFFF), width: 2.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCellColor() {
    if (isInvalid) return const Color(0xFFFFD9D2);
    if (isSelected) return const Color(0xFFFFF0BB);
    if (isSameNumber) return const Color(0xFFFFF0BB);
    if (isLineHint) return const Color(0xFFFFF6D4);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final fontSize = (constraints.maxHeight / 6).clamp(9.0, 14.0);
        const style = TextStyle(
          color: Color(0xFF69766D),
          fontWeight: FontWeight.w700,
          height: 1,
        );
        Widget column(List<int?> numbers) {
          return Expanded(
            child: Column(
              children: [
                for (final number in numbers)
                  Expanded(
                    child: Center(
                      child: number != null && memos.contains(number)
                          ? FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$number',
                                style: style.copyWith(fontSize: fontSize),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          child: Row(
            children: [
              column(const [1, 2, 3, 4, 5]),
              column(const [6, 7, 8, 9, null]),
            ],
          ),
        );
      },
    );
  }
}
