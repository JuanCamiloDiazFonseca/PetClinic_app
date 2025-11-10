import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pets_screen.dart';
import 'screens/citas_screen.dart';
import 'screens/categorias_screen.dart';
import 'screens/productos_screen.dart';
import 'screens/perfil_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PetClinic',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
      ),

      // Ruta inicial
      initialRoute: '/login',

      // Rutas estáticas
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },

      // Rutas dinámicas
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => HomeScreen(token: token));
        }

        if (settings.name == '/pets') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => PetsScreen(token: token));
        }

        if (settings.name == '/citas') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => CitasScreen(token: token));
        }

        if (settings.name == '/categorias') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => CategoriasScreen(token: token));
        }

        if (settings.name == '/productos') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => ProductosScreen(token: token));
        }

        if (settings.name == '/perfil') {
          final token = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => PerfilScreen(token: token));
        }

        return null;
      },
    );
  }
}
