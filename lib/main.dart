import 'package:flutter/material.dart';

import 'package:kleiner_tracker/widget/botton_navigation.dart';
import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedLabelStyle: TextStyle(color: Colors.grey))),
      home: const TrackerBottonBar(),
    );
  }
}
