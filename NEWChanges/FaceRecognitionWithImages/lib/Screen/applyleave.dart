import 'package:flutter/material.dart';





class ApplyLeaveScreen extends StatefulWidget {
  @override
  _ApplyLeaveScreenState createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedLeaveType;
  final List<String> leaveTypes = [
    'Casual Leave',
    'Maternity Leave',
    'Privilege Leave',
    'Restricted Holiday',
    'Special Casual Leave',
    'Special Covid Leave',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Leave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date Picker
            Text('Start Date'),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, true),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  startDate != null
                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                      : 'Select Start Date',
                ),
              ),
            ),
            SizedBox(height: 16),

            // End Date Picker
            Text('End Date'),
            SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context, false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  endDate != null
                      ? '${endDate!.day}/${endDate!.month}/${endDate!.year}'
                      : 'Select End Date',
                ),
              ),
            ),
            SizedBox(height: 16),

            // Leave Type Dropdown
            Text('Leave Type'),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLeaveType,
              onChanged: (value) {
                setState(() {
                  selectedLeaveType = value;
                });
              },
              items: leaveTypes.map((leaveType) {
                return DropdownMenuItem<String>(
                  value: leaveType,
                  child: Text(leaveType),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              hint: Text('Select Leave Type'),
            ),
            SizedBox(height: 32),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (startDate != null && endDate != null && selectedLeaveType != null) {
      // Handle the form submission logic here
      print('Leave Applied: $selectedLeaveType from $startDate to $endDate');
    } else {
      // Show a message if form is incomplete
      print('Please complete all fields');
    }
  }
}
