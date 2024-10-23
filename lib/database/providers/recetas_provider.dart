import 'package:dulce_precision/database/metodos/metodos_db_dp.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/models/db_model.dart'; // Modelo Receta
import 'package:dulce_precision/database/metodos/recetas_metodos.dart'; // Repositorio de recetas

class RecetasProvider with ChangeNotifier {
  final RecetaRepository _recetaRepository =
      RecetaRepository(); // Instancia del repositorio
  final MetodosRepository _metodosRepository =
      MetodosRepository(); // Instancia del repositorio

  Receta? _receta; // Variable para almacenar la receta

  // Método para obtener una receta por ID
  Future<void> obtenerRecetaPorId(int idReceta) async {
    try {
      _receta = await _recetaRepository.obtenerRecetaPorId(idReceta);
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Manejo de errores
      CustomLogger().logError('Error al obtener receta por ID: $e');
      throw Exception("Error al obtener receta por ID");
    }
  }

  Receta? get receta => _receta; // Getter para acceder a la receta

  List<Receta> _recetas = []; // Lista privada de recetas
  List<Receta> get recetas => _recetas; // Getter para la lista de recetas

  // Método para obtener recetas desde la base de datos
  Future<void> obtenerRecetas() async {
    try {
      _recetas = await _recetaRepository
          .getAllRecetas(); // Obtiene recetas del repositorio
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al obtener recetas: $e');
      // Aquí puedes manejar los errores, como mostrar un mensaje al usuario.
      throw Exception(
          "Error al obtener recetas"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para agregar una receta
  Future<void> agregarReceta(Receta receta) async {
    try {
      await _recetaRepository.insertReceta(receta); // Inserta receta
      await obtenerRecetas(); // Actualiza la lista después de insertar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al agregar receta: $e');
      throw Exception(
          "Error al agregar receta"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar una receta
  Future<void> eliminarReceta(int idReceta) async {
    try {
      await _recetaRepository.eliminarReceta(idReceta); // Elimina receta
      await obtenerRecetas(); // Actualiza la lista después de eliminar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al eliminar receta con id $idReceta: $e');
      throw Exception(
          "Error al eliminar receta"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar todo el contenido de la tabla de recetas
  Future<void> eliminarContenidoTablaRecetas() async {
    try {
      await _metodosRepository.deleteTableContent(
          'recetas'); // Elimina el contenido de la tabla 'recetas'
      await obtenerRecetas(); // Actualiza la lista después de eliminar
      notifyListeners(); // Notifica a los listeners
    } catch (e) {
      CustomLogger()
          .logError('Error al eliminar contenido de la tabla recetas: $e');
      throw Exception(
          "Error al eliminar contenido de la tabla recetas"); // Lanzamos una excepción para manejo externo
    }
  }
}
