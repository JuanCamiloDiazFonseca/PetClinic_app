import 'package:flutter/material.dart';
import 'pets_screen.dart';
import 'citas_screen.dart';
import 'categorias_screen.dart';
import 'productos_screen.dart';
import 'login_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF146B5E);
    final Color accentColor = const Color(0xFF27F5D3);

    final List<Map<String, dynamic>> modulos = [
      {"icon": Icons.pets, "title": "Mascotas", "page": PetsScreen(token: token)},
      {"icon": Icons.calendar_month, "title": "Citas", "page": CitasScreen(token: token)},
      {"icon": Icons.category, "title": "Categorías", "page": CategoriasScreen(token: token)},
      {"icon": Icons.inventory, "title": "Productos", "page": ProductosScreen(token: token)},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.pets, color: Colors.white),
            SizedBox(width: 8),
            Text("PetClinic", style: TextStyle(color: Colors.white)),
          ],
        ),
        centerTitle: true,
      ),

      // Drawer lateral
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  color: mainColor,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: const [
                      Icon(Icons.pets, color: Colors.white, size: 70),
                      SizedBox(height: 10),
                      Text(
                        "PetClinic",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black87),
                  title: const Text("Perfil"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PerfilScreen(token: token)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Cerrar sesión"),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "© 2025 PetClinic",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: mainColor.withOpacity(0.05),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 28,
                  child: Icon(Icons.pets, color: Color(0xFF146B5E), size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "¡Bienvenido a tu portal PetClinic!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: modulos.length,
                itemBuilder: (context, index) {
                  final modulo = modulos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => modulo["page"]),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: accentColor.withOpacity(0.15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(modulo["icon"], color: accentColor, size: 60),
                          const SizedBox(height: 10),
                          Text(
                            modulo["title"],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
