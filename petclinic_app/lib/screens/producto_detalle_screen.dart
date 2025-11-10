import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'producto_form_screen.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> producto;

  const ProductoDetalleScreen({
    super.key,
    required this.token,
    required this.producto,
  });

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  late Map<String, dynamic> producto;

  @override
  void initState() {
    super.initState();
    producto = widget.producto;
  }

  Future<void> eliminarProducto() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar producto"),
        content: const Text(
            "¿Seguro que deseas eliminar este producto? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteProducto(widget.token, producto['id']);
      if (context.mounted) Navigator.pop(context, true); 
    }
  }

  Future<void> editarProducto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(
          token: widget.token,
          producto: producto,
        ),
      ),
    );

    if (result == true) {
      setState(() {
        producto = Map.from(producto);
      });
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imagenUrl = producto['imagen'] != null
        ? "http://192.168.100.81:3000/uploads/${producto['imagen']}" 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editarProducto,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: eliminarProducto,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: imagenUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imagenUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imagenUrl == null
                  ? const Icon(Icons.inventory, size: 100, color: Colors.white70)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              producto['nombre'] ?? "Sin nombre",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              producto['categoria'] ?? 'Sin categoría',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              "\$${producto['precio']}",
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 6),
            Text("Stock: ${producto['stock']} unidades"),
            const SizedBox(height: 6),
            Text("Tipo de animal: ${producto['tipo_animal']}"),
            const SizedBox(height: 20),
            Text(
              "Descripción:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            Text(producto['descripcion'] ?? "Sin descripción disponible"),
          ],
        ),
      ),
    );
  }
}
