import 'package:ducanherp/data/models/changepassword_mode.dart';
import 'package:ducanherp/data/models/register_model.dart';

abstract class AppUserEvent {}

class AppUserLoginEvent extends AppUserEvent {
  final String email;
  final String password;

  AppUserLoginEvent(this.email, this.password);
}

class AppUserLogoutEvent extends AppUserEvent {}

class RegisterSubmitted extends AppUserEvent {
  final RegisterModel registerModel;
  RegisterSubmitted({required this.registerModel});
}

class ChangePasswordSubmitted extends AppUserEvent {
  final ChangePasswordModel changePasswordModel;

  ChangePasswordSubmitted({
    required this.changePasswordModel
  });
}

class DeleteCurrentUserRequested extends AppUserEvent {
  DeleteCurrentUserRequested();
}

class QRLoginRequested extends AppUserEvent {
  final String sessionId;

  QRLoginRequested({required this.sessionId});
}


