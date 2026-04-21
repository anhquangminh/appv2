import 'package:ducanherp/data/models/notification_model.dart';

abstract class NotificationEvent {}

class SendNotificationEvent extends NotificationEvent {
  final List<String> userIds;
  final String title;
  final String body;

  SendNotificationEvent({
    required this.userIds,
    required this.title,
    required this.body,
  });
}

class RegisterTokenEvent extends NotificationEvent {
  final String token;
  final String groupId;
  final String userId;

  RegisterTokenEvent({
    required this.token,
    required this.groupId,
    required this.userId,
  });
}

class UnregisterTokenEvent extends NotificationEvent {
  final String token;
  final String groupId;
  final String userId;

  UnregisterTokenEvent({
    required this.token,
    required this.groupId,
    required this.userId,
  });
}

class UpdateNotificationEvent extends NotificationEvent {
  final NotificationModel notifi;
  UpdateNotificationEvent({required this.notifi});
}

class GetAllNotiByUserEvent extends NotificationEvent {
  final int currentPage;
  final int pageSize;
  GetAllNotiByUserEvent({required this.currentPage, required this.pageSize});
}

class GetUnreadNotiByUserIdEvent extends NotificationEvent {
  GetUnreadNotiByUserIdEvent();
}

class GetAllNotiFireBaseByUserIdEvent extends NotificationEvent {
  final int currentPage;
  final int pageSize;
  GetAllNotiFireBaseByUserIdEvent({required this.currentPage, required this.pageSize});
}

class GetReadFireBaseIdEvent extends NotificationEvent {
  GetReadFireBaseIdEvent();
}

class IsReadFireBaseIdEvent extends NotificationEvent {
  final String id;
  IsReadFireBaseIdEvent({required this.id});
}
