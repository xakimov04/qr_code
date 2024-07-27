import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/ui/widgets/custom_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/qr_code_database.dart';

class ScannerResult extends StatelessWidget {
  final Barcode scanData;
  const ScannerResult({super.key, required this.scanData});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('MMM d EEEE, yyyy').format(now);
    String watch = DateFormat('HH:mm').format(now);

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: scanData.code!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Link copied',
            style: TextStyle(
              fontFamily: 'itim',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    void shareData() {
      Share.share(scanData.code!);
    }

    Future<void> showQRCode() async {
      final Uri? uri = Uri.tryParse(scanData.code!);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }

    void saveData() async {
      await DatabaseHelper().insertQRCode(scanData.code!, date, watch);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data saved',
            style: TextStyle(
              fontFamily: 'itim',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/fon2.png",
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            title: const Text(
              "QR Code",
              style: TextStyle(
                fontFamily: 'itim',
                color: Color(0xffD9D9D9),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff414140),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/data.png",
                              width: 50,
                              height: 50,
                            ),
                            const Gap(10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data",
                                  style: TextStyle(
                                    color: Color(0xffD9D9D9),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'itim',
                                  ),
                                ),
                                Text(
                                  "$date, $watch",
                                  style: const TextStyle(
                                    color: Color(0xffD9D9D9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'itim',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color(0xff858585),
                        ),
                        Text(
                          scanData.code!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xffD9D9D9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'itim',
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: showQRCode,
                            child: const Text(
                              "Show QR Code",
                              style: TextStyle(
                                color: Color(0xffFDB623),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
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
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: shareData,
                    icon: Icons.share,
                    text: 'Share',
                  ),
                  const Gap(20),
                  CustomButton(
                    onTap: copyToClipboard,
                    icon: Icons.copy_rounded,
                    text: 'Copy',
                  ),
                  const Gap(20),
                  CustomButton(
                    onTap: saveData,
                    icon: Icons.save,
                    text: 'Save',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
