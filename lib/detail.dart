import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/todo.dart';

themeSelect<T>(BuildContext context, T light, T dart) {
  return Theme.of(context).brightness == Brightness.dark ? dart : light;
}

class Todos extends StatefulWidget {
  final int index;
  Todos(this.index, {Key? key}) : super(key: key);

  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var group = context.read<TodoProvider>().groups.elementAt(widget.index);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.wallet_giftcard),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        value: 0.4,
                        color: Color(0xff9E579D),
                        backgroundColor: themeSelect(
                            context, Colors.black12, Colors.white70),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: themeSelect(
                                  context, Colors.grey, Colors.white60)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "2 / 4 tasks",
                            style: TextStyle(
                              fontSize: 15,
                              color: themeSelect(
                                  context, Colors.black54, Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: group.todos.isEmpty ? buildEmpty() : buildTodoList()),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: double.infinity,
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Enter Todo",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        setState(() {
                          group.addTodo(Todo(_controller.text));
                          _controller.clear();
                          FocusNode().unfocus();
                        });
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        // color: Color(0xff9E579D),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            group.color,
                            group.color.withRed(100),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Container(
        child: Text(
          "No Todo's Yet",
          style: TextStyle(
            color: themeSelect(context, Colors.black54, Colors.white70),
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget buildTodoList() {
    var group = context.read<TodoProvider>().groups.elementAt(widget.index);
    var todos = group.todos;
    return Container(
      child: ListView.builder(
        itemCount: todos.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => TodoItem(
          todos.elementAt(index),
          color: group.color,
          onToggle: () {
            setState(() {
              todos.elementAt(index).toggleDone();
            });
          },
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Color color;
  final void Function()? onToggle;
  const TodoItem(
    this.todo, {
    Key? key,
    this.onToggle,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onToggle!();
      },
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: todo.isCompleted
              ? themeSelect(context, Colors.black.withOpacity(0.1),
                  Colors.white.withOpacity(0.1))
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.all(5),
        child: Row(
          children: [
            Checkbox(
              value: todo.isCompleted,
              fillColor: MaterialStateProperty.all(color.withRed(50)),
              onChanged: (_) {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      todo.text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      "Mon, Apr 6",
                      style: TextStyle(
                        color: themeSelect(
                            context, Colors.black54, Colors.white70),
                      ),
                    ),
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
