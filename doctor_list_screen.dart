import 'package:flutter/material.dart';
import 'package:medicare/model/doctor.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/screens/doctor_detail.dart'; // Make sure you import the correct file

class DoctorListScreen extends StatelessWidget {
  final List<Doctor> doctors;

  const DoctorListScreen({Key? key, required this.doctors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Doctors',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(MyColors.primary),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(doctor.image),
              ),
              title: Text(
                doctor.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(MyColors.header01),
                ),
              ),
              subtitle: Text(
                doctor.specialty,
                style: TextStyle(
                  color: Color(MyColors.grey02),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to doctor detail page and pass the onScheduleBooked function
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SliverDoctorDetail(
                      doctor: doctor, // Pass the doctor object
                      onScheduleBooked: (Map schedule) {
                        // Handle the schedule booking logic here
                        // For example, you could add the scheduled appointment to a list
                        print("Appointment booked: $schedule");
                        // You could also update the state to display the scheduled appointment in the parent widget
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
