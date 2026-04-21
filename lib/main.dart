import 'dart:convert';
import 'package:ducanherp/core/navigation/route_observer.dart';
import 'package:ducanherp/core/themes/app_theme.dart';
import 'package:ducanherp/core/themes/theme_notifier.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_repository.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_bloc.dart';
import 'package:ducanherp/logic/bloc/chinhanh/chinhanh_repository.dart';
import 'package:ducanherp/logic/bloc/chucvu/chucvu_bloc.dart';
import 'package:ducanherp/logic/bloc/chucvu/chucvu_repository.dart';
import 'package:ducanherp/logic/bloc/chuyenmon/chuyenmon_bloc.dart';
import 'package:ducanherp/logic/bloc/chuyenmon/chuyenmon_repository.dart';
import 'package:ducanherp/logic/bloc/department/department_bloc.dart';
import 'package:ducanherp/logic/bloc/department/department_repository.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_bloc.dart';
import 'package:ducanherp/logic/bloc/duyet/duyet_repository.dart';
import 'package:ducanherp/routes/app_router.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_bloc.dart';
import 'package:ducanherp/logic/bloc/danhgia/danhgia_reponsitory.dart';
import 'package:ducanherp/logic/bloc/nhomnhanvien/nhomnhanvien_repository.dart';
import 'package:ducanherp/logic/bloc/notification/notification_event.dart';
import 'package:ducanherp/logic/bloc/notification/notification_reponsitory.dart';
import 'package:ducanherp/logic/bloc/notification/notification_bloc.dart';
import 'package:ducanherp/logic/bloc/permission/permission_bloc.dart';
import 'package:ducanherp/logic/bloc/permission/permission_event.dart';
import 'package:ducanherp/logic/bloc/permission/permission_repository.dart';
import 'package:ducanherp/logic/bloc/permission/permission_state.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_bloc.dart';
import 'package:ducanherp/logic/bloc/quanlynhanvien/quanlynhanvien_repository.dart';
import 'package:ducanherp/core/helpers/user_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic/bloc/nhanvien/nhanvien_bloc.dart';
import 'logic/bloc/nhanvien/nhanvien_repository.dart';
import 'logic/bloc/nhomnhanvien/nhomnhanvien_bloc.dart';
import 'logic/bloc/congviec/congviec_bloc.dart';
import 'logic/bloc/congviecdg/congviecdg_bloc.dart';
import 'logic/bloc/download/download_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _initLocalNotifications();

  final prefs = await SharedPreferences.getInstance();
  final client = http.Client();

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: prefs),
        Provider<http.Client>.value(value: client),
        BlocProvider(
          create:
              (_) =>
                  AppUserBloc(AppUserRepository(client: client, prefs: prefs)),
        ),
        BlocProvider(create: (_) => CongViecBloc(client: client, prefs: prefs)),
        BlocProvider(
          create: (_) => CongViecDGBloc(client: client, prefs: prefs),
        ),
        BlocProvider(
          create:
              (_) => NhanVienBloc(
                repository: NhanVienRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => NhomNhanVienBloc(
                repository: NhomNhanVienRepository(
                  client: client,
                  prefs: prefs,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => QuanLyNhanVienBloc(
                repository: QuanLyNhanVienRepository(
                  client: client,
                  prefs: prefs,
                ),
              ),
        ),
        BlocProvider(create: (_) => DownloadBloc()),
        BlocProvider(create: (_) => DanhGiaBloc(DanhGiaRepository(prefs))),
        BlocProvider(
          create:
              (_) => PermissionBloc(
                PermissionRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => NotificationBloc(
                repository: NotificationRepository(
                  client: client,
                  prefs: prefs,
                ),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChiNhanhBloc(
                ChiNhanhRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => DepartmentBloc(
                repository: DepartmentRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChucVuBloc(
                repository: ChucVuRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => ChuyenMonBloc(
                repository: ChuyenMonRepository(client: client, prefs: prefs),
              ),
        ),

        BlocProvider(
          create:
              (_) => ChiNhanhBloc(
                ChiNhanhRepository(client: client, prefs: prefs),
              ),
        ),
        BlocProvider(
          create:
              (_) => DuyetBloc(
                repository: DuyetRepository(client: client, prefs: prefs),
              ),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndRedirect().then((isLoggedIn) {
      if (isLoggedIn) {
        _initFirebaseMessaging();
      }
    });
  }

  Future<bool> _checkLoginAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final expiration = prefs.getString('expiration');
    final user = await UserStorageHelper.getCachedUserInfo();

    if (savedToken == null) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );
      return false;
    }

    if (expiration != null && user != null && user.id.isNotEmpty) {
      final expDate = DateTime.tryParse(expiration) ?? DateTime(0);
      if (expDate.isAfter(DateTime.now())) {
        final now = DateTime.now();

        // ignore: use_build_context_synchronously
        final permissionBloc = BlocProvider.of<PermissionBloc>(context);
        permissionBloc.add(
          FetchPermissions(
            groupId: user.groupId,
            userId: user.id,
            parentMajorId: "249ff511-8f10-45e8-bf8f-29b0ada5ab84",
          ),
        );

        final permState =
            await permissionBloc.stream.firstWhere(
                  (state) => state is PermissionLoaded,
                )
                as PermissionLoaded;

        final permissionJsonList =
            permState.permissions.map((p) => jsonEncode(p.toJson())).toList();
        await prefs.setStringList('permissions', permissionJsonList);
        await prefs.setString('permissions_date', now.toIso8601String());

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRouter.home,
          (route) => false,
        );
        return true;
      } else {
        await prefs.remove('token');
      }
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRouter.login,
      (route) => false,
    );
    return false;
  }

  void _initFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    final fcmToken = await messaging.getToken();
    final user = await UserStorageHelper.getCachedUserInfo();

    if (fcmToken != null && user != null && user.id.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.read<NotificationBloc>().add(
        RegisterTokenEvent(
          token: fcmToken,
          groupId: user.groupId,
          userId: user.id,
        ),
      );
    } else {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );
    }

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
      // ignore: use_build_context_synchronously
      context.read<NotificationBloc>().add(GetUnreadNotiByUserIdEvent());
      // ignore: use_build_context_synchronously
      context.read<NotificationBloc>().add(GetReadFireBaseIdEvent());
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      navigatorKey.currentState?.pushNamed(
        AppRouter.notifications,
        arguments: {'notification': message},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.currentTheme,
      navigatorKey: navigatorKey,
      title: 'Ducanherp',
      initialRoute: '/splash',
      navigatorObservers: [routeObserver],
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

Future<void> _initLocalNotifications() async {
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const initSettings = InitializationSettings(
    android: androidInit,
    iOS: iosInit,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (response) {
      if (response.payload != null) {
        //final data = jsonDecode(response.payload!);
        // navigatorKey.currentState?.pushNamed(
        //   AppRouter.notifications,
        //   arguments: RemoteMessage(
        //     data: Map<String, dynamic>.from(data['data']),
        //     notification: RemoteNotification(
        //       title: data['title'],
        //       body: data['body'],
        //     ),
        //   ),
        // );
        navigatorKey.currentState?.pushNamed(AppRouter.notifications);
      }
    },
  );
}

Future<void> _showNotification(RemoteMessage message) async {
  const androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Thông báo',
    channelDescription: 'Kênh thông báo chính',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'notification_icon',
    color: Color(0xFFFFFFFF),
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  final payload = jsonEncode({
    'title': message.notification?.title,
    'body': message.notification?.body,
    'data': message.data,
  });

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'Thông báo',
    message.notification?.body ?? '',
    notificationDetails,
    payload: payload,
  );
}
