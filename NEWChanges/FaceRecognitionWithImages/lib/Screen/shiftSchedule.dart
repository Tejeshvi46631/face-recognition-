import 'package:flutter/material.dart';
import 'package:geofence/API/loginapi.dart';
import 'package:geofence/API/shiftscheduleapi.dart';
import 'package:geofence/themes/appcolor.dart';
import 'package:provider/provider.dart';

class shiftSchedule extends StatefulWidget {
  const shiftSchedule({super.key});

  @override
  State<shiftSchedule> createState() => _shiftScheduleState();
}

class _shiftScheduleState extends State<shiftSchedule> {
  List<Map<String, dynamic>> shiftData = [];

  @override
  void initState() {
    super.initState();
    shiftScheduleData(); // Fetch shift data when the widget is initialized
  }

  // Function to fetch the shift data
  shiftScheduleData() async {
    String? userIdString = Provider.of<LoginAPI>(context, listen: false).userid;

    if (userIdString != null) {
      try {
        // Fetch shift data by calling the API
        List<Map<String, dynamic>> shifts =
            await ShiftSchedule.shiftByEmpId(int.parse(userIdString));

        // Update the state with the fetched data
        setState(() {
          shiftData = shifts;
        });
      } catch (e) {
        // Handle any errors that occur during the API call
        print('Error fetching shift data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Shift Schedule',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.appbarcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined,
              color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: ListView.builder(
        itemCount: shiftData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shiftData[index]['day']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          shiftData[index]['date']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Time: 9 AM - 6 PM',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Location: Juhu',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Action for leave application
                      },
                      child: Text('Apply for Leave'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
