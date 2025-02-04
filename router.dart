import 'package:medicare/model/doctor.dart';
import 'package:medicare/screens/doctor_detail.dart';
import 'package:medicare/screens/home.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/': (context) => Home(),
  '/detail': (context) => SliverDoctorDetail(
        doctor: Doctor(
          name: 'Dr. Gardner Pearson',
          specialty: 'Heart Specialist',
          image: 'assets/doctor02.png',
          patients: '100+',
          experience: '10 years',
          rating: 4.5,
        ),
        onScheduleBooked: (schedule) {
          // Handle schedule booking here
          print("Appointment booked: $schedule");
          // You can add this to a list or update the state as needed
        },
      ),
};
