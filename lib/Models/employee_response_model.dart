class AllEmployeeResponse {
  int? currentPage;
  List<Employee>? employeeList;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  String? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AllEmployeeResponse(
      {this.currentPage,
      this.employeeList,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  AllEmployeeResponse.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      employeeList = <Employee>[];
      json['data'].forEach((v) {
        employeeList!.add(Employee.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }
}

class Employee {
  int? id;
  int? clientId;
  String? email;
  String? emailVerifiedAt;
  String? firstName;
  String? lastName;
  String? phone;
  String? profileImage;
  int? active;
  int? taskId;
  String? laborCost;
  int? commissionStructureId;
  int? salesTargetId;
  String? activationToken;
  String? createdAt;
  String? updatedAt;
  List<Roles>? roles;

  Employee(
      {this.id,
      this.clientId,
      this.email,
      this.emailVerifiedAt,
      this.firstName,
      this.lastName,
      this.phone,
      this.profileImage,
      this.active,
      this.taskId,
      this.laborCost,
      this.commissionStructureId,
      this.salesTargetId,
      this.activationToken,
      this.createdAt,
      this.updatedAt,
      this.roles});

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clientId = json['client_id'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    active = json['active'];
    taskId = json['task_id'];
    laborCost = json['labor_cost'];
    commissionStructureId = json['commission_structure_id'];
    salesTargetId = json['sales_target_id'];
    activationToken = json['activation_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }
}

class Roles {
  int? id;
  String? name;
  int? clientId;
  String? guardName;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
      this.name,
      this.clientId,
      this.guardName,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    clientId = json['client_id'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
}

class Pivot {
  int? modelId;
  int? roleId;
  String? modelType;

  Pivot({this.modelId, this.roleId, this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }
}
