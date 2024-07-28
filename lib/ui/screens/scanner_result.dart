import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/ui/widgets/custom_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/qr_code_database.dart';
import '../widgets/snack_bar_widget.dart';

class ScannerResult extends StatelessWidget {
  final bool save;
  final String? data;
  final Barcode? scanData;

  const ScannerResult({
    Key? key,
    this.scanData,
    this.save = false,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('MMM d EEEE, yyyy').format(now);
    String watch = DateFormat('HH:mm').format(now);

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
            leading: BackButton(color: Colors.white),
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
                child: QRCodeDataCard(
                  date: date,
                  watch: watch,
                  data: scanData?.code ?? data ?? '',
                  onShowQRCode: () => _showQRCode(scanData?.code, context),
                ),
              ),
              const Gap(40),
              ActionButtons(
                save: save,
                scanData: scanData,
                onShareData: () => _shareData(scanData?.code),
                onCopyToClipboard: () =>
                    _copyToClipboard(scanData?.code, context),
                onSaveData: () =>
                    _saveData(scanData?.code, date, watch, context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String? data, BuildContext context) {
    if (data != null) {
      Clipboard.setData(ClipboardData(text: data));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBarWidget(
          message: 'Link copied',
          isError: false,
        ).build(context),
      );
    }
  }

  void _shareData(String? data) {
    if (data != null) {
      Share.share(data);
    }
  }

  Future<void> _showQRCode(String? data, BuildContext context) async {
    if (data != null) {
      final Uri? uri = Uri.tryParse(data);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  Future<void> _saveData(
      String? data, String date, String watch, BuildContext context) async {
    if (data != null) {
      await DatabaseHelper().insertQRCode(data, date, watch);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBarWidget(
          message: 'Data saved',
          isError: false,
        ).build(context),
      );
    }
  }
}

class QRCodeDataCard extends StatelessWidget {
  final String date;
  final String watch;
  final String data;
  final VoidCallback onShowQRCode;

  const QRCodeDataCard({
    Key? key,
    required this.date,
    required this.watch,
    required this.data,
    required this.onShowQRCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QRCodeDataHeader(date: date, watch: watch),
            const Divider(color: Color(0xff858585)),
            QRCodeDataText(data: data),
            Center(
              child: GestureDetector(
                onTap: onShowQRCode,
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
    );
  }
}

class QRCodeDataHeader extends StatelessWidget {
  final String date;
  final String watch;

  const QRCodeDataHeader({
    Key? key,
    required this.date,
    required this.watch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class QRCodeDataText extends StatelessWidget {
  final String data;

  const QRCodeDataText({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xffD9D9D9),
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'itim',
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final bool save;
  final Barcode? scanData;
  final VoidCallback onShareData;
  final VoidCallback onCopyToClipboard;
  final VoidCallback onSaveData;

  const ActionButtons({
    Key? key,
    required this.save,
    required this.scanData,
    required this.onShareData,
    required this.onCopyToClipboard,
    required this.onSaveData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomButton(
          onTap: onShareData,
          icon: Icons.share,
          text: 'Share',
        ),
        const Gap(20),
        CustomButton(
          onTap: onCopyToClipboard,
          icon: Icons.copy_rounded,
          text: 'Copy',
        ),
        const Gap(20),
        if (!save)
          CustomButton(
            onTap: onSaveData,
            icon: Icons.save_outlined,
            text: 'Save',
          ),
      ],
    );
  }
}
