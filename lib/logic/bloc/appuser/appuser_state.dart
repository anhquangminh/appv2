class AppUserState {
  final bool isLoading;
  final String? errorMessage;
  final String? token;
  final String? expiration;
  final bool isLoggedIn;
  final bool isRegistered; 
  final bool isPasswordChanged;

  AppUserState({
    this.isLoading = false,
    this.errorMessage,
    this.token,
    this.expiration,
    this.isLoggedIn = false,
    this.isRegistered = false,
    this.isPasswordChanged = false,
  });

  AppUserState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? token,
    String? expiration,
    bool? isLoggedIn,
    bool? isRegistered,
    bool? isPasswordChanged,
  }) {
    return AppUserState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      token: token ?? this.token,
      expiration: expiration ?? this.expiration,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isRegistered: isRegistered ?? this.isRegistered,
      isPasswordChanged: isPasswordChanged ?? this.isPasswordChanged,
    );
  }
}
class DeleteCurrentUserLoading extends AppUserState {}

class DeleteCurrentUserSuccess extends AppUserState {}

class DeleteCurrentUserFailure extends AppUserState {
  final String error;
  DeleteCurrentUserFailure({required this.error});
}


class AppUserLoading extends AppUserState {}
class AppUserSuccess extends AppUserState {
  final String message;

  AppUserSuccess({required this.message});
}
class AppUserError extends AppUserState {
  final String message;

  AppUserError({required this.message});
}