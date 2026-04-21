class ChangePasswordModel {
  final String email;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordModel({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      email: json['email'],
      currentPassword: json['currentPassword'],
      newPassword: json['newPassword'],
      confirmPassword: json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}
