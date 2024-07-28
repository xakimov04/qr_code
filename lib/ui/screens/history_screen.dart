import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_code/controller/create_qr_code_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controller/qr_code_database.dart';
import 'scanner_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> qrCodes = [];
  List<Map<String, dynamic>> createQrCodes = [];

  bool isScanSelected = true;

  @override
  void initState() {
    super.initState();
    fetchQRCodes();
  }

  Future<void> fetchQRCodes() async {
    final scannedData = await DatabaseHelper().getQRCodes();
    final createdData = await CreateQrCodeDatabase().getQRCodes();
    setState(() {
      qrCodes = scannedData;
      createQrCodes = createdData;
    });
  }

  Future<void> deleteQRCode(int id, bool isScan) async {
    if (isScan) {
      await DatabaseHelper().deleteQRCode(id);
    } else {
      await CreateQrCodeDatabase().deleteQRCode(id);
    }
    fetchQRCodes();
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'History',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'itim',
                fontSize: 25,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              _buildToggleButton(),
              Expanded(
                child: _buildListView(
                  isScanSelected ? qrCodes : createQrCodes,
                  (id) => deleteQRCode(id, isScanSelected),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xff393939),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isScanSelected = true),
                child: _buildToggleOption("Scan", isScanSelected),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isScanSelected = false),
                child: _buildToggleOption("Create", !isScanSelected),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffFDB623), Color(0xff9A762B)],
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.transparent],
                ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'itim',
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
      List<Map<String, dynamic>> items, Function(int) onDelete) {
    return items.isEmpty
        ? Center(
            child: Image.asset(
              "assets/icons/not.png",
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerResult(
                        save: true,
                        scanData: Barcode(
                          item['code'],
                          BarcodeFormat.qrcode,
                          [0, 0, 0, 0],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff383838),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/data.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['code'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'itim',
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(5),
                            Text(
                              item['time'].toString().substring(0, 5),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            child:
                                const Icon(Icons.delete, color: Colors.orange),
                            onTap: () async {
                              await onDelete(item['id']);
                            },
                          ),
                          Text(
                            item['date'],
                            style: const TextStyle(
                                color: Colors.grey, fontFamily: 'itim'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
