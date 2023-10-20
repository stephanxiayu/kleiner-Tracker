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

  bool _isDataLoaded = false;

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

    return ListView.builder(
      itemCount: provider.timestamps.length,
      itemBuilder: (context, index) {
        final timestamp = provider.timestamps[index];
        String difference = '';
        if (index + 1 < provider.timestamps.length) {
          difference =
              '${provider.timestamps[index]!.difference(provider.timestamps[index + 1]!).inMinutes} min';
        }
        return Card(elevation: 9,
          color: const Color.fromARGB(255, 2, 28, 41),
          child: ListTile(
            title: Text(
              DateFormat('dd.MM.yyyy - HH:mm').format(timestamp!),
              style: const TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              difference,
              style: const TextStyle(color: Colors.yellow),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red.shade900,
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
        );
      },
    );
  }
}
