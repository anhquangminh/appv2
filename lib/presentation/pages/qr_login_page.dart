import 'dart:ui';
import 'package:ducanherp/logic/bloc/appuser/appuser_bloc.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_event.dart';
import 'package:ducanherp/logic/bloc/appuser/appuser_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRLoginPage extends StatefulWidget {
  const QRLoginPage({super.key});

  @override
  State<QRLoginPage> createState() => _QRLoginPageState();
}

class _QRLoginPageState extends State<QRLoginPage> {
  MobileScannerController cameraController = MobileScannerController();
  String? sessionId;
  String? errorMessage;
  bool isLoginSuccessful = false;
  bool isLoading = false;

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;
    if (code != null && sessionId == null) {
      setState(() {
        sessionId = code;
      });
      cameraController.stop();
    }
  }

  void _confirmLogin() {
    if (sessionId != null) {
      setState(() {
        isLoading = true;
      });
      context.read<AppUserBloc>().add(QRLoginRequested(sessionId: sessionId!));
    }
  }

  void _retryScan() {
    setState(() {
      sessionId = null;
      errorMessage = null;
      isLoginSuccessful = false;
      isLoading = false;
    });
    cameraController.start(); // Mở lại camera
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserBloc, AppUserState>(
      listener: (context, state) {
        if (state is AppUserSuccess) {
          setState(() {
            isLoginSuccessful = true;
            errorMessage = null;
            isLoading = false;
          });
        } else if (state is AppUserError) {
          setState(() {
            isLoginSuccessful = false;
            errorMessage =
                state.errorMessage ?? "Đăng nhập thất bại. Vui lòng thử lại.";
            isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: sessionId != null ? Colors.white : Colors.transparent,
        body: Stack(
          children: [
            if (sessionId == null)
              Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: _onDetect,
                  ),
                  _buildScannerOverlay(context),
                ],
              ),


            Positioned(
              top: 50,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(47, 61, 60, 60),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 30),
                ),
              ),
            ),
            if (sessionId != null)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/logo.png', height: 100),
                          const SizedBox(height: 24),
                          const Text(
                            'Bạn có muốn xác thực đăng nhập\ntrên website không?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Session ID: $sessionId',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          if (isLoading)
                            const CircularProgressIndicator()
                          else if (errorMessage != null)
                            Column(
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                _buildRetryButton(),
                              ],
                            )
                          else if (isLoginSuccessful)
                              Column(
                                children: [
                                  const Text(
                                    'Đăng nhập thành công!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildCloseButton(),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _buildConfirmButton(),
                                  const SizedBox(height: 12),
                                  _buildRetryButton(),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scanSize = size.width * 0.7;

    return Stack(
      children: [
        // Làm mờ vùng ngoài bằng BackdropFilter
        Positioned.fill(
          child: ClipPath(
            clipper: _ScannerHoleClipper(scanSize: scanSize),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: const Color.fromARGB(87, 12, 5, 5),
              ),
            ),
          ),
        ),

        // Viền 4 góc
        Center(
          child: CustomPaint(
            size: Size(scanSize, scanSize),
            painter: CornerPainter(
              cornerLength: 24,
              strokeWidth: 4,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _confirmLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Xác nhận đăng nhập',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _retryScan,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.orangeAccent,
          side: const BorderSide(color: Colors.orangeAccent),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Quét lại QR code', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildCloseButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Đóng',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  final double cornerLength;
  final double strokeWidth;
  final Color color;

  CornerPainter({
    required this.cornerLength,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Top-left
    path.moveTo(0, cornerLength);
    path.lineTo(0, 0);
    path.lineTo(cornerLength, 0);

    // Top-right
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerLength);

    // Bottom-right
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom-left
    path.moveTo(cornerLength, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _ScannerHoleClipper extends CustomClipper<Path> {
  final double scanSize;

  _ScannerHoleClipper({required this.scanSize});

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanSize,
      height: scanSize,
    );
    path.addRect(hole);
    return Path.combine(PathOperation.difference, path, Path()..addRect(hole));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
