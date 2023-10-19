import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerProvider with ChangeNotifier {

  List<DateTime?> timestamps = [];


  Map<String, List<DateTime>> timestampsPerDay = {};

void addTimestampDay() {
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  if (!timestampsPerDay.containsKey(today)) {
    timestampsPerDay[today] = [];
  }
  timestampsPerDay[today]!.insert(0, DateTime.now());

  _saveDataDay();
  notifyListeners();
}

void _saveDataDay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  Map<String, List<String>> stringData = {};
  timestampsPerDay.forEach((key, value) {
    stringData[key] = value.map((e) => e.toIso8601String()).toList();
  });

  await prefs.setString('timestampsPerDay', json.encode(stringData));
  notifyListeners();
}

// Beim Laden
void loadDataDay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedData = prefs.getString('timestampsPerDay');
  if (storedData != null) {
    Map<String, dynamic> rawMap = json.decode(storedData);
    rawMap.forEach((key, value) {
      timestampsPerDay[key] = (value as List).map((e) => DateTime.parse(e)).toList();
    });
  }
 
  notifyListeners();
}


  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedTimestamps = prefs.getStringList('timestamps') ?? [];
    timestamps = storedTimestamps.map((e) => DateTime.parse(e)).toList();
    notifyListeners(); // Informiere die Widgets über die Änderungen
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'timestamps', timestamps.map((e) => e!.toIso8601String()).toList());
          notifyListeners();
  }

  void addTimestamp() {
  DateTime now = DateTime.now();
  timestamps.insert(0, now);

  // Zeitstempel zu timestampsPerDay hinzufügen
  String today = DateFormat('yyyy-MM-dd').format(now);
  if (!timestampsPerDay.containsKey(today)) {
    timestampsPerDay[today] = [];
  }
  timestampsPerDay[today]!.insert(0, now);

  _saveData();
  _saveDataDay();  // Speichern Sie auch die timestampsPerDay Daten
  notifyListeners();
}


  deleteTimestamp(int index) {
    timestamps.removeAt(index);
    _saveData();
    notifyListeners(); // Informiere die Widgets über die Änderungen
  }

 void deleteTimestampDay(String day) {
    timestampsPerDay.remove(day);
    _saveDataDay();
    notifyListeners(); // Informiere die Widgets über die Änderungen
}

  int countTodayVisits() {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return timestamps
        .where((timestamp) =>
            timestamp!.isAfter(startOfDay) && timestamp.isBefore(endOfDay))
        .length;
  }
  Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 2, 28, 41),
              title: const Text('Bestätigen',style: TextStyle(color: Colors.grey),),
              content: const Text('Sicher, dass du es löschen möchtest?',style: TextStyle(color: Colors.grey),),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Abbrechen',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Löschen',
                    style: TextStyle(color: Colors.yellow),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false; 
   
  }
double averageMinutesBetweenTimestampsForDay(String day) {
  if (!timestampsPerDay.containsKey(day)) return 0;

  List<DateTime> timestampsForDay = timestampsPerDay[day]!;
  
  if (timestampsForDay.length <= 1) return 0; // Es gibt keinen Durchschnitt, wenn es nur einen Zeitstempel gibt.

  double totalDifference = 0;
  for (int i = 0; i < timestampsForDay.length - 1; i++) {
    totalDifference += timestampsForDay[i].difference(timestampsForDay[i + 1]).inMinutes;
  }
  notifyListeners();
  return totalDifference / (timestampsForDay.length - 1);
    
}

  
}
