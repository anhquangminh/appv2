import 'package:ducanherp/data/models/notification_model.dart';
import 'package:ducanherp/data/models/notificationfirebase_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final String message;

  NotificationSuccess(this.message);
}

class GetAllNotiByUserSuccessSate extends NotificationState {
  final List<NotificationModel> notifi;
  GetAllNotiByUserSuccessSate(this.notifi);
}
class GetUnreadNotiByUserIdSuccessSate extends NotificationState {
  final int countNotifi;
  GetUnreadNotiByUserIdSuccessSate(this.countNotifi);
}

class GetAllNotiFireBaseByUserIdSuccessSate extends NotificationState {
  final List<NotificationFireBaseModel> notifi;
  GetAllNotiFireBaseByUserIdSuccessSate(this.notifi);
}

class GetReadFireBaseIdSuccessSate extends NotificationState {
  final int countNotifi;
  GetReadFireBaseIdSuccessSate(this.countNotifi);
}

class UpdateFireBaseSuccesState extends NotificationState {}


class NotificationError extends NotificationState {
  final String error;
  NotificationError(this.error);
}