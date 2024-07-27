import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code/ui/screens/scanner_result.dart';
import 'package:qr_code/ui/widgets/cam_size.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  double cutOutSize = 200.0;

  QRViewController? controller;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller?.resumeCamera();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: const Color(0xffFDB623),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: cutOutSize,
          ),
        ),
        ResizableOverlay(
          initialSize: cutOutSize,
          onSizeChanged: (newSize) {
            setState(() {
              cutOutSize = newSize;
            });
          },
        ),
        Positioned(
          top: 45,
          left: 20,
          right: 20,
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Color(0xff414140),
                  blurRadius: 10,
                  offset: Offset(0, 0),
                ),
              ],
              color: const Color(0xff414140),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      "assets/icons/image.png",
                      width: 25,
                      height: 25,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller != null) {
                        controller!.toggleFlash();
                      }
                    },
                    child: const Icon(
                      Icons.flash_on,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller != null) {
                        controller!.flipCamera();
                      }
                    },
                    child: const Icon(
                      Icons.flip_camera_ios_rounded,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ScanAnimation(
          animationController: animationController!,
          cutOutSize: cutOutSize,
        ),
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   top: 0,
        //   bottom: 0,
        //   child: SizedBox(
        //     height: cutOutSize,
        //     width: cutOutSize,
        //     child: Lottie.asset("assets/lottie/scaner.json"),
        //   ),
        // ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      if (isValidQRCode(scanData.code)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScannerResult(scanData: scanData),
          ),
        ).then((_) {
          controller.resumeCamera();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid QR Code',
              style: TextStyle(
                fontFamily: 'itim',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        controller.resumeCamera();
      }
    });
  }

  bool isValidQRCode(String? code) {
    if (code == null || code.isEmpty) {
      return false;
    }
    return true;
  }
}

class ScanAnimation extends StatelessWidget {
  final AnimationController animationController;
  final double cutOutSize;

  const ScanAnimation({
    super.key,
    required this.animationController,
    required this.cutOutSize,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: cutOutSize,
        width: cutOutSize,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Positioned(
                  top: animationController.value * (cutOutSize - 2),
                  child: Container(
                    width: cutOutSize,
                    height: 3,
                    color: Colors.amber,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
