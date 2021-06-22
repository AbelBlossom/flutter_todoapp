import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/detail.dart';
import 'package:todoapp/providers/todo.dart';

class TodoGroupView extends StatefulWidget {
  const TodoGroupView({Key? key}) : super(key: key);

  @override
  _TodoGroupViewState createState() => _TodoGroupViewState();
}

class _TodoGroupViewState extends State<TodoGroupView> {
  @override
  Widget build(BuildContext context) {
    var groups = context.watch<TodoProvider>().groups;
    return Container(
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: groups.isEmpty
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: buildEmptyPlaceHolder(),
        secondChild: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 5 / 6,
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: groups.asMap().keys.map((e) => buildGroup(e)).toList(),
        ),
      ),
    );
  }

  Widget buildEmptyPlaceHolder() {
    return Container(
      child: Text("No Groups Yet"),
    );
  }

  Widget buildGroup(int index) {
    var random = Random().nextDouble();
    var group = context.read<TodoProvider>().groups.elementAt(index);
    return GestureDetector(
      onTap: () => Navigator.push(
          context, CupertinoPageRoute(builder: (_) => Todos(index))),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              group.color,
              group.color.withRed(100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.rotate(
                      angle: 180 * pi / 180,
                      child: CircularProgressIndicator(
                        value: random,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "${((random / 1) * 100).toInt()}",
                        style: TextStyle(
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "0/0 completed",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white30,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
              child: Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 45,
                bottom: 10,
                left: 10,
              ),
              child: Container(
                padding: EdgeInsets.all(6),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "+ open",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
