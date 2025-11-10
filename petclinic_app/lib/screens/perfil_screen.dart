import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PerfilScreen extends StatefulWidget {
  final String token;
  const PerfilScreen({super.key, required this.token});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Map<String, dynamic>? usuario;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPerfil();
  }

  Future<void> fetchPerfil() async {
    try {
      final data = await ApiService.getPerfil(widget.token);
      setState(() {
        usuario = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar perfil")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = const Color(0xFF146B5E);
    final Color accentColor = const Color(0xFF27F5D3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Mi Perfil"),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : usuario == null
              ? const Center(child: Text("No se encontró información del usuario"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: accentColor.withOpacity(0.2),
                        child: const Icon(Icons.pets,
                            color: Color(0xFF146B5E), size: 60),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Perfil de Usuario",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _infoCard(Icons.person, "Nombre", usuario!['nombre'], accentColor),
                      const SizedBox(height: 10),
                      _infoCard(Icons.email, "Correo electrónico", usuario!['email'], accentColor),
                      const SizedBox(height: 10),
                      _infoCard(Icons.badge, "Rol", usuario!['rol'], accentColor),
                    ],
                  ),
                ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
