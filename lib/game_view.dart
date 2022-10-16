import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class GameView extends StatefulWidget {
  GameView({super.key, this.level = 1});
  int level;
  var l1 = [];
  var l2 = [];
  int score = 0;
  bool isLeftClicked = false;
  int leftPoint = -1;
  int tries = 3;
  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  void generateOnce() {
    widget.score = 0;
    widget.tries = 3;
    widget.leftPoint = -1;
    widget.isLeftClicked = false;

    widget.l1 = List.generate(widget.level * 5, (_) => _);
    widget.l2.clear();
    widget.l1.shuffle();
    widget.l2.addAll(widget.l1);
    widget.l2.shuffle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.l1.isEmpty) {
      generateOnce();
      setState(() {});
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Text("Level ${widget.level}"),
        Text("Score ${widget.score}"),
        Text("Tries Left ${widget.tries}"),
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: width * .49,
              height: height * .9,
              child: ListView.builder(
                itemCount: widget.l1.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: width * .49,
                        height: height * .15,
                        child: ElevatedButton(
                          onPressed: () {
                            print(index);
                            widget.isLeftClicked = !widget.isLeftClicked;
                            widget.leftPoint = widget.l1[index];
                            setState(() {});
                          },
                          child: Text(
                            "Image ${widget.l1[index]}",
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              width: width * .49,
              height: height * .9,
              child: ListView.builder(
                itemCount: widget.l2.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: width * .49,
                        height: height * .15,
                        child: ElevatedButton(
                          onPressed: () {
                            print(index);
                            if (widget.isLeftClicked) {
                              if (widget.leftPoint == widget.l2[index]) {
                                widget.score++;
                                widget.l1.remove(widget.leftPoint);
                                widget.l2.remove(widget.leftPoint);
                              } else {
                                widget.tries--;
                              }
                              widget.leftPoint = -1;
                              widget.isLeftClicked = false;
                              setState(() {});

                              if (widget.tries == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Out of tries. Game Over")));

                                generateOnce();
                              }
                              if (widget.score == widget.level * 5) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Level ${widget.level} Cleared. Level  ${widget.level + 1} Started")));
                                widget.level = widget.level + 1;
                                generateOnce();
                              }
                            }
                          },
                          child: Text(
                            "Image ${widget.l2[index]}",
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
