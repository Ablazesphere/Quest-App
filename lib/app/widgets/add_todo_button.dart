import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../custom_rect_tween.dart';
import '../routes/hero_dialog.routes.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class AddTodoButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddTodoButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _AddTodoPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Colors.blueGrey,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class _AddTodoPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  const _AddTodoPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.blueGrey,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: GestureDetector(
                            onTap: () {
                              print("Add a video picker widget");
                            },
                            child: Container(
                              color: Colors.grey[600],
                              child: Column(
                                children: const [
                                  SizedBox(height: 50),
                                  Icon(
                                    Icons.video_file_rounded,
                                    size: 56,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Upload Video",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10, left: 10, right: 10),
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          decoration: InputDecoration(
                              hintText: 'Click to add title',
                              border: InputBorder.none,
                              counterText: ""),
                          cursorColor: Colors.white,
                          maxLines: 2,
                          maxLength: 80,
                        ),
                      ),
                      const Divider(
                        indent: 5,
                        endIndent: 5,
                        color: Colors.white,
                        thickness: 0.2,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 15, bottom: 10, left: 10, right: 10),
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Click to add description',
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                          maxLines: 14,
                          maxLength: 800,
                        ),
                      ),
                      const Divider(
                        indent: 5,
                        endIndent: 5,
                        color: Colors.white,
                        thickness: 0.2,
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          print("Upload script button pressed.");
                        },
                        child: Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(right: 100),
                            height: 50,
                            child: Card(
                              elevation: 5,
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.file_present_rounded,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text("Click to upload your script")
                                ],
                              ),
                            )),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          print("Submit button pressesd.");
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 50,
                          color: Colors.grey[800],
                          child: Text(
                            'Submit.',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                              .animate(
                                onPlay: (controller) =>
                                    controller.repeat(reverse: true),
                              )
                              .shimmer(
                                  color: Colors.blue,
                                  duration: Duration(seconds: 3)),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
