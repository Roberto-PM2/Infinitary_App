import 'package:eco_habit/huella_page.dart';
import 'package:eco_habit/lugares_page.dart';
import 'package:flutter/material.dart';
import 'alerts_page.dart';
import 'notifications_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildButton(Icons.notifications_active, 'Alertas', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlertsPage()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildButton(Icons.recycling, 'Centros de reciclaje', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CentrosReciclaje()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildButton(Icons.eco, 'Huella de carbono', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HuellaCarbono()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildDisabledButton(Icons.menu_book, 'Guías'),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        NotificationService().cancellAllNotifications(
                          
                        );
                      },
                      child: const Text(
                        'Política y acuerdos de uso',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xff368983),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Center(
            child: const Text(
              'Bienvenido a EcoHabit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(text, style: TextStyle(fontSize: 20)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledButton(IconData icon, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 30),
        label: Text(text, style: TextStyle(fontSize: 20)),
        onPressed: null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }
}
