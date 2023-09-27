import 'package:flutter/material.dart';

class MyCircleAvatar extends StatefulWidget {
  const MyCircleAvatar(
      {Key? key,
      required this.size,
      required this.img,
      required this.borderImage,
      required this.borderWidth})
      : super(key: key);
  final double size;
  final String img;
  final String borderImage;
  final double borderWidth;
  @override
  State<MyCircleAvatar> createState() => _MyCircleAvatarState();
}

class _MyCircleAvatarState extends State<MyCircleAvatar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
          child: CircleAvatar(
        radius: widget.size + widget.borderWidth,
        backgroundImage: AssetImage(widget.borderImage),
        child: CircleAvatar(
          radius: widget.size,
          backgroundImage: AssetImage(widget.img),
        ),
      )),
    );
  }
}
