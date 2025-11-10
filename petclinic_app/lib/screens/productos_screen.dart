import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'producto_form_screen.dart';
import 'producto_detalle_screen.dart';

class ProductosScreen extends StatefulWidget {
  final String token;
  const ProductosScreen({super.key, required this.token});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List<dynamic> productos = [];
  bool loading = true;
  String search = "";

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    final data = await ApiService.getProductos(widget.token);
    setState(() {
      productos = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = productos
        .where((p) => p['nombre']
            .toString()
            .toLowerCase()
            .contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Productos")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductoFormScreen(token: widget.token),
            ),
          );
          if (updated == true) fetchProductos();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar productos",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(child: Text("No hay productos"))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final prod = filtered[i];
                              final String? imagenUrl = prod['imagen'] != null
                                  ? "http://192.168.100.81:3000/uploads/${prod['imagen']}"
                                  : null; 
                              return GestureDetector(
                                onTap: () async {
                                  final updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductoDetalleScreen(
                                        token: widget.token,
                                        producto: prod,
                                      ),
                                    ),
                                  );
                                  if (updated == true) fetchProductos();
                                },

                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[300],
                                            image: imagenUrl != null
                                                ? DecorationImage(
                                                    image:
                                                        NetworkImage(imagenUrl),
                                                    fit: BoxFit.cover)
                                                : null,
                                          ),
                                          child: imagenUrl == null
                                              ? const Icon(Icons.pets,
                                                  size: 50,
                                                  color: Colors.white70)
                                              : null,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          prod['nombre'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          prod['categoria'] ?? 'Sin categoría',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "\$${prod['precio'].toString()}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
