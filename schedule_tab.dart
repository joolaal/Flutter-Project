import 'package:flutter/material.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

enum FilterStatus { upcoming, complete, cancel }

class _ScheduleTabState extends State<ScheduleTab> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;

  List<Map> schedules = [];

  void updateStatus(int index, FilterStatus newStatus) {
    setState(() {
      schedules[index]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> filteredSchedules = schedules.where((schedule) {
      return schedule['status'] == status;
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Schedule', textAlign: TextAlign.center, style: kTitleStyle),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: (context, index) {
                  var schedule = filteredSchedules[index];
                  return ScheduleCard(
                    schedule: schedule,
                    onCancel: () => updateStatus(
                        schedules.indexOf(schedule), FilterStatus.cancel),
                    onComplete: () => updateStatus(
                        schedules.indexOf(schedule), FilterStatus.complete),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final Map schedule;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  const ScheduleCard({
    Key? key,
    required this.schedule,
    required this.onComplete,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(schedule['img']),
                  radius: 30,
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['doctorName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(MyColors.header01),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      schedule['doctorTitle'],
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(schedule['reservedDate']),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (schedule['status'] == 'upcoming') ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        'Complete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
                if (schedule['status'] == 'complete') ...[
                  Text('Completed', style: TextStyle(color: Colors.green)),
                ],
                if (schedule['status'] == 'cancel') ...[
                  Text('Canceled', style: TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
