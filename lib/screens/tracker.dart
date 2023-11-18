import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:kleiner_tracker/widget/globalvariables.dart';
import 'package:provider/provider.dart';



class Tracker extends StatefulWidget {
  const Tracker({super.key});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isDataLoaded) {
      final provider = Provider.of<TrackerProvider>(context, listen: false);
      provider.loadData();
      _isDataLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context, listen: true);

    return Scaffold(
    backgroundColor: GlobalVariables.backgroundColor,
      body: ListView.builder(
        itemCount: provider.timestamps.length,
        itemBuilder: (context, index) {
          final timestamp = provider.timestamps[index];
          String difference = '';
          if (index + 1 < provider.timestamps.length) {
            final timeDifference = provider.timestamps[index]!
                .difference(provider.timestamps[index + 1]!);
            final hours = timeDifference.inHours;
            final minutes = timeDifference.inMinutes.remainder(60);
            difference = '$hours Std $minutes min';
          }

          return Card(
            elevation: 9,
            shadowColor: (() {
              if (index + 1 < provider.timestamps.length) {
                final timeDifference = provider.timestamps[index]!.difference(provider.timestamps[index + 1]!);
                final hours = timeDifference.inHours;

                if (hours >= 3) {
                  return Colors.green; // Grüner Schatten
                }
              }
              return Colors.blueGrey.shade800; // Standard-Schattenfarbe
            })(),
            color: const Color.fromARGB(255, 2, 28, 41),
            child: Container(decoration: BoxDecoration(border: Border.all(width: 3,
              color:  index + 1 < provider.timestamps.length && provider.timestamps[index]!.difference(provider.timestamps[index + 1]!).inHours >= 3 ? Colors.green : Colors.transparent,)),
              child: ListTile(
                title: Text(
                  DateFormat('dd.MM.yyyy - HH:mm').format(timestamp!),
                  style: const TextStyle(color: Colors.grey),
                ),
                subtitle: Text(
                  difference,
                  style: TextStyle(
                    color: index + 1 < provider.timestamps.length && provider.timestamps[index]!.difference(provider.timestamps[index + 1]!).inHours >= 3 ? Colors.green : Colors.white,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    bool shouldDelete = await provider.confirmDelete(context);
                    if (shouldDelete) {
                      setState(() {
                        provider.deleteTimestamp(index);
                      });
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
