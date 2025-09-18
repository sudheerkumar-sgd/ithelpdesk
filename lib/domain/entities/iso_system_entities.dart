class RequestDetail {
  int? detailId;
  int? requestId;
  String? firstName;
  String? lastName;
  String? fullName;
  String? designation;
  int? departmentID;
  String? existingDepartmentID;
  String? employeeID;
  String? loginID;
  String? accessTypeID;
  int? reportingManagerID; // long in C# -> int in Dart
  String? emailID;
  DateTime? dateOfJoining;
  int? requestPriority;
  String? reasonOfAccess;
  String? comments;
  String? attachments;

  RequestDetail({
    this.detailId,
    this.requestId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.designation,
    this.departmentID,
    this.existingDepartmentID,
    this.employeeID,
    this.loginID,
    this.accessTypeID,
    this.reportingManagerID,
    this.emailID,
    this.dateOfJoining,
    this.requestPriority,
    this.reasonOfAccess,
    this.comments,
    this.attachments,
  });

  // Convert from JSON (from API)
  factory RequestDetail.fromJson(Map<String, dynamic> json) {
    return RequestDetail(
      detailId: json['detailId'],
      requestId: json['requestId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      designation: json['designation'],
      departmentID: json['departmentID'],
      existingDepartmentID: json['existingDepartmentID'],
      employeeID: json['employeeID'],
      loginID: json['loginID'],
      accessTypeID: json['accessTypeID'],
      reportingManagerID: json['reportingManagerID'] != null
          ? int.tryParse(json['reportingManagerID'].toString())
          : null,
      emailID: json['emailID'],
      dateOfJoining: json['dateOfJoining'] != null
          ? DateTime.tryParse(json['dateOfJoining'])
          : null,
      requestPriority: json['requestPriority'],
      reasonOfAccess: json['reasonOfAccess'],
      comments: json['comments'],
      attachments: json['attachments'],
    );
  }

  // Convert to JSON (for sending data)
  Map<String, dynamic> toJson() {
    return {
      'detailId': detailId,
      'requestId': requestId,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'designation': designation,
      'departmentID': departmentID,
      'existingDepartmentID': existingDepartmentID,
      'employeeID': employeeID,
      'loginID': loginID,
      'accessTypeID': accessTypeID,
      'reportingManagerID': reportingManagerID,
      'emailID': emailID,
      'dateOfJoining': dateOfJoining?.toIso8601String(),
      'requestPriority': requestPriority,
      'reasonOfAccess': reasonOfAccess,
      'comments': comments,
      'attachments': attachments,
    };
  }
}
