import 'package:flutter/material.dart';
import 'package:kleiner_tracker/screens/onboarding_page.dart';


import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/widget/globalvariables.dart';
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
      home:  OnboardingPage(
        pages: [
          OnboardingPageModel(
            title: 'Tracke deine Aktioen',
            description:
                'Tracke deine Aktionen und die Zeit',
            image: 'assets/bild1.png',
           bgColor:  GlobalVariables.backgroundColor,
          ),
          OnboardingPageModel(
            title: 'Anzahl und Durchschnitt',
            description: 'Sehe die Anzahl pro Tag und die durchschnittliche Zeit',
            image: 'assets/bild2.png',
            bgColor:  GlobalVariables.backgroundColor,
          ),
         
        ],
      ),
    );
  }
}
