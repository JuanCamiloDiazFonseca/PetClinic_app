import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CategoriaFormScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? categoria;
  const CategoriaFormScreen({super.key, required this.token, this.categoria});

  @override
  State<CategoriaFormScreen> createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nombreController =
        TextEditingController(text: widget.categoria?['nombre'] ?? '');
    descController =
        TextEditingController(text: widget.categoria?['descripcion'] ?? '');
  }

  void guardar() async {
    if (_formKey.currentState!.validate()) {
      if (widget.categoria == null) {
        await ApiService.createCategoria(
            widget.token, nombreController.text, descController.text);
      } else {
        await ApiService.updateCategoria(widget.token,
            widget.categoria!['id'], nombreController.text, descController.text);
      }
      if (context.mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.categoria != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Categoría" : "Nueva Categoría"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese el nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Descripción"),
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
                    child: Text(isEditing ? "Actualizar" : "Guardar"),
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
