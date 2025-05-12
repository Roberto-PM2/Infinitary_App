import 'package:eco_habit/huella_page.dart';
import 'package:eco_habit/lista_centros.dart';
import 'package:eco_habit/mapa_page.dart';
import 'package:flutter/material.dart';
import 'alerts_page.dart';
import 'notifications_service.dart';
import 'politica.dart';
import 'package:geolocator/geolocator.dart';
import 'guias/guias_page.dart';
import 'huella_menu.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Position> determinePosition() async{
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
        
      }
      
    }
    return await Geolocator.getCurrentPosition();
    
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    print(position.latitude);
    print(position.longitude);
  }

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
                        MaterialPageRoute(builder: (context) => const HuellaMenu()),
                      );
                    }),
                    
                    const SizedBox(height: 20),
                    _buildButton(Icons.menu_book, 'Guías', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GuiasPage()),
                      );
                    }),

                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        getCurrentLocation();
                      },
                      child: const Text(
                        'clic aqui para activar permisos',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PoliticaPage()),
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
