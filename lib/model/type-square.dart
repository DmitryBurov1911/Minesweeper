class TypeSquare {
  final int row;
  final int col;

  bool hasMine;
  bool isOpen;
  bool isFlagged;
  int adjacentMines;

  TypeSquare({
    required this.row,
    required this.col,
    this.isFlagged = false,
    this.hasMine = false,
    this.isOpen = true,
    this.adjacentMines = 0,
  });
}