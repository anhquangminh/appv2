import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ducanherp/core/helpers/network_exception_helper.dart';
import 'appuser_event.dart';
import 'appuser_state.dart';
import 'appuser_repository.dart';

class AppUserBloc extends Bloc<AppUserEvent, AppUserState> {
  final AppUserRepository repository;

  AppUserBloc(this.repository) : super(AppUserState()) {
    on<AppUserLoginEvent>((event, emit) async {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        emit(
          AppUserState(errorMessage: 'Vui lòng kiểm tra kết nối mạng của bạn'),
        );
        return;
      }

      emit(AppUserState(isLoading: true));
      try {
        final loginResponse = await repository.login(
          event.email,
          event.password,
        );
        if (!loginResponse.success) {
          emit(AppUserState(errorMessage: loginResponse.message));
        } else {
          await repository.saveToken(
            loginResponse.data['token'],
            loginResponse.data['expiration'],
          );
          final user = await repository.fetchUserInfo(event.email);
          if (user != null) {
            await repository.saveUserInfo(user);
            emit(
              AppUserState(
                token: loginResponse.data['token'],
                expiration: loginResponse.data['expiration'],
                isLoggedIn: true,
              ),
            );
          } else {
            emit(AppUserState(errorMessage: 'Lấy thông tin user thất bại'));
          }
        }
      } catch (e) {
        handleNetworkException(e);
        
      }
    });

    on<AppUserLogoutEvent>((event, emit) async {
      try {
        await repository.logout();
        emit(AppUserState(isLoggedIn: false));
      } catch (e) {
        handleNetworkException(e);
        
      }
    });

    on<RegisterSubmitted>((event, emit) async {
      emit(
        state.copyWith(isLoading: true, errorMessage: '', isRegistered: false),
      );
      try {
        final result = await repository.register(event.registerModel);
        final body = json.decode(result['body']);
        if (result['statusCode'] == 200 && body['success'] == true) {
          emit(state.copyWith(isLoading: false, isRegistered: true));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: body['message'] ?? result['reasonPhrase'],
              isRegistered: false,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Đăng ký thất bại: $e',
            isRegistered: false,
          ),
        );
      }
    });

    on<ChangePasswordSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: ''));
      try {
        final result = await repository.changePassword(
          changePasswordModel: event.changePasswordModel,
        );
        final body = json.decode(result['body']);
        if (result['statusCode'] == 200 && body['success'] == true) {
          emit(state.copyWith(isLoading: false, isPasswordChanged: true));
        } else {
          emit(
            state.copyWith(
              isLoading: false,
              errorMessage: body['message'] ?? result['reasonPhrase'],
              isRegistered: false,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Đã xảy ra lỗi khi đổi mật khẩu: $e',
          ),
        );
        handleNetworkException(e);
      }
    });

    on<DeleteCurrentUserRequested>((event, emit) async {
      emit(DeleteCurrentUserLoading());
      try {
        final result = await repository.deleteCurrentUser();
        final statusCode = result['statusCode'];
        final body = json.decode(result['body']);
        if (statusCode == 200 && body['success'] == true) {
          emit(DeleteCurrentUserSuccess());
        } else {
          emit(
            DeleteCurrentUserFailure(
              error: body['message'] ?? 'Xóa tài khoản thất bại!',
            ),
          );
        }
      } catch (e) {
        emit(DeleteCurrentUserFailure(error: e.toString()));
      }
    });

    on<QRLoginRequested>((event, emit) async {
      emit(AppUserLoading()); // Phát trạng thái loading
      try {
        final response = await repository.qrLogin(event.sessionId);
        // Kiểm tra mã trạng thái HTTP
        if (response['statusCode'] == 200) {
          emit(AppUserSuccess(message: 'Xác thực thành công!'));
        } else {
          emit(AppUserError(
            message: response['reasonPhrase'] ?? 'Lỗi xác thực: ${response['statusCode']}',
          ));
        }
      } catch (e) {
        emit(AppUserError(message: 'Đã xảy ra lỗi khi xác thực: $e'));
      }
    });
  }
}
