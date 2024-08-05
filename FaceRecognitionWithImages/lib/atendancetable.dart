class AttendanceTable {
  String columnName;
  String columnEmbedding;
  String columnEmpid;

  AttendanceTable({required this.columnName, required this.columnEmbedding, required this.columnEmpid});


  // Convert the object to a JSON format
  Map<String, dynamic> toJson() {
    return {
      'columnName': columnName,
      'columnEmbedding': columnEmbedding,
      'columnEmpid': columnEmpid
    };
  }
}
