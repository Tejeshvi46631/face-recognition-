import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/loginapi.dart';
import '../Screen/welcome.dart';
import '../API/myreportapi.dart';
import '../themes/appcolor.dart';
import '../themes/fontsize.dart';

class MyReportScreen extends StatefulWidget {
  const MyReportScreen({Key? key}) : super(key: key);

  @override
  _MyReportScreenState createState() => _MyReportScreenState();
}

class _MyReportScreenState extends State<MyReportScreen> {
  MyReportAPI myReportAPI = MyReportAPI();
  List<String> employeeData = [];
  int? userId;

  @override
  void initState() {
    super.initState();
    initializeUserId();
  }

  void initializeUserId() {
    String? userIdString = Provider.of<LoginAPI>(context, listen: false).userid;

    // Attempt to parse the userIdString as an integer
    userId = int.tryParse(userIdString ?? '');

    // Check if parsing was successful
    if (userId == null) {
      // Provide a default value or handle the situation where userId is not a valid integer
      print('Invalid userId: $userIdString');
      // You might want to throw an exception, set a default value, or handle it in some way
    }

    print("USER ID");
    print(userId);
  }

  @override
  Widget build(BuildContext context) {
    FontSizeManager fontSizeManager = FontSizeManager(context);

    return WillPopScope(
      onWillPop: () async {
        // Reload the current activity
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => welcomescreen()),
        );
        // Return false to prevent default back navigation
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'My Report',
              style: TextStyle(color: AppColors.white),
            ),
          ),
          backgroundColor:
              Colors.lightBlueAccent, // Replace with your appbarcolor
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: AppColors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => welcomescreen()),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Image.asset(
                  'assets/images/calendar.png',
                  width: fontSizeManager
                      .calculateFontSize(0.07), // 5% of screen width
                  height: fontSizeManager
                      .calculateFontSize(0.07), // 5% of screen height
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/datewise');
                },
              ),
            ),
          ],
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: myReportAPI.myreport(userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is still loading, show a loading indicator
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there's an error, display an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If the future is complete and successful, display the data in cards
              List<Map<String, dynamic>> employeeData = snapshot.data ?? [];
              return ListView.builder(
                itemCount: employeeData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> employee = employeeData[index];
                  int lenght = employeeData.length;
                  return Card(
                    //elevation: length.toDouble(),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
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
                                    'Employee Id : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager
                                          .calculateFontSize(0.04),
                                    ),
                                  ),
                                  Text(
                                    '$userId',
                                    style: TextStyle(
                                      fontSize: fontSizeManager
                                          .calculateFontSize(0.04),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(
                                    0.01), // 1% of screen height
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date & Time : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager
                                          .calculateFontSize(0.04),
                                    ),
                                  ),
                                  Text(
                                    '${employee['date']}',
                                    style: TextStyle(
                                      fontSize: fontSizeManager
                                          .calculateFontSize(0.04),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(
                                    0.01), // 1% of screen height
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Work Location: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSizeManager
                                          .calculateFontSize(0.04),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${employee['worklocation']}',
                                      style: TextStyle(
                                        fontSize: fontSizeManager
                                            .calculateFontSize(0.04),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: fontSizeManager.calculateFontSize(
                                    0.01), // 1% of screen height
                              ),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Flexible(
                              //       child: Text(
                              //         'Latitude-Longitude: ',
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: fontSizeManager
                              //               .calculateFontSize(0.04),
                              //         ),
                              //       ),
                              //     ),
                              //     Flexible(
                              //       child: Text(
                              //         '${employee['latitude']}-${employee['longitude']}',
                              //         style: TextStyle(
                              //           fontSize: fontSizeManager
                              //               .calculateFontSize(0.04),
                              //         ),
                              //         softWrap: true,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Image.asset(
                            'assets/images/attendant-list.png',
                            width: fontSizeManager
                                .calculateFontSize(0.08), // 5% of screen width
                            height: fontSizeManager
                                .calculateFontSize(0.08), // 5% of screen height
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
