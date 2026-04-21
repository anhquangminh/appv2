// import 'package:ducanherp/data/models/application_user.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../data/models/api_response_model.dart';
// import 'package:ducanherp/core/helpers/network_exception_helper.dart';

// class LoginEvent {
//   final String email;
//   final String password;

//   LoginEvent(this.email, this.password);
// }

// class LogoutEvent {}

// class LoginState {
//   final bool isLoading;
//   final String? errorMessage;
//   final String? token;
//   final String? expiration;
//   final bool isLoggedIn;

//   LoginState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.token,
//     this.expiration,
//     this.isLoggedIn = false,
//   });
// }

// class LoginBloc extends Bloc<dynamic, LoginState> {
//   LoginBloc() : super(LoginState()) {
//     on<LoginEvent>((event, emit) async {
//       var connectivityResult = await Connectivity().checkConnectivity();
//       // Đây là một giá trị duy nhất: ConnectivityResult
//       if (connectivityResult.contains(ConnectivityResult.none)) {
//         emit(
//           LoginState(errorMessage: 'Vui lòng kiểm tra kết nối mạng của bạn'),
//         );
//         return;
//       }

//       emit(LoginState(isLoading: true));

//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request(
//         'POST',
//         Uri.parse('${dotenv.env['API_URL']}/api/user/Login'),
//       );
//       request.body = json.encode({
//         "Email": event.email,
//         "Password": event.password,
//         "RememberMe": true,
//       });
//       request.headers.addAll(headers);

//       try {
//         http.StreamedResponse response = await request.send().timeout(
//           const Duration(seconds: 15),
//         );

//         if (response.statusCode == 200) {
//           var responseString = await response.stream.bytesToString();
//           var jsonResponse = ApiResponseModel.fromJson(
//             json.decode(responseString),
//           );

//           if (!jsonResponse.success) {
//             emit(LoginState(errorMessage: jsonResponse.message));
//           } else {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString('token', jsonResponse.data['token']);
//             await prefs.setString(
//               'expiration',
//               jsonResponse.data['expiration'],
//             );

//             // Lấy thông tin user
//             try {
//               final userInfoRequest = http.Request(
//                 'GET',
//                 Uri.parse(
//                   '${dotenv.env['API_URL']}/api/ApplicationUser/getInforUser?userName=${event.email}',
//                 ),
//               );
//               userInfoRequest.headers.addAll({
//                 'Authorization': 'Bearer ${jsonResponse.data['token']}',
//                 'Content-Type': 'application/json',
//               });

//               final userInfoResponse = await userInfoRequest.send();
//               final response = await http.Response.fromStream(userInfoResponse);

//               if (userInfoResponse.statusCode == 200) {
//                 final decoded = json.decode(response.body);
//                 final apiResponse = ApiResponseModel.fromJson(decoded);
//                 if (!apiResponse.success) {
//                   emit(LoginState(errorMessage: apiResponse.message));
//                   return;
//                 } else {
//                   final applicationUser = ApplicationUser.fromJson(
//                     apiResponse.data,
//                   );
//                   await prefs.setString(
//                     'userInfo',
//                     json.encode(applicationUser.toJson()),
//                   );
//                 }

//                 emit(
//                   LoginState(
//                     token: jsonResponse.data['token'],
//                     expiration: jsonResponse.data['expiration'],
//                     isLoggedIn: true,
//                   ),
//                 );
//               } else {
//                 emit(LoginState(errorMessage: 'Lấy thông tin user thất bại'));
//               }
//             } catch (e) {
//               handleNetworkException(e);
//               emit(LoginState(errorMessage: 'Lỗi lấy thông tin user: $e'));
//             }
//           }
//         } else if (response.statusCode == 400) {
//           var responseString = await response.stream.bytesToString();
//           var jsonResponse = ApiResponseModel.fromJson(
//             json.decode(responseString),
//           );
//           emit(LoginState(errorMessage: jsonResponse.message));
//         } else {
//           emit(LoginState(errorMessage: response.reasonPhrase));
//         }
//       } catch (e) {
//         handleNetworkException(e);
//         emit(LoginState(errorMessage: 'Đã xảy ra lỗi: $e'));
//       }
//     });

//     on<LogoutEvent>((event, emit) async {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('token');
//         await prefs.remove('expiration');
//         emit(LoginState(isLoggedIn: false));
//       } catch (e) {
//         handleNetworkException(e);
//         emit(LoginState(errorMessage: 'Đã xảy ra lỗi khi đăng xuất: $e'));
//       }
//     });
//   }
// }
