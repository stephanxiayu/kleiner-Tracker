import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kleiner_tracker/provider/tracker_provider.dart';
import 'package:provider/provider.dart';

class Tracker extends StatefulWidget {
  const Tracker({super.key});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {

 @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final provider = Provider.of<TrackerProvider>(context, listen: false);
    provider.loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
final provider = Provider.of<TrackerProvider>(context);
   
   
        return ListView.builder(
        itemCount: provider.timestamps.length,
        itemBuilder: (context, index) {
          final timestamp =provider. timestamps[index];
          String difference = '';
          if (index + 1 < provider.timestamps.length) {
            difference =
                '${provider.timestamps[index]!.difference(provider.timestamps[index + 1]!).inMinutes} min';
          }
          return Card(
            color: const Color.fromARGB(255, 2, 28, 41),
            child: ListTile(
              title: Text(
                DateFormat(' dd.MM.yyyy').format(timestamp!),
                style: const TextStyle(color: Colors.grey),
              ),
              subtitle: Text(
                difference,
                style: const TextStyle(color: Colors.yellow),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  bool shouldDelete = await provider. confirmDelete(context);
                  if (shouldDelete) {
                    provider.deleteTimestamp(index);
                  }
                },
              ),
            ),
          );
        },
      );
  }
}