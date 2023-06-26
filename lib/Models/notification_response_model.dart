class NotificationResponseModel {
  int? currentPage;
  List<Notifications>? notification;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  String? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  NotificationResponseModel({
    this.currentPage,
    this.notification,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        currentPage: json["current_page"],
        notification: json['data'] != null && json['data'].isNotEmpty
            ? List<Notifications>.from(
                json["data"].map((x) => Notifications.fromJson(x)))
            : [],
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class Notifications {
  int? id;
  int? clientId;
  String? title;
  String? message;
  int? isRead;
  int? senderUserId;
  int? receivedUserId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? senderUser;
  User? receiverUser;

  Notifications({
    this.id,
    this.clientId,
    this.title,
    this.message,
    this.isRead,
    this.senderUserId,
    this.receivedUserId,
    this.createdAt,
    this.updatedAt,
    this.senderUser,
    this.receiverUser,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        id: json["id"],
        clientId: json["client_id"],
        title: json["title"],
        message: json["message"],
        isRead: json["is_read"],
        senderUserId: json["sender_user_id"],
        receivedUserId: json["received_user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        senderUser: User.fromJson(json["sender_user"]),
        receiverUser: User.fromJson(json["receiver_user"]),
      );
}

class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );
}
