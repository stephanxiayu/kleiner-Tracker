import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TrackerProvider with ChangeNotifier {

  List<DateTime?> timestamps = [];

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
  }

  addTimestamp() {
    timestamps.insert(0, DateTime.now());
    _saveData();
    notifyListeners(); // Informiere die Widgets über die Änderungen
  }

  deleteTimestamp(int index) {
    timestamps.removeAt(index);
    _saveData();
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


  double averageMinutesBetweenTimestamps() {
  if (timestamps.length <= 1) return 0.0;

  List<double> differences = [];

  for (int i = 0; i < timestamps.length - 1; i++) {
    differences.add(timestamps[i]!.difference(timestamps[i + 1]!).inMinutes.toDouble());
  }

  double total = differences.reduce((a, b) => a + b);
  return total / differences.length;
}
}
