import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CitasScreen extends StatefulWidget {
  final String token;
  const CitasScreen({super.key, required this.token});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  List<dynamic> citas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCitas();
  }

  Future<void> fetchCitas() async {
    final data = await ApiService.getCitas(widget.token);
    setState(() {
      citas = data;
      loading = false;
    });
  }

  Future<void> addOrEditCita({Map<String, dynamic>? cita}) async {
    final fechaController = TextEditingController(text: cita?['fecha'] ?? '');
    final motivoController = TextEditingController(text: cita?['motivo'] ?? '');
    List<dynamic> mascotas = await ApiService.getPets(widget.token);
    int? selectedMascotaId = cita?['id_mascota'];

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(cita == null ? "Nueva cita" : "Editar cita"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Selector de fecha
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: fechaController.text.isNotEmpty
                          ? DateTime.tryParse(fechaController.text) ??
                              DateTime.now()
                          : DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (date != null && time != null) {
                      final selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                      fechaController.text =
                          selectedDateTime.toString().substring(0, 19);
                      setStateDialog(() {});
                    }
                  },
                  child: const Text("Seleccionar Fecha y Hora"),
                ),
                const SizedBox(height: 8),
                Text(
                  fechaController.text.isEmpty
                      ? "No seleccionada"
                      : fechaController.text,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                // Selección de mascota
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: "Mascota"),
                  value: selectedMascotaId,
                  items: mascotas.map<DropdownMenuItem<int>>((m) {
                    return DropdownMenuItem<int>(
                      value: m['id'],
                      child: Text(m['nombre']),
                    );
                  }).toList(),
                  onChanged: (v) =>
                      setStateDialog(() => selectedMascotaId = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: motivoController,
                  decoration:
                      const InputDecoration(labelText: "Motivo de la cita"),
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
                if (fechaController.text.isEmpty || selectedMascotaId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Selecciona fecha y mascota válidas")),
                  );
                  return;
                }

                if (cita == null) {
                  // Crear nueva
                  await ApiService.createCita(
                    widget.token,
                    fechaController.text,
                    motivoController.text,
                    selectedMascotaId!,
                  );
                } else {
                  // Editar existente
                  await ApiService.updateCita(
                    widget.token,
                    cita['id'],
                    fechaController.text,
                    motivoController.text,
                  );
                }

                Navigator.pop(context);
                fetchCitas();
              },
              child: Text(cita == null ? "Guardar" : "Actualizar"),
            ),
          ],
        ),
      ),
    );
  }

  void deleteCita(int id) async {
    await ApiService.deleteCita(widget.token, id);
    fetchCitas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Citas")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addOrEditCita(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : citas.isEmpty
              ? const Center(child: Text("No tienes citas registradas"))
              : ListView.builder(
                  itemCount: citas.length,
                  itemBuilder: (_, i) {
                    final cita = citas[i];
                    return Card(
                      child: ListTile(
                        title: Text(cita['motivo']),
                        subtitle: Text(
                            "Mascota: ${cita['mascota']}\nFecha: ${cita['fecha']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => addOrEditCita(cita: cita),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteCita(cita['id']),
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
