import 'package:flutter/material.dart';
import 'package:medicare/model/doctor.dart';
import 'package:medicare/screens/doctor_detail.dart';
import 'package:medicare/styles/colors.dart';
import 'package:medicare/styles/styles.dart';
import 'package:medicare/screens/doctor_list_screen.dart';
// import 'package:medicare/screens/doctor_detail.dart'; // Import the detail screen

class HomeTab extends StatefulWidget {
  final void Function() onPressedScheduleCard;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
  }) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Gardner Pearson',
      specialty: 'Heart Specialist',
      image: 'assets/doctor02.png',
      patients: '100+',
      experience: '10 years',
      rating: 4.5,
    ),
    Doctor(
      name: 'Dr. Rosa Williamson',
      specialty: 'Skin Specialist',
      image: 'assets/doctor03.jpeg',
      patients: '80+',
      experience: '8 years',
      rating: 4.3,
    ),
    Doctor(
      name: 'Dr. Muhammed Syahid',
      specialty: 'Dentist',
      image: 'assets/doctor01.jpeg',
      patients: '150+',
      experience: '12 years',
      rating: 4.7,
    ),
    Doctor(
      name: 'Dr. Zahra Ali',
      specialty: 'Cardiology Specialist',
      image: 'assets/doctor04.jpeg',
      patients: '45+',
      experience: '13 years',
      rating: 4.1,
    ),
  ];

  List<Doctor> filteredDoctors = [];
  List<Map> schedules = []; // Store the scheduled appointments

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors; // Initially show all doctors
  }

  void filterDoctors(String query) {
    setState(() {
      searchQuery = query;
      filteredDoctors = doctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(query.toLowerCase()) ||
              doctor.specialty.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Function to handle scheduling an appointment
  void addSchedule(Map newSchedule) {
    setState(() {
      schedules.add(newSchedule);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            SizedBox(height: 20),
            UserIntro(),
            SizedBox(height: 10),
            SearchInput(onSearch: filterDoctors), // Search Bar
            SizedBox(height: 20),
            CategoryIcons(), // Displays category icons
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Appointment Today', style: kTitleStyle),
                TextButton(
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Color(MyColors.yellow01),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorListScreen(doctors: doctors),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(height: 20),
            AppointmentCard(onTap: () {
              // On tapping appointment card, navigate to doctor details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SliverDoctorDetail(
                    doctor: doctors[0], // Pass the first doctor as an example
                    onScheduleBooked:
                        addSchedule, // Pass the function to add to schedule
                  ),
                ),
              );
            }), // Appointment card
            SizedBox(height: 20),
            Text(
              'Top Doctor',
              style: TextStyle(
                color: Color(MyColors.header01),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: filteredDoctors.map((doctor) {
                return TopDoctorCard(doctor: doctor); // Doctor Card
              }).toList(),
            ),
            // Display the scheduled appointments below
            SizedBox(height: 20),
            Text('Scheduled Appointments',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...schedules.map((schedule) {
              return ScheduleCard(
                  schedule: schedule); // Appointment in the schedule
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// User Intro Widget
class UserIntro extends StatelessWidget {
  const UserIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello', style: TextStyle(fontWeight: FontWeight.w500)),
            Text(
              'Brad King 👋',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        CircleAvatar(
          backgroundImage: AssetImage('assets/person.jpeg'),
        ),
      ],
    );
  }
}

// Search Input Widget
class SearchInput extends StatelessWidget {
  final Function(String) onSearch;

  const SearchInput({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(MyColors.bg),
        prefixIcon: Icon(Icons.search, color: Color(MyColors.purple02)),
        hintText: 'Search a doctor or health issue',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Category Icons Widget
class CategoryIcons extends StatelessWidget {
  const CategoryIcons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> categories = [
      {'icon': Icons.coronavirus, 'text': 'Covid 19'},
      {'icon': Icons.local_hospital, 'text': 'Hospital'},
      {'icon': Icons.car_rental, 'text': 'Ambulance'},
      {'icon': Icons.local_pharmacy, 'text': 'Pill'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((category) {
        return Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                category['icon'],
                color: Color(MyColors.primary),
              ),
            ),
            SizedBox(height: 10),
            Text(
              category['text'],
              style: TextStyle(
                color: Color(MyColors.primary),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// Appointment Card Widget
class AppointmentCard extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/doctor01.jpeg'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. Muhammed Syahid',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Dental Specialist',
                      style: TextStyle(color: Color(MyColors.text01)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Top Doctor Card Widget
class TopDoctorCard extends StatelessWidget {
  final Doctor doctor;

  const TopDoctorCard({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SliverDoctorDetail(
                doctor: doctor, // Pass the doctor object
                onScheduleBooked: (Map schedule) {
                  // Handle the scheduling logic here
                  print("Appointment booked: $schedule");
                  // You can add this appointment to a list or update state
                },
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              color: Color(MyColors.grey01),
              child: Image.asset(
                doctor.image,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: TextStyle(
                    color: Color(MyColors.header01),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    color: Color(MyColors.grey02),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(MyColors.yellow02),
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '${doctor.rating} - ${doctor.patients} Patients',
                      style: TextStyle(color: Color(MyColors.grey02)),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Schedule Card Widget
class ScheduleCard extends StatelessWidget {
  final Map schedule;

  const ScheduleCard({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
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
      ),
    );
  }
}
