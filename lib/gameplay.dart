import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saper/components/bg.dart';
import 'package:saper/model/type-square.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  String hoursString = '00',
      minuteString = '00',
      secondString = '00';

  int hours = 0,
      minutes = 0,
      seconds = 0;

  void startTimer() {
    Timer.periodic(
        const Duration(seconds: 1),
            (timer) {
          _startSecond();
        }
    );
  }

  void _startSecond() {
    setState(() {
      if (seconds < 59) {
        seconds++;
        secondString = seconds.toString();
        if (secondString.length == 1) {
          secondString = "0" + secondString;
        }
      } else {
        _startMinute();
      }
    });
  }

  void _startMinute() {
    setState(() {
      if (minutes < 59) {
        seconds = 0;
        secondString = "00";
        minutes++;
        minuteString = minutes.toString();
        if (minuteString.length == 1) {
          minuteString = "0" + minuteString;
        }
      } else {
        _startHour();
      }
    });
  }

  void _startHour() {
    setState(() {
      seconds = 0;
      minutes = 0;
      secondString = "00";
      minuteString = "00";
      hours++;
      hoursString = hours.toString();
      if (hoursString.length == 1) {
        hoursString = "0" + hoursString;
      }
    });
  }

  int rows = 12;
  int columns = 8;
  int totalMines = 10;
  List<List<TypeSquare>> grid = [];
  int flag = 10;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    startTimer();
  }

  void _initializeGrid() {
    grid = List.generate(
        rows, (row) =>
        List.generate(
            columns, (col) => TypeSquare(row: row, col: col)
        )
    );

    final random = Random();
    int count = 0;
    while (count < totalMines) {
      int randomRow = random.nextInt(rows);
      int randomCol = random.nextInt(columns);
      if (!grid[randomRow][randomCol].hasMine) {
        grid[randomRow][randomCol].hasMine = true;
        count++;
      }

      for (int row = 0; row < rows; row++) {
        for (int col = 0; col < columns; col++) {
          if (grid[row][col].hasMine) continue;

          int adjacentMines = 0;
          for (final dir in direction) {
            int newRow = row + dir.dy.toInt();
            int newCol = col + dir.dx.toInt();

            if (_isValidTypeSquare(newRow, newCol) &&
                grid[newRow][newCol].hasMine) {
              adjacentMines++;
            }
          }

          grid[row][col].adjacentMines = adjacentMines;
        }
      }
    }
  }

  final direction = [
    const Offset(-1, -1),
    const Offset(-1, 0),
    const Offset(-1, 1),
    const Offset(0, -1),
    const Offset(0, 1),
    const Offset(1, -1),
    const Offset(1, 0),
    const Offset(1, 1),
  ];

  bool _isValidTypeSquare(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < columns;
  }

  void _handleTypeSquareTap(TypeSquare typesquare) {
    if (gameOver || typesquare.isOpen || typesquare.isFlagged) return;

    setState(() {
      typesquare.isOpen = true;

      if (typesquare.hasMine) {
        gameOver = true;
        for (final row in grid) {
          for (final cell in row) {
            if (cell.hasMine) {
              cell.isOpen = true;
            }
          }
        }
        showSnackBar(context, message: "YOU sUCK");
      } else if (_checkForWin()) {
        gameOver = true;

        for (final row in grid) {
          for (final cell in row) {
            cell.isOpen = true;
          }
        }
        showSnackBar(context, message: "YOU sWIN");
      } else if (typesquare.adjacentMines == 0) {
        _openAdjacentCells(typesquare.row, typesquare.col);
      }
    });
  }

  bool _checkForWin() {
    for (final row in grid) {
      for (final cell in row) {
        if (!cell.hasMine && !cell.isOpen) {
          return false;
        }
      }
    }

    return true;
  }

  void _openAdjacentCells(int row, int col) {
    for (final dir in direction) {
      int newRow = row + dir.dy.toInt();
      int newCol = col + dir.dx.toInt();

      if (_isValidTypeSquare(newRow, newCol) &&
          !grid[newRow][newCol].hasMine &&
          !grid[newRow][newCol].isOpen) {
        setState(() {
          grid[newRow][newCol].isOpen = true;
          if (grid[newRow][newCol].adjacentMines == 0) {
            _openAdjacentCells(newRow, newCol);
          }
        });
      }
    }

    if (gameOver) return;

    if (_checkForWin()) {
      gameOver = true;
      for (final row in grid) {
        for (final cell in row) {
          if (cell.hasMine) {
            cell.isOpen = true;
          }
        }
      }
      showSnackBar(context, message: "YOU sWIN");
    }
  }

  void _handleTypeSquareLongPress(TypeSquare typesquare) {
    if (typesquare.isOpen) return;
    if (flag <= 0 && !typesquare.isFlagged) return;

    setState(() {
      typesquare.isFlagged = !typesquare.isFlagged;

      if (typesquare.isFlagged) {
        flag--;
      } else {
        flag++;
      }
    });
  }

  void _reset() {
    setState(() {
      grid = [];
      gameOver = false;
      flag = 10;
    });

    _initializeGrid();
  }

  void showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const MainScreen(backG: "assets/images/bg-gameplay.png",),
          SizedBox(
              height: theme.size.height,
              width: theme.size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: theme.size.height / 5.5,
                      width: theme.size.width / 1.2,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/appbar-bg.png"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50,
                            left: 20,
                            right: 20,
                            bottom: 10
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/smile-good.png",
                                      height: 35,
                                    ),
                                    Image.asset(
                                      "assets/images/smile-bad.png",
                                      height: 35,
                                    ),
                                    Image.asset(
                                      "assets/images/smile-bad.png",
                                      height: 35,
                                    ),
                                    Image.asset(
                                      "assets/images/smile-bad.png",
                                      height: 35,
                                    ),
                                    Image.asset(
                                      "assets/images/smile-bad.png",
                                      height: 35,
                                    ),
                                  ],
                                ),
                                Text(
                                  "$hoursString:$minuteString:$secondString",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/purple-h.png",
                                      height: 25,
                                    ),
                                    Image.asset(
                                      "assets/images/purple-h.png",
                                      height: 25,
                                    ),
                                    Image.asset(
                                      "assets/images/pink-h.png",
                                      height: 25,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/flag.png",
                                      height: 25,
                                    ),
                                    Text(
                                      "X$flag",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                        right: 30,
                        left: 30
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: rows * columns,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        final int row = index ~/ columns;
                        final int col = index % columns;
                        final typesquare = grid[row][col];

                        return GestureDetector(
                            onTap: () => _handleTypeSquareTap(typesquare),
                            onLongPress: () =>
                                _handleTypeSquareLongPress(typesquare),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: typesquare.isOpen
                                      ? const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/purple_saper.png"),
                                      fit: BoxFit.cover
                                  )
                                      : typesquare.isFlagged
                                      ? const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/green_saper.png"),
                                      fit: BoxFit.cover
                                  )
                                      : const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/green_saper.png"),
                                      fit: BoxFit.cover
                                  ),
                                  color: typesquare.isOpen
                                      ? Colors.purple
                                      : typesquare.isFlagged
                                      ? Colors.green
                                      : Colors.green,
                                ),
                                child: Center(
                                  child: Text(
                                    typesquare.isOpen
                                        ? typesquare.hasMine
                                        ? '💣'
                                        : typesquare.adjacentMines.toString()
                                        : typesquare.isFlagged
                                        ? '🏴'
                                        : '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: typesquare.isFlagged ? 24 : 18,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
