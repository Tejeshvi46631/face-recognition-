import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geofence/API/loginapi.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Constant/api.dart';

class Datereport {
  Constants constantsInstance = Constants();

  Future<List<Map<String, dynamic>>> myreport(int employeeId, DateTime toDate,
      DateTime fromDate, BuildContext context) async {
    try {
      final dateFormatter = DateFormat('dd-MM-yyyy');
      String? userIdString =
          Provider.of<LoginAPI>(context, listen: false).userid;
      //int? userId = int.tryParse(userIdString ?? '');
      print("Date: ");
      String fromdate = dateFormatter.format(fromDate);
      String todate = dateFormatter.format(toDate);
      print(dateFormatter.format(fromDate));
      print(dateFormatter.format(toDate));
      var myReportApi = "${Constants.IP_HEADER}/fetchDetailsByDates";
      var requestUrl = Uri.parse(myReportApi);
      print("Datess");
      print(toDate);
      print(fromDate);
      // Make the API call
      var response = await http.post(
        requestUrl,
        body: {
          'emp_id': userIdString,
          'from_date': fromdate,
          'to_date': todate,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        // Parse the JSON response
        List<Map<String, dynamic>> responseData =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("DateWiseData");
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

  
}
