class MessageModel {
  int? id;
  int? clientId;
  String title;
  String message;
  int? isRead;
  int? senderUserId;
  int? receivedUserId;
  DateTime createdAt;
  DateTime updatedAt;
  User senderUser;
  User receiverUser;

  MessageModel({
    this.id,
    this.clientId,
    required this.title,
    required this.message,
    this.isRead,
    this.senderUserId,
    this.receivedUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.senderUser,
    required this.receiverUser,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "title": title,
        "message": message,
        "is_read": isRead,
        "sender_user_id": senderUserId,
        "received_user_id": receivedUserId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sender_user": senderUser.toJson(),
        "receiver_user": receiverUser.toJson(),
      };
}

class User {
  int? id;
  String email;
  String firstName;
  String lastName;

  User({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
      };
}
