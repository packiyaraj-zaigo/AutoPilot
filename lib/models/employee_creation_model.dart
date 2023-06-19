class EmployeeCreationModel {
  int clientId;
  String email;
  String firstName;
  String lastName;
  String phone;
  int active = 0;
  String role;

  EmployeeCreationModel(
      {required this.clientId,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.role});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['client_id'] = clientId;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['active'] = active;
    data['role'] = role;
    return data;
  }
}
