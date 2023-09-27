import 'package:flutter/material.dart';
import 'package:tarot/src/provider/api_resp.provider.dart';
import 'package:tarot/src/provider/card_view.provider.dart';
import 'package:tarot/src/provider/sensor_state.provider.dart';
import 'package:tarot/src/provider/type_read.provider.dart';
import 'package:tarot/src/routes/app.routes.dart';
import 'package:tarot/src/screens/home.screen.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => TypeReadProvider()),
        ChangeNotifierProvider(create: (_) => OpenAIProvider()),
        ChangeNotifierProvider(create: (_) => SensorStateProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tarot',
        initialRoute: AppRoutes.initialRouter,
        routes: AppRoutes.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
