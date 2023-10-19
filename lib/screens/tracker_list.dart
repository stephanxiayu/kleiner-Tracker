import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/widget/globalvariables.dart';
import 'package:provider/provider.dart';

class TrackerList extends StatefulWidget {
  const TrackerList({super.key});

  @override
  State<TrackerList> createState() => _TrackerListState();
}

class _TrackerListState extends State<TrackerList> {

   @override
  void initState() {
    super.initState();
  }

  bool _isDataLoaded = false;

  @override
  void didChangeDependencies() {
    if (!_isDataLoaded) {
      final provider = Provider.of<TrackerProvider>(context, listen: false);
      provider.loadDataDay();
      _isDataLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context, listen: true);
    List<String> days = provider.timestampsPerDay.keys.toList();

    return Card(
      color: GlobalVariables.backgroundColor,
      elevation: 9,
      child: ListView.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {

       
          String day = days[index];
          List<DateTime> timestampsForDay = provider.timestampsPerDay[day]!;
          DateTime date = DateFormat('yyyy-MM-dd').parse(day);

          return GestureDetector(onLongPress:() async {
                  bool shouldDelete = await provider. confirmDelete(context);
                  if (shouldDelete) {
                    provider.deleteTimestampDay(day);
                  }
                },
            child: ListTile(
              trailing: Text(
                '${timestampsForDay.length} mal',
                style: const TextStyle(color: Colors.yellow, fontSize: 30),
              ),
              title: Text(
                'Getrackte Zeiten am: ${DateFormat(' dd.MM.yyyy').format(date)}  --  ',
                style: const TextStyle(color: Colors.grey),
              ),
              subtitle: Text(
                  'Durchschnittliche Minuten: ${provider.averageMinutesBetweenTimestampsForDay(day).toStringAsFixed(2)}, ',
                  style: const TextStyle(color: Colors.yellow)),
            ),
          );
        },
      ),
    );
  }
}
