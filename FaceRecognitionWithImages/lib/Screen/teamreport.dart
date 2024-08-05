import 'package:flutter/material.dart';
import 'package:geofence/API/teamreport.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/appcolor.dart';
import '../themes/fontsize.dart';
import 'DetailsScreen.dart';

class Teamreport extends StatefulWidget {
  const Teamreport({Key? key}) : super(key: key);

  @override
  _Teamreport createState() => _Teamreport();
}

class _Teamreport extends State<Teamreport> {
  TeamreportAPI teamreport = TeamreportAPI();
  int? _expandedIndex;
  List<Map<String, dynamic>> reportData = [];
  @override
  initState() {
    super.initState();
    teamreportapi();
  }


  @override
  Widget build(BuildContext context) {
    FontSizeManager fontSizeManager = FontSizeManager(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Team Attendance',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.appbarcolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: fontSizeManager.calculateHeight(0.8), // Adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: reportData.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> employee = reportData[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(employee: employee),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Employee Id: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager.calculateFontSize(0.04),
                                    ),
                                  ),
                                  Text(
                                    '${employee['empid']}',
                                    style: TextStyle(
                                      fontSize: fontSizeManager.calculateFontSize(0.04),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(0.01), // 1% of screen height
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Employee Name: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager.calculateFontSize(0.04),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${employee['empname']}',
                                      style: TextStyle(
                                        fontSize: fontSizeManager.calculateFontSize(0.04),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(0.01), // 1% of screen height
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile Number: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager.calculateFontSize(0.04),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${employee['mobile_no']}',
                                      style: TextStyle(
                                        fontSize: fontSizeManager.calculateFontSize(0.04),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(0.01), // 1% of screen height
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'Designation: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontSizeManager.calculateFontSize(0.04),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${employee['designation']}',
                                      style: TextStyle(
                                        fontSize: fontSizeManager.calculateFontSize(0.04),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/attendant-list.png',
                              width: fontSizeManager.calculateFontSize(0.08), // 5% of screen width
                              height: fontSizeManager.calculateFontSize(0.08), // 5% of screen height
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void teamreportapi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String empid = prefs.getString('empid')!;
    reportData = await teamreport.teamreport('19050', context);
    setState(() {
      reportData = reportData;
    });
  }
}
