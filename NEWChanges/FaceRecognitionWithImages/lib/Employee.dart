class Employee {
  String employeeName;
  String mobileNumber;
  String emailId;
  String isFlaSla;
  String workingLocation;
  String empId;
  String designation;
  String reportingOfficer;
  int isVerify;
  int isGuidelinesAccepted;

  Employee({
    required this.employeeName,
    required this.mobileNumber,
    required this.emailId,
    required this.isFlaSla,
    required this.workingLocation,
    required this.empId,
    required this.designation,
    required this.reportingOfficer,
    required this.isVerify,
    required this.isGuidelinesAccepted,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeName: json['employeeName'],
      mobileNumber: json['mobileNumber'],
      emailId: json['emailId'],
      isFlaSla: json['isFlaSla'],
      workingLocation: json['workingLocation'],
      empId: json['empId'],
      designation: json['designation'],
      reportingOfficer: json['reportingOfficer'],
      isVerify: json['isVerify'],
      isGuidelinesAccepted: json['isGuidelinesAccepted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeName': employeeName,
      'mobileNumber': mobileNumber,
      'emailId': emailId,
      'isFlaSla': isFlaSla,
      'workingLocation': workingLocation,
      'empId': empId,
      'designation': designation,
      'reportingOfficer': reportingOfficer,
      'isVerify': isVerify,
      'isGuidelinesAccepted': isGuidelinesAccepted,
    };
  }
}
