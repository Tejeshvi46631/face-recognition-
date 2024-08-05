import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:geofence/Constant/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> employee;

  DetailsScreen({required this.employee});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Map<String, dynamic>> _reportData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReportData();
  }

  Future<void> _fetchReportData() async {
    String employeeId = widget.employee['empid'];
    List<Map<String, dynamic>> reportData = await myreport(employeeId);
    setState(() {
      _reportData = reportData;
      _isLoading = false;
    });
  }

  Future<void> _exportToExcel() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (true) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Attendance Report'];
      sheetObject.cell(CellIndex.indexByString("A1")).value = "Date";
      sheetObject.cell(CellIndex.indexByString("B1")).value = "Attendance Type";
      sheetObject.cell(CellIndex.indexByString("C1")).value = "Work Location";

      for (int i = 0; i < _reportData.length; i++) {
        Map<String, dynamic> data = _reportData[i];
        sheetObject.cell(CellIndex.indexByString("A${i + 2}")).value = data['date'];
        sheetObject.cell(CellIndex.indexByString("B${i + 2}")).value = data['attendancetype'];
        sheetObject.cell(CellIndex.indexByString("C${i + 2}")).value = data['worklocation'];
      }

      var fileBytes = excel.save();
      var directory = await getExternalStorageDirectory();

      String path = "${directory!.path}/attendance_report.xlsx";
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Excel file saved at $path'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportToExcel,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEmployeeDetail('Employee Id', widget.employee['empid'].toString()),
              SizedBox(height: 10),
              _buildEmployeeDetail('Employee Name', widget.employee['empname']),
              SizedBox(height: 10),
              _buildEmployeeDetail('Mobile Number', widget.employee['mobile_no']),
              SizedBox(height: 10),
              _buildEmployeeDetail('Designation', widget.employee['designation']),
              SizedBox(height: 20),
              Text(
                'Attendance Report',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildReportList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildReportList() {
    return _reportData.isEmpty
        ? Center(child: Text('No report data available'))
        : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _reportData.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = _reportData[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReportDetail('Date', data['date']),
                SizedBox(height: 5),
                _buildReportDetail('Attendance Type', data['attendancetype']),
                SizedBox(height: 5),
                _buildReportDetail('Work Location', data['worklocation']),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportDetail(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> myreport(String employeeId) async {
  try {
    var myReportApi = "${Constants.IP_HEADER}/FetchDataOnEmpId";
    var requestUrl = Uri.parse(myReportApi);

    // Make the API call
    var response = await http.post(
      requestUrl,
      body: {
        'emp_id': employeeId.toString(),
      },
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<Map<String, dynamic>> responseData =
      List<Map<String, dynamic>>.from(json.decode(response.body));
      print("DATA");
      print(responseData);
      // Handle the data
      for (var data in responseData) {
        print(
            'Date: ${data['date']}, Attendance Type: ${data['attendancetype']}, Work Location: ${data['worklocation']}');
        // Add your logic to handle each data entry
      }

      return responseData; // Return the list of maps
    } else {
      // API call failed, handle the error
      print('API Call Failed: ${response.statusCode}');
      return []; // Return an empty list or handle the error case
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during API call: $e');
    return []; // Return an empty list or handle the error case
  }
}
