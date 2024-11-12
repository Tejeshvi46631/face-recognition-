import 'dart:convert';
import 'package:http/http.dart' as http;

class ShiftSchedule {
  static Future<List<Map<String, dynamic>>> shiftByEmpId(int empId) async {
    // Define the API URL
    final apiUrl =
        Uri.parse("http://10.210.5.39:8080/api/shiftschedule/$empId");
    print(apiUrl);
    try {
      final response = await http.get(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> responseData = jsonDecode(response.body);

        // Extract shift data as a list of maps
        List<Map<String, dynamic>> shifts = responseData.map((shift) {
          return {
            "empId": int.parse(shift['empId']), // Convert empId to int
            "location": shift['location'],
            "startDate": shift['startDate'],
            "endDate": shift['endDate'],
            "startTime": shift['startTime'],
            "endTime": shift['endTime'],
            "day": shift['day'],
          };
        }).toList();

        return shifts;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }
}
