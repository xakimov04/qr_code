import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code/ui/screens/generate_qr_screen.dart';

class AddQrScreen extends StatelessWidget {
  const AddQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF525252),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Generate QR',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'itim',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 36,
          mainAxisSpacing: 36,
          children: [
            _buildGridItem('text', 'Text', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateQrScreen(
                    image: "text",
                    title: 'Text',
                    onPressed: () {},
                  ),
                ),
              );
            }),
            _buildGridItem('site', 'Website', () {}),
            _buildGridItem('wifi', 'Wi-Fi', () {}),
            _buildGridItem('event', 'Event', () {}),
            _buildGridItem('contact', 'Contact', () {}),
            _buildGridItem('busines', 'Business', () {}),
            _buildGridItem('location', 'Location', () {}),
            _buildGridItem('whatsap', 'WhatsApp', () {}),
            _buildGridItem('email', 'Email', () {}),
            _buildGridItem('twitter', 'Twitter', () {}),
            _buildGridItem('instagram', 'Instagram', () {}),
            _buildGridItem('call', 'Telephone', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String image, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3C),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/$image.png",
              color: Colors.white,
              width: 35,
              height: 35,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'itim',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
