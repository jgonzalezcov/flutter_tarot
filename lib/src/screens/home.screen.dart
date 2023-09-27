import 'package:flutter/material.dart';

import 'package:tarot/src/widgets/ball.widget.dart';
import 'package:tarot/src/widgets/question.widget.dart';

import 'package:tarot/src/widgets/circle_avatar.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/imgs/fondo4.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const BallWidget(),
                  const MyCircleAvatar(
                    size: 100,
                    img: 'assets/imgs/medita.gif',
                    borderImage: 'assets/imgs/circle.gif',
                    borderWidth: 40,
                  ),
                  const Center(
                    child: Text(
                      'EL Oráculo',
                      style: TextStyle(
                        fontFamily: 'Kaushan',
                        color: Colors.white,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const QuestionWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
