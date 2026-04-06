import 'package:flutter/material.dart';
import 'screen/homeScreen.dart';
import 'screen/recipeScreen.dart';
import 'screen/detailRecipe.dart';
import 'screen/detailReport.dart';
import 'screen/trendScreen.dart';
import 'screen/alarmScreen.dart';
import 'screen/reportScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/homeScreen': (context) => HomeScreen(),
        '/recipeScreen': (context) => RecipeScreen(),
        '/detailRecipe': (context) => DetailRecipe(),
        '/trendScreen': (context) => TrendScreen(),
        '/alarmScreen': (context) => AlarmScreen(),
        '/reportScreen': (context) => ReportScreen(),
        '/detailReport': (context) => DetailReport(),
      },
      home: const DetailReport(),
    );
  }
}
