import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'categoria_form_screen.dart';

class CategoriasScreen extends StatefulWidget {
  final String token;
  const CategoriasScreen({super.key, required this.token});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List<dynamic> categorias = [];
  bool loading = true;
  String search = "";

  @override
  void initState() {
    super.initState();
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    final data = await ApiService.getCategorias(widget.token);
    setState(() {
      categorias = data;
      loading = false;
    });
  }

  void deleteCategoria(int id) async {
    await ApiService.deleteCategoria(widget.token, id);
    fetchCategorias();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = categorias
        .where((c) => c['nombre'].toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoriaFormScreen(token: widget.token),
            ),
          );
          if (updated == true) fetchCategorias();
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
                      hintText: "Buscar categorías",
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
                        ? const Center(child: Text("No hay categorías"))
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final cat = filtered[i];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(cat['nombre'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(cat['descripcion'] ?? ''),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final updated = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CategoriaFormScreen(
                                                token: widget.token,
                                                categoria: cat,
                                              ),
                                            ),
                                          );
                                          if (updated == true) fetchCategorias();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => deleteCategoria(cat['id']),
                                      ),
                                    ],
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
