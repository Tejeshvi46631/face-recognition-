import 'dart:convert';
import 'package:geofence/Screen/myreport.dart';
import 'package:http/http.dart' as http;

import '../Constant/api.dart';

class MyReportAPI {
  Constants constantsInstance = Constants();

  Future<List<Map<String, dynamic>>> myreport(int employeeId) async {
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
}
