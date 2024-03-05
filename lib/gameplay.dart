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
  int rows = 12;
  int columns = 8;
  int totalMines = 7;
  List<List<TypeSquare>> grid = [];

  @override
  void initState() {
    super.initState();
    _initializeGrid();
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
                                const Text(
                                  "0:13.37",
                                  style: TextStyle(
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
                                    const Text(
                                      "X14",
                                      style: TextStyle(
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
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: typesquare.isOpen
                                    ? Colors.white
                                    : typesquare.isFlagged
                                    ? Colors.deepPurple
                                    : Colors.purple,
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 4,
                                      offset: Offset(-4, 4),
                                      color: Colors.white
                                  ),
                                  BoxShadow(
                                      blurRadius: 4,
                                      offset: Offset(4, 4),
                                      color: Colors.lightBlue
                                  ),
                                ]
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
                                ),
                              ),
                            ),
                          ),
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