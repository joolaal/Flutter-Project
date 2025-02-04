import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:medicare/model/doctor.dart'; // Import the Doctor model
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';
import "package:latlong2/latlong.dart" as lat_lng;

class SliverDoctorDetail extends StatelessWidget {
  final Doctor doctor; // Receive the Doctor object
  final Function(Map)
      onScheduleBooked; // Callback to handle booking an appointment

  const SliverDoctorDetail(
      {Key? key, required this.doctor, required this.onScheduleBooked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(doctor.name), // Use dynamic name
            backgroundColor: Color(MyColors.primary),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                doctor.image, // Use dynamic image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(
                doctor: doctor,
                onScheduleBooked:
                    onScheduleBooked), // Pass doctor data to DetailBody
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final Doctor doctor; // Receive the Doctor object
  final Function(Map)
      onScheduleBooked; // Callback to handle booking an appointment

  const DetailBody(
      {Key? key, required this.doctor, required this.onScheduleBooked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailDoctorCard(doctor: doctor), // Pass doctor data
          const SizedBox(height: 15),
          DoctorInfo(doctor: doctor), // Pass doctor data
          const SizedBox(height: 30),
          Text(
            'About Doctor',
            style: kTitleStyle,
          ),
          const SizedBox(height: 15),
          Text(
            'Dr. ${doctor.name} is a specialist in ${doctor.specialty} with ${doctor.experience} of experience. ${doctor.patients} patients have been treated successfully.',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'Location',
            style: kTitleStyle,
          ),
          const SizedBox(height: 25),
          const DoctorLocation(),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(MyColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Book Appointment'),
            onPressed: () {
              // Add the new appointment schedule to the list
              onScheduleBooked({
                'img': doctor.image,
                'doctorName': doctor.name,
                'doctorTitle': doctor.specialty,
                'reservedDate': 'Monday, Dec 18', // Adjust the date accordingly
                'reservedTime': '10:00 - 11:00', // Adjust the time as needed
                'status': 'upcoming',
              });

              // Optionally, pop back to the previous screen after booking
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  final Doctor doctor; // Receive the Doctor object

  const DoctorInfo({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NumberCard(label: 'Patients', value: doctor.patients),
        const SizedBox(width: 15),
        NumberCard(label: 'Experience', value: doctor.experience),
        const SizedBox(width: 15),
        NumberCard(label: 'Rating', value: doctor.rating.toString()),
      ],
    );
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailDoctorCard extends StatelessWidget {
  final Doctor doctor; // Receive the Doctor object

  const DetailDoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                        color: Color(MyColors.header01),
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      color: Color(MyColors.grey02),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              doctor.image,
              width: 100,
            )
          ],
        ),
      ),
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: lat_lng.LatLng(51.5, -0.09),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}
