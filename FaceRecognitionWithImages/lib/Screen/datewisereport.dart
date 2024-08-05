import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../API/datewiseApi.dart';
import '../API/datewiseApi.dart';
import '../API/teamreport.dart';
import '../themes/appcolor.dart';
import '../themes/fontsize.dart';

class Datewise extends StatefulWidget {
  const Datewise({Key? key}) : super(key: key);

  @override
  _DatewiseState createState() => _DatewiseState();
}

class _DatewiseState extends State<Datewise> {
  DateTime? fromDate;
  DateTime? toDate;
  List<Map<String, dynamic>> reportData = [];
  
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && mounted) {
      setState(() {
        // Set time to midnight (00:00:00) to show only the date
        selectedDate = DateTime(
            selectedDate!.year, selectedDate!.month, selectedDate!.day);
        if (isFromDate) {
          fromDate = selectedDate;
        } else {
          toDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FontSizeManager fontSizeManager = FontSizeManager(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Date Wise Attendance',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'From Date: ${fromDate?.toLocal() ?? "Not selected"}',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text('Select'),
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  'To Date: ${toDate?.toLocal() ?? "Not selected"}',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text('Select'),
                ),
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Datereport datereport = Datereport();
               

                  int employeeId = 0; // replace with your employee id
                
                  reportData = await datereport.myreport(
                      employeeId, toDate!, fromDate!, context);
                  setState(() {
                    reportData = reportData;
                  });
                  // Now you can handle or print the reportData as needed
                  print("Report Data:");
                  print(reportData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
                child: Container(
                    width: double.infinity,
                    height: 400, // Adjust the height as needed
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
                        int lenght = reportData.length;
                        return Card(
                          //elevation: length.toDouble(),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          '${employee['emp_id']}',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Latitude-Longitude: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontSizeManager
                                                  .calculateFontSize(0.04),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${employee['latitude']}-${employee['longitude']}',
                                            style: TextStyle(
                                              fontSize: fontSizeManager
                                                  .calculateFontSize(0.04),
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Image.asset(
                                  'assets/images/attendant-list.png',
                                  width: fontSizeManager.calculateFontSize(
                                      0.08), // 5% of screen width
                                  height: fontSizeManager.calculateFontSize(
                                      0.08), // 5% of screen height
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
