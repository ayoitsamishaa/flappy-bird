import 'dart:async';
import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameStarted = false;
  double barrierX1 = 0.8;
  double barrierX2 = 2;
  double barrierX3 = 3.2;
  String score = "0";
  String best = "0";
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  // barrier variables

  static List<double> barrierX = [1.2, 1.2 + 1.2, 1.2 + 1.2 + 1.2];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // [top height, bottom height]
    [0.5, 0.46],
    [0.6, 0.55],
    [0.4, 0.65]
  ];

  void move() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.05;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3.7;
      }
    }
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2 * time;
      setState(() {
        barrierX1 -= 0.05;
        barrierX2 -= 0.05;
        barrierX3 -= 0.05;
        birdYaxis = initialHeight - height;
      });
// barriers
      setState(() {
        if (barrierX1 < -2) {
          barrierX1 += 3.5;
        } else {
          barrierX1 -= 0.04;
        }
      });

      setState(() {
        if (barrierX2 < -2) {
          barrierX2 += 3.5;
        } else {
          barrierX2 -= 0.04;
        }
      });

      setState(() {
        if (barrierX3 < -2) {
          barrierX3 += 3.5;
        } else {
          barrierX3 -= 0.04;
        }
      });
//  if bird is dead timer is cancelled
      if (deadBird()) {
        timer.cancel();
        gameStarted = false;
        dialog();
      }

      updateScore();
      move();
    });
  }

//  resets the game

  void resetGame() {
    // dismisses the alert dialogue
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      score = "0";
      barrierX = [1.2, 1.2 + 1.2, 1.2 + 1.2 + 1.2];
    });
  }

  void updateScore() {
    if (barrierX1 < -0.5 && barrierX1 > -0.55) {
      setState(() {
        score = (int.parse(score) + 1).toString();
      });
    }
    if (barrierX2 < -0.5 && barrierX2 > -0.55) {
      setState(() {
        score = (int.parse(score) + 1).toString();
      });
    }
    if (barrierX3 < -0.5 && barrierX3 > -0.55) {
      setState(() {
        score = (int.parse(score) + 1).toString();
      });
    }

    // Update best score if current score exceeds best
    if (int.parse(score) > int.parse(best)) {
      best = score;
    }
  }

//  content for when bird dies
  void dialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown[900],
            title: const Center(
              child: Text(
                'G A M E  O V E R',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ),
            content: Text(
              'SCORE: ' + score.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.greenAccent),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15.0),
                    color: Colors.greenAccent,
                    child: const Text(
                      'PLAY  AGAIN',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

//  checks if bird is dead
  bool deadBird() {
    if (birdYaxis > 1 || birdYaxis < -1) {
      return true;
    }

    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYaxis <= -1 + barrierHeight[i][0] ||
              birdYaxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  //  bird object

                  AnimatedContainer(
                    alignment: Alignment(0.0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue[400],
                    child: Bird(
                      birdHeight: birdHeight,
                      birdWidth: birdWidth,
                      birdY: birdYaxis,
                    ),
                  ),

                  // tap to play text

                  Container(
                    alignment: Alignment(0, 0.27),
                    child: gameStarted
                        ? Text(" ")
                        : Text(
                            "T A P  T O  P L A Y",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                  ),

                  // first bottom barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX1, 1.3),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[0][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[0],
                      isBottom: true,
                    ),
                  ),

                  // first upper barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX1, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[0][0],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[0],
                      isBottom: false,
                    ),
                  ),

                  // second bottom barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX2, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[1][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[1],
                      isBottom: true,
                    ),
                  ),

                  // second upper barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX2, -1.2),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[1][0],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[1],
                      isBottom: false,
                    ),
                  ),

                  //  third upper barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX3, -1.2),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[2][0],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[2],
                      isBottom: false,
                    ),
                  ),

                  //  third bottom barrier

                  AnimatedContainer(
                    alignment: Alignment(barrierX3, 1.3),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      barrierHeight: barrierHeight[2][1],
                      barrierWidth: barrierWidth,
                      barrierX: barrierX[2],
                      isBottom: true,
                    ),
                  ),
                ],
              ),
            ),

            //  the little green area

            Container(
              height: 20,
              color: Colors.greenAccent,
            ),

            //  score board

            Expanded(
              child: Container(
                color: Colors.brown[700],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SCORE',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          score,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'BEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          best,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
