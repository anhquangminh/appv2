class NotificationFireBaseModel {
   String id;
   String reciverId;
   String title;
   String body;
   int isRead;
   String creatby;
   int isActive;
   DateTime createdAt;
   String targetPage = "";
   String targetId = "";

  NotificationFireBaseModel({
    required this.id,
    required this.reciverId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.creatby,
    required this.isActive,
    required this.createdAt,
    this.targetPage = "",
    this.targetId = "",
  });

  factory NotificationFireBaseModel.fromJson(Map<String, dynamic> json) {
    return NotificationFireBaseModel(
      id: json['id'],
      reciverId: json['reciverId'],
      title: json['title'],
      body: json['body'],
      isRead: json['isRead'],
      creatby: json['creatby'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      targetPage: json['targetPage'] ?? "",
      targetId: json['targetId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reciverId': reciverId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'creatby': creatby,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'targetPage': targetPage,
      'targetId': targetId,
    };
  }
}
