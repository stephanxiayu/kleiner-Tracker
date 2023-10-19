
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/widget/globalvariables.dart';
import 'package:provider/provider.dart';

class TrackerList extends StatelessWidget {
  const TrackerList({super.key});

  @override
  Widget build(BuildContext context) {
    return   Card(color: GlobalVariables.backgroundColor,
      elevation: 9,
      child: ListView.builder(
      itemCount: 1,  // Wir zeigen nur einen Eintrag für jetzt
      itemBuilder: (context, index) {
      final provider = Provider.of<TrackerProvider>(context, listen: false);
    
      return ListTile(trailing: Text('${provider.timestamps.length} mal', style: const TextStyle(color: Colors.yellow, fontSize: 30),),
   title: Text(
  'Getrackte Zeiten am: ${DateFormat(' dd.MM.yyyy').format(provider.timestamps[index]!)}  --  ',
  style: const TextStyle(color: Colors.grey),
),

        subtitle: Text('Durchschnittliche Minuten: ${provider.averageMinutesBetweenTimestamps().toStringAsFixed(2)}, ',style: const TextStyle(color: Colors.yellow)),
      );
      },
    ),
    );

  }
}