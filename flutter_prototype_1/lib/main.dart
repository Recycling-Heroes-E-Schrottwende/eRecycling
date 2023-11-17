import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}
//Test
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.green),
          titleTextStyle: GoogleFonts.lato(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 5,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.green[50],
          labelStyle: TextStyle(color: Colors.green[600]),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        title: Text('Recycling Heroes'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Profilseite Navigator.push...
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search, color: Colors.green),
              ),
            ),
          ),
          ProductCard(
            title: 'Motherboard',
            description: 'Gigabyte H81M - 6x USB 3.0 Ports, LAN mit ESD Protection, COM, DVI, D-SUB',
            imagePath: 'assets/images/mainboard.jpeg',
          ),
          ProductCard(
            title: 'Raspberry Pi',
            description: 'Raspberry Pi4 4GB inkl. Kühlkörper, Lüfter, 64GB Kingston microSD Card',
            imagePath: 'assets/images/raspberry.jpeg',
          ),
          ProductCard(
            title: 'Gaming PC',
            description: 'Desktop Gaming PC - GTX 1060 6 GB, i5-9400F, 16 GB RAM, 1TB SSD',
            imagePath: 'assets/images/pc.jpeg',
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const ProductCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(imagePath),
        title: Text(title),
        subtitle: Text(description),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(title: title, imagePath: imagePath),
            ),
          );
        },
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  final String title;
  final String imagePath;

  const ProductPage({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                getProductDescription(title),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getProductDescription(String title) {
    switch (title) {
      case 'Motherboard':
        return '''Übergabe: Selbstabholung
Zustand: Gebraucht
Preis: €50

Beschreibung:
Das Gigabyte H81M Motherboard ist ideal für den Aufbau eines leistungsstarken, aber kompakten Systems. Es bietet USB 3.0 Anschlüsse, LAN mit ESD Protection, COM, DVI und D-SUB. Dieses Mainboard ist in einem guten gebrauchten Zustand und wurde stets sorgfältig behandelt. Perfekt für PC-Bastler und Upgrader!

Bitte bei Interesse eine Nachricht senden oder anrufen!''';
      case 'Raspberry Pi':
        return '''Übergabe: Selbstabholung
Zustand: Neuwertig
Preis: €75

Beschreibung Raspberry:
Marke: Raspberry Pi
Raspberry Pi4 Model B
- 4GB RAM
- Inkl. Kühlkörper, Lüfter, 64GB Kingston microSDXC Card, SDCard Adapter, offizielles Netzteil USB-C, 5.1V, 3A, 15,3W

Technische Daten:
- GPU: Broadcom VideoCore VI
- Video Ausgänge: 2x Micro HDMI 2.0, 1x MIPI DSI
- Video Eingänge: 1x MIPI CSI2
- Audio: 1x 3.5mm Klinke, 1x Micro HDMI 2.0
- Anschlüsse extern: 2x USB-A 3.0, 2x USB-A 2.0, 1x microSDXC
- Anschlüsse intern: 1x PoE-Header
- GPIO: 26-Pin, 40-Pin gesamt
- Wireless: WLAN 802.11a/b/g/n/ac, Bluetooth 5.0, BLE
- LAN: 1x Gb LAN
- Abmessungen: 93x20x63.5mm

Funktion 1A, neuwertig!

Bitte Nachricht senden, anrufen, WhatsApp oder SMS!
+ 43 664 3411421

Keine Garantie lt. geltenden Gesetz für Privatverkäufer!
Es kann nach Absprache Vorort getestet und besichtigt werden!''';
      case 'Gaming PC':
        return '''Übergabe: Selbstabholung
Zustand: Gebraucht
Preis: €800

Beschreibung Gaming PC:
Marke: Andere Marken
Eigenschaften:
- Gehäuse: NZXT H510i Rot
- Gehäuselüfter: 4 Stück, 120 mm NZXT
- Mainboard: Asus PRIME Z370-II
- CPU: i5-9400f (6 core, 6 Threads)
- Arbeitsspeicher: 2x Corsair Vengeance 8 GB 3000 MHz
- GPU: ASUS GTX 1060 6 GB
- Netzteil: Chieftec 550W
- SSD: 120 GB Kingston

Beschreibung:
Dieser PC wurde für Gaming und Lernen verwendet. Keine Komponenten wurden übertaktet. Verkauft, da auf Laptop umgestiegen wurde. Funktioniert einwandfrei, Tests vor Ort möglich.

Was nach dem Kauf zu tun ist: Wärmeleitpaste auf der CPU austauschen.''';
      default:
        return 'Beschreibung nicht verfügbar';
    }
  }
}
