import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter/rendering.dart';
import '../../controller/create_qr_code_database.dart';
import '../widgets/snack_bar_widget.dart';

class GenerateQrScreen extends StatefulWidget {
  final String image;
  final String title;
  final VoidCallback onPressed;

  const GenerateQrScreen({
    super.key,
    required this.image,
    required this.title,
    required this.onPressed,
  });

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  final GlobalKey qrKey = GlobalKey();
  final CreateQrCodeDatabase _databaseHelper = CreateQrCodeDatabase();
  final TextEditingController textController = TextEditingController();
  bool isSaving = false;

  Future<void> saveQRCode(String data) async {
    try {
      RenderRepaintBoundary boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final file = File('$directory/qr_code.png');
      await file.writeAsBytes(pngBytes);
      await GallerySaver.saveImage(file.path);
      DateTime now = DateTime.now();
      String date = DateFormat('MMM d EEEE, yyyy').format(now);
      String watch = DateFormat('HH:mm').format(now);

      await _databaseHelper.insertQRCode(data, date, watch);
    } catch (e) {
      throw Exception('Failed to save QR Code: $e');
    }
  }

  Future<void> generateAndShowQRCode(String data) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xff414140),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RepaintBoundary(
                    key: qrKey,
                    child: QrImageView(
                      data: data,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const Gap(20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFDB623),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onPressed: isSaving
                        ? null
                        : () async {
                            setState(() => isSaving = true);
                            try {
                              await saveQRCode(data);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBarWidget(
                                  message:
                                      'QR Code saved to gallery and database!',
                                  isError: false,
                                ).build(context),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBarWidget(
                                  message: 'Failed to save QR Code: $e',
                                  isError: true,
                                ).build(context),
                              );
                            } finally {
                              setState(() => isSaving = false);
                            }
                          },
                    child: const Text(
                      'Save to Gallery',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'itim',
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/fon2.png",
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'itim',
                fontSize: 30,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/container.png"),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/icons/${widget.image}.png",
                          color: const Color(0xffFDB623),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'itim',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(5),
                          TextField(
                            controller: textController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'itim',
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter ${widget.title}",
                              hintStyle: const TextStyle(
                                color: Color(0xffD9D9D9),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xffFDB623),
                          ),
                          onPressed: () {
                            final text = textController.text;
                            if (text.isNotEmpty) {
                              generateAndShowQRCode(text);
                              textController.text = '';
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBarWidget(
                                  message:
                                      'Please enter text to generate QR code',
                                  isError: true,
                                ).build(context),
                              );
                            }
                          },
                          child: const Text(
                            "Generate QR Code",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'itim',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
