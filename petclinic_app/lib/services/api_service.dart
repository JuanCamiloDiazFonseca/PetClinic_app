import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';


class ApiService {
  static const String baseUrl = "http://192.168.100.81:3000/api";

  // 🔐 Registro
  static Future<Map<String, dynamic>> register(
      String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body:
          jsonEncode({"nombre": nombre, "email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  // 🔐 Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return jsonDecode(response.body);
  }

  // 🐾 Obtener mascotas
  static Future<List<dynamic>> getPets(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/pets"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // 🐾 Crear mascota
  static Future<Map<String, dynamic>> createPet(
  String token,
  String nombre,
  String especie,
  String raza,
  int edad, {
  File? imagen, 
}) async {
  if (imagen == null) {
    final response = await http.post(
      Uri.parse("$baseUrl/pets"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "nombre": nombre,
        "especie": especie,
        "raza": raza,
        "edad": edad,
      }),
    );
    return jsonDecode(response.body);
  }

  var uri = Uri.parse("$baseUrl/pets");
  var request = http.MultipartRequest('POST', uri);
  request.headers['Authorization'] = "Bearer $token";

  request.fields['nombre'] = nombre;
  request.fields['especie'] = especie;
  request.fields['raza'] = raza;
  request.fields['edad'] = edad.toString();

  request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

  final streamed = await request.send();
  final respStr = await streamed.stream.bytesToString();
  return jsonDecode(respStr);
}
  
  static Future<Map<String, dynamic>> updatePet(
  String token,
  int id,
  String nombre,
  String especie,
  String raza,
  int edad, {
  File? imagen, 
}) async {
  if (imagen == null) {
    final response = await http.put(
      Uri.parse("$baseUrl/pets/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "nombre": nombre,
        "especie": especie,
        "raza": raza,
        "edad": edad,
      }),
    );
    return jsonDecode(response.body);
  }

  var uri = Uri.parse("$baseUrl/pets/$id");
  var request = http.MultipartRequest('PUT', uri);
  request.headers['Authorization'] = "Bearer $token";

  request.fields['nombre'] = nombre;
  request.fields['especie'] = especie;
  request.fields['raza'] = raza;
  request.fields['edad'] = edad.toString();

  request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));

  final streamed = await request.send();
  final respStr = await streamed.stream.bytesToString();
  return jsonDecode(respStr);
}

  // Eliminar mascota
  static Future<Map<String, dynamic>> deletePet(String token, int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/pets/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // Obtener citas
  static Future<List<dynamic>> getCitas(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/citas"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // Crear cita
  static Future<Map<String, dynamic>> createCita(
      String token, String fecha, String motivo, int idMascota) async {
    final response = await http.post(
      Uri.parse("$baseUrl/citas"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "fecha": fecha,
        "motivo": motivo,
        "id_mascota": idMascota,
      }),
    );
    return jsonDecode(response.body);
  }

  // Eliminar cita
  static Future<Map<String, dynamic>> deleteCita(
      String token, int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/citas/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // Actualizar cita
  static Future<Map<String, dynamic>> updateCita(
      String token, int id, String fecha, String motivo) async {
    final response = await http.put(
      Uri.parse("$baseUrl/citas/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "fecha": fecha,
        "motivo": motivo,
        "estado": "pendiente", // 👈 puedes ajustar el estado si lo manejas en backend
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al actualizar cita: ${response.body}");
    }
  }


  // Categorías

  // Obtener categorías
  static Future<List<dynamic>> getCategorias(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/categorias"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener categorías");
    }
  }

  //  Crear categoría
  static Future<Map<String, dynamic>> createCategoria(
      String token, String nombre, String descripcion) async {
    final response = await http.post(
      Uri.parse("$baseUrl/categorias"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "nombre": nombre,
        "descripcion": descripcion,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al crear categoría");
    }
  }

  //  Actualizar categoría
  static Future<Map<String, dynamic>> updateCategoria(
      String token, int id, String nombre, String descripcion) async {
    final response = await http.put(
      Uri.parse("$baseUrl/categorias/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"nombre": nombre, "descripcion": descripcion}),
    );
    return jsonDecode(response.body);
  }

  // Eliminar categoría
  static Future<Map<String, dynamic>> deleteCategoria(
      String token, int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/categorias/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al eliminar categoría");
    }
  }

  // Productos
  static Future<List<dynamic>> getProductos(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/productos"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // Crear producto (con imagen opcional)
  static Future<Map<String, dynamic>> createProducto(
    String token,
    String nombre,
    String descripcion,
    double precio,
    int stock,
    String tipoAnimal,
    int idCategoria, {
    File? imagen, 
  }) async {
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl/productos"));
    request.headers['Authorization'] = "Bearer $token";
    request.fields.addAll({
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio.toString(),
      "stock": stock.toString(),
      "tipo_animal": tipoAnimal,
      "id_categoria": idCategoria.toString(),
    });
    if (imagen != null) {
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  //  Actualizar producto (con imagen opcional)
  static Future<Map<String, dynamic>> updateProducto(
    String token,
    int id,
    String nombre,
    String descripcion,
    double precio,
    int stock,
    String tipoAnimal,
    int idCategoria, {
    File? imagen, 
  }) async {
    var request =
        http.MultipartRequest('PUT', Uri.parse("$baseUrl/productos/$id"));
    request.headers['Authorization'] = "Bearer $token";
    request.fields.addAll({
      "nombre": nombre,
      "descripcion": descripcion,
      "precio": precio.toString(),
      "stock": stock.toString(),
      "tipo_animal": tipoAnimal,
      "id_categoria": idCategoria.toString(),
    });
    if (imagen != null) {
      request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return jsonDecode(respStr);
  }

  // Eliminar producto
  static Future<Map<String, dynamic>> deleteProducto(String token, int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/productos/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  // Obtener perfil del usuario
  static Future<Map<String, dynamic>> getPerfil(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/me"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener perfil: ${response.body}");
    }
  }


}
