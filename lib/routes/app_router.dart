// import 'package:ducanherp/data/models/congviec_model.dart';
// import 'package:ducanherp/presentation/pages/qlcv/calender_page.dart';
// import 'package:ducanherp/presentation/pages/changepassword_page.dart';
// import 'package:ducanherp/presentation/pages/notification_page.dart';
// import 'package:ducanherp/presentation/pages/qlcv/congviec_detail_page.dart';
// import 'package:ducanherp/presentation/pages/qlcv/danhsachcongviec_page.dart';
import 'package:ducanherp/presentation/pages/home/home_page.dart';
import 'package:ducanherp/presentation/pages/qr_login_page.dart';
import 'package:ducanherp/presentation/pages/splash_page.dart';
import 'package:ducanherp/presentation/screens/register_screen.dart';
import 'package:ducanherp/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:ducanherp/presentation/screens/login_screen.dart';
// import 'package:ducanherp/presentation/pages/profile_page.dart';
// import 'package:ducanherp/presentation/pages/qlcv/themcongviec_page.dart';
// import 'package:ducanherp/presentation/pages/qlcv/danhgia_page.dart';

class AppRouter {
  // Constants routes
  static const String login = '/';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String changePassword = '/changepassword-page';
  static const String splash = '/splash';

  // Công việc routes
  static const String addThemCongViec = '/them-cong-viec';
  static const String danhGiaCongViec = '/danh-gia-cong-viec';
  static const String calenderPage = '/calender-page';
  static const String reportChartPage = '/report-chart-page';
  static const String danhSachCongViecPage = '/danhsachcongviec-page';
  static const String congViecDetailPage = '/congviecdetail-page';

  // Chi tiết routes
  static const String congviecDetail = '/congviec-detail';
  static const String danhgiaDetail = '/danhgia-detail';
  static const String nhanvienDetail = '/nhanvien-detail';
  static const String nhomDetail = '/nhom-detail';

  //page
  static const String qrCodeLogin = '/qrcode-login-page';

  // List of all available routes for validation
  static final List<String> routes = [
    login,
    notifications,
    profile,
    home,
    register,
    welcome,
    changePassword,
    splash,
    addThemCongViec,
    congViecDetailPage,
    danhGiaCongViec,
    calenderPage,
    reportChartPage,
    congviecDetail,
    danhgiaDetail,
    nhanvienDetail,
    nhomDetail,
    qrCodeLogin,
  ];

  // Helper method to check if a route exists
  static bool hasRoute(String route) {
    return routes.contains(route);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case qrCodeLogin:
        return MaterialPageRoute(builder: (_) => const QRLoginPage());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case welcome:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['registerModel'] != null) {
          return MaterialPageRoute(
            builder: (_) => WelcomeScreen(registerModel: args['registerModel']),
          );
        }
        return _errorRoute();

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // case changePassword:
      //   return MaterialPageRoute(builder: (_) => const ChangePasswordPage());

      // case profile:
      //   return MaterialPageRoute(builder: (_) => const ProfilePage());

      // case notifications:
      //   return MaterialPageRoute(builder: (_) => const NotificationPage());

      // case addThemCongViec:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => ThemCongViecPage(
      //           congViecToEdit: args?['congViec'] as CongViecModel?,
      //         ),
      //   );

      // case danhSachCongViecPage:
      //   return MaterialPageRoute(builder: (_) => DanhSachCongViecPage());

      // case congViecDetailPage:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   if (args != null && args['id'] != null) {
      //     return MaterialPageRoute(
      //       builder: (_) => CongViecDetailPage(id: args['id']),
      //     );
      //   }
      //   return _errorRoute();

      // case danhGiaCongViec:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   if (args != null && args['congViec'] != null) {
      //     return MaterialPageRoute(
      //       builder: (_) => DanhGiaPage(congViec: args['congViec']),
      //     );
      //   }
      //   return _errorRoute();

      // case calenderPage:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   if (args != null && args['congViecs'] != null) {
      //     return MaterialPageRoute(
      //       builder: (_) => CalendarPage(congViecModels: args['congViecs']),
      //     );
      //   }
      //   return _errorRoute();

      // case congviecDetail:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   if (args != null && args['id'] != null) {
      //     return MaterialPageRoute(
      //       builder: (_) => CongViecDetailPage(id: args['id']),
      //     );
      //   }
      //   return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('No route defined for this path')),
          ),
    );
  }
}
