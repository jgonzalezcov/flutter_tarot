// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class BallWidget extends StatefulWidget {
  const BallWidget({Key? key});

  @override
  BallWidgetState createState() => BallWidgetState();
}

class BallWidgetState extends State<BallWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Center(
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: animation.value * 2 * 3.14159265359,
              child: child,
            );
          },
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/imgs/bola2.gif'),
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color.fromARGB(255, 14, 129, 18),
                width: 0.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.remove_red_eye_sharp,
                    size: 30,
                    color: Color.fromARGB(255, 27, 207, 42),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
