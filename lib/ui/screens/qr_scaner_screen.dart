import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code/ui/screens/scanner_result.dart';
import 'package:qr_code/ui/widgets/cam_size.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  double cutOutSize = 200.0;

  QRViewController? controller;

  @override
  void initState() {
    super.initState();
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
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScannerResult(
            scanData: scanData,
          ),
        ),
      ).then((_) {
        controller.resumeCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
