import 'package:flutter/material.dart';
import 'package:kleiner_tracker/screens/onboarding_page.dart';


import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/widget/botton_navigation.dart';
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
    final provider = Provider.of<TrackerProvider>(context, listen: false);
    
    return MaterialApp(color: GlobalVariables.backgroundColor,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedLabelStyle: TextStyle(color: Colors.grey))),
      home: FutureBuilder<bool>(
        future: provider.isFirstTime(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!) {
              return OnboardingPage(
                pages: [
                  OnboardingPageModel(
                    title: 'Tracke deine Aktioen',
                    description: 'Tracke deine Aktionen und die Zeit',
                    image: 'assets/anzahl1.png',
                    bgColor: GlobalVariables.backgroundColor,
                  ),
                  OnboardingPageModel(
                    title: 'Anzahl und Durchschnitt',
                    description:
                        'Sehe die Anzahl pro Tag und die durchschnittliche Zeit',
                    image: 'assets/bild2.png',
                    bgColor: GlobalVariables.backgroundColor,
                  ),
                ],
              );
            } else {
              // Rückgabe deines normalen Home-Screens oder einer anderen Seite
              return const TrackerBottonBar();
            }
          } else {
            return const Scaffold(backgroundColor: GlobalVariables.backgroundColor,
              body: Center(child: CircularProgressIndicator(color: Colors.yellow,)),
            );
          }
        },
      ),
    );
  }
}
