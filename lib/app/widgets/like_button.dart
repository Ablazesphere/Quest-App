import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LikeButton extends StatefulWidget {
  late bool liked;
  LikeButton({super.key, required this.liked});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.liked = !widget.liked;
          });
        },
        child: RiveAnimation.asset(
          "assets/like.riv",
          animations: [widget.liked ? 'check' : 'back'],
        ),
      ),
    );
  }
}
