import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ProductoFormScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? producto;
  const ProductoFormScreen({super.key, required this.token, this.producto});

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> categorias = [];
  String? categoriaSeleccionada;
  String tipoAnimal = "Perros";
  File? imagenFile; 

  late TextEditingController nombreController;
  late TextEditingController descripcionController;
  late TextEditingController precioController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    nombreController =
        TextEditingController(text: widget.producto?['nombre'] ?? '');
    descripcionController =
        TextEditingController(text: widget.producto?['descripcion'] ?? '');
    precioController = TextEditingController(
        text: widget.producto?['precio']?.toString() ?? '');
    stockController = TextEditingController(
        text: widget.producto?['stock']?.toString() ?? '');
    tipoAnimal = widget.producto?['tipo_animal'] ?? 'Perros';
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    final data = await ApiService.getCategorias(widget.token);
    setState(() {
      categorias = data;
      categoriaSeleccionada =
          widget.producto?['id_categoria']?.toString() ??
              (categorias.isNotEmpty ? categorias.first['id'].toString() : null);
    });
  }

  Future<void> seleccionarImagen() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imagenFile = File(picked.path));
    }
  }

  void guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final nombre = nombreController.text;
    final descripcion = descripcionController.text;
    final precio = double.tryParse(precioController.text) ?? 0.0;
    final stock = int.tryParse(stockController.text) ?? 0;
    final idCategoria = int.tryParse(categoriaSeleccionada ?? "0") ?? 0;

    if (widget.producto == null) {
      await ApiService.createProducto(
        widget.token,
        nombre,
        descripcion,
        precio,
        stock,
        tipoAnimal,
        idCategoria,
        imagen: imagenFile,
      );
    } else {
      await ApiService.updateProducto(
        widget.token,
        widget.producto!['id'],
        nombre,
        descripcion,
        precio,
        stock,
        tipoAnimal,
        idCategoria,
        imagen: imagenFile,
      );
    }

    if (context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.producto != null;

    final String? imagenExistente = widget.producto?['imagen'] != null
        ? "http://192.168.100.81:3000/uploads/${widget.producto!['imagen']}" 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Producto" : "Nuevo Producto"),
      ),
      body: categorias.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: "Nombre"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Ingrese el nombre" : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: categoriaSeleccionada,
                      decoration:
                          const InputDecoration(labelText: "Categoría"),
                      items: categorias
                          .map((c) => DropdownMenuItem<String>(
                                value: c['id'].toString(),
                                child: Text(c['nombre']),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() {
                        categoriaSeleccionada = v;
                      }),
                    ),
                    const SizedBox(height: 12),
                    const Text("Tipo de Animal"),
                    Row(
                      children: [
                        for (final tipo in ["Perros", "Gatos", "Aves"])
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(tipo),
                              value: tipo,
                              groupValue: tipoAnimal,
                              onChanged: (v) =>
                                  setState(() => tipoAnimal = v ?? "Perros"),
                            ),
                          ),
                      ],
                    ),
                    TextFormField(
                      controller: descripcionController,
                      decoration:
                          const InputDecoration(labelText: "Descripción"),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: precioController,
                            decoration:
                                const InputDecoration(labelText: "Precio"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: stockController,
                            decoration:
                                const InputDecoration(labelText: "Stock"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text("Imagen del Producto",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700])),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: seleccionarImagen,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          image: imagenFile != null
                              ? DecorationImage(
                                  image: FileImage(imagenFile!),
                                  fit: BoxFit.cover)
                              : (imagenExistente != null
                                  ? DecorationImage(
                                      image: NetworkImage(imagenExistente),
                                      fit: BoxFit.cover)
                                  : null),
                        ),
                        child: imagenFile == null && imagenExistente == null
                            ? const Center(
                                child: Text("Toca para seleccionar una imagen"))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancelar"),
                        ),
                        ElevatedButton(
                          onPressed: guardar,
                          child: const Text("Guardar"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
