import 'package:ducanherp/routes/app_router.dart';
import 'package:flutter/material.dart';
import '../../data/models/register_model.dart';

class WelcomeScreen extends StatelessWidget {
  final RegisterModel registerModel;
  const WelcomeScreen({super.key, required this.registerModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100),
              const SizedBox(height: 24),
              const Icon(Icons.celebration, color: Colors.blue, size: 80),
              const SizedBox(height: 16),
              Text(
                'Chào mừng, ${registerModel.lastName} ${registerModel.firstName}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Bạn đã đăng ký thành công với email:',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                registerModel.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Chúc bạn có trải nghiệm tuyệt vời cùng ứng dụng!',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập ngay'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRouter.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
