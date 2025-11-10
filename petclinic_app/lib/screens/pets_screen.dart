import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PetsScreen extends StatefulWidget {
  final String token;
  const PetsScreen({super.key, required this.token});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  List<dynamic> pets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    final data = await ApiService.getPets(widget.token);
    setState(() {
      pets = data;
      loading = false;
    });
  }

  // Crear nueva mascota
  void addPet() async {
    final nameController = TextEditingController();
    final especieController = TextEditingController();
    final razaController = TextEditingController();
    final edadController = TextEditingController();
    File? imagen;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Nueva mascota"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setStateDialog(() => imagen = File(picked.path));
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: imagen != null ? FileImage(imagen!) : null,
                      child: imagen == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                  ),
                  TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: "Nombre")),
                  TextField(
                      controller: especieController,
                      decoration:
                          const InputDecoration(labelText: "Especie")),
                  TextField(
                      controller: razaController,
                      decoration:
                          const InputDecoration(labelText: "Raza")),
                  TextField(
                    controller: edadController,
                    decoration:
                        const InputDecoration(labelText: "Edad"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  await ApiService.createPet(
                    widget.token,
                    nameController.text,
                    especieController.text,
                    razaController.text,
                    int.tryParse(edadController.text) ?? 0,
                    imagen: imagen,
                  );
                  Navigator.pop(context);
                  fetchPets();
                },
                child: const Text("Guardar"),
              ),
            ],
          );
        },
      ),
    );
  }

  // Editar mascota existente
  void editPet(dynamic pet) async {
    final nameController = TextEditingController(text: pet['nombre']);
    final especieController = TextEditingController(text: pet['especie']);
    final razaController = TextEditingController(text: pet['raza']);
    final edadController = TextEditingController(text: pet['edad'].toString());
    File? imagen;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Editar mascota"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setStateDialog(() => imagen = File(picked.path));
                      }
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: imagen != null
                          ? FileImage(imagen!)
                          : (pet['imagen'] != null
                              ? NetworkImage(
                                  "http://192.168.100.81${pet['imagen']}")
                              : null) as ImageProvider?,
                      child: imagen == null && pet['imagen'] == null
                          ? const Icon(Icons.add_a_photo, size: 30)
                          : null,
                    ),
                  ),
                  TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: "Nombre")),
                  TextField(
                      controller: especieController,
                      decoration:
                          const InputDecoration(labelText: "Especie")),
                  TextField(
                      controller: razaController,
                      decoration:
                          const InputDecoration(labelText: "Raza")),
                  TextField(
                    controller: edadController,
                    decoration:
                        const InputDecoration(labelText: "Edad"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")),
              ElevatedButton(
                onPressed: () async {
                  await ApiService.updatePet(
                    widget.token,
                    pet['id'],
                    nameController.text,
                    especieController.text,
                    razaController.text,
                    int.tryParse(edadController.text) ?? 0,
                    imagen: imagen,
                  );
                  Navigator.pop(context);
                  fetchPets();
                },
                child: const Text("Guardar cambios"),
              ),
            ],
          );
        },
      ),
    );
  }

  // Eliminar mascota
  void deletePet(int id) async {
    await ApiService.deletePet(widget.token, id);
    fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Mascotas")),
      floatingActionButton: FloatingActionButton(
        onPressed: addPet,
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
              ? const Center(child: Text("No tienes mascotas registradas"))
              : ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (_, i) {
                    final pet = pets[i];
                    return Card(
                      child: ListTile(
                        leading: pet['imagen'] != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "http://192.168.100.81${pet['imagen']}"),
                              )
                            : const CircleAvatar(child: Icon(Icons.pets)),
                        title: Text(pet['nombre']),
                        subtitle: Text(
                            "${pet['especie']} - ${pet['raza']} (${pet['edad']} años)"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => editPet(pet),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deletePet(pet['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
