import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/controller/create_qr_code_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../controller/qr_code_database.dart';
import 'scanner_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> qrCodes = [];
  List<Map<String, dynamic>> createQrCodes = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchQRCodes();
    fetchCreateQRCodes();
  }

  Future<void> fetchQRCodes() async {
    final data = await DatabaseHelper().getQRCodes();
    setState(() {
      qrCodes = data;
    });
  }

  Future<void> fetchCreateQRCodes() async {
    final data = await CreateQrCodeDatabase().getQRCodes();
    setState(() {
      createQrCodes = data;
    });
  }

  Future<void> deleteQRCode(int id) async {
    await DatabaseHelper().deleteQRCode(id);
    fetchQRCodes();
  }

  Future<void> deleteCreateQRCode(int id) async {
    await CreateQrCodeDatabase().deleteQRCode(id);
    fetchCreateQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    print(createQrCodes);
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
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orange,
              tabs: const [
                Tab(text: 'Scan'),
                Tab(text: 'Create'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildListView(qrCodes, deleteQRCode),
              _buildListView(createQrCodes, deleteCreateQRCode),
            ],
          ),
        ),
      ],
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
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
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
