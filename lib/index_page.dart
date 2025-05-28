import 'package:flutter/material.dart';
import 'package:fyp_iqbal/mqtt/mqtt_page.dart';
import 'package:fyp_iqbal/pages/dashboard.dart';
import 'package:fyp_iqbal/pages/inventory_page.dart';
import 'package:fyp_iqbal/pages/check_page.dart';



class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 137, 164, 209),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1,
            children: [
              SquareHomeButton(
                icon: Icons.shopping_cart_outlined,
                label: 'Rent',
                color: Colors.black,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckPage()),
                  );
                },
              ),
              SquareHomeButton(
                icon: Icons.add_box_outlined,
                label: 'Item +',
                color: Colors.black,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              SquareHomeButton(
                icon: Icons.settings_outlined,
                label: 'Setting',
                color: Colors.black,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MQTTView()),
                  );
                },
              ),
              SquareHomeButton(
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                color: Colors.black,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SquareHomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const SquareHomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 137, 164, 209),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 120,
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/**
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeButton(
                icon: Icons.shopping_cart_outlined,
                label: 'Rent',
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CheckPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              HomeButton(
                icon: Icons.add_box_outlined,
                label: 'Item +',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              HomeButton(
                icon: Icons.settings_outlined,
                label: 'Setting',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MQTTView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const HomeButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fyp_iqbal/mqtt/mqtt_page.dart';
import 'package:fyp_iqbal/pages/inventory_page.dart';
import 'package:fyp_iqbal/pages/check_page.dart';

class IndexPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Action for Rent button
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckPage()),
                );
              },
              child: Text('Rent'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Action for Item + button
                //print('Item + button pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              child: Text('Item +'),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MQTTView()),
                );
              },
              child: Text('Setting'),
            ),
          ],
        ),
      ),
    );
  }
}
*/