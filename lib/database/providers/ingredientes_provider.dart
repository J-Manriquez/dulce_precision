import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger personalizado
import 'package:flutter/material.dart'; // Importamos Flutter Material
import 'package:dulce_precision/models/db_model.dart'; // Importamos el modelo IngredienteReceta

class IngredientesRecetasProvider with ChangeNotifier {
  List<IngredienteReceta> _ingredientes = []; // Lista privada de ingredientes
  final IngredienteRecetaRepository _ingredienteRepository = IngredienteRecetaRepository(); // Instancia del repositorio

  List<IngredienteReceta> get ingredientes => _ingredientes; // Getter para la lista de ingredientes

  // Método para obtener ingredientes desde la base de datos
  Future<void> obtenerIngredientesPorReceta(int idReceta) async {
    try {
      _ingredientes = await _ingredienteRepository.getAllIngredientesPorReceta(idReceta); // Obtiene ingredientes del repositorio
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al obtener ingredientes: $e');
      // Aquí puedes manejar los errores, como mostrar un mensaje al usuario.
      throw Exception("Error al obtener ingredientes"); // Lanzamos una excepción para manejo externo
    }
  }
  
// Método para obtener recetas desde la base de datos
  Future<void> obtenerIngredientes() async {
    try {
      _ingredientes = await _ingredienteRepository
          .getAllIngredientes(); // Obtiene recetas del repositorio
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al obtener recetas: $e');
      // Aquí puedes manejar los errores, como mostrar un mensaje al usuario.
      throw Exception(
          "Error al obtener recetas"); // Lanzamos una excepción para manejo externo
    }
  }



  // Método para agregar un ingrediente
  Future<void> agregarIngrediente(IngredienteReceta ingrediente) async {
    try {
      // Creamos una lista con el ingrediente que queremos agregar
      List<IngredienteReceta> ingredientesLista = [ingrediente];

      // Llamamos a insertarIngredientes, pasando la lista y el idReceta
      await _ingredienteRepository.insertarIngredientes(ingredientesLista, ingrediente.idReceta);
      
      // Actualiza la lista después de insertar
      await obtenerIngredientesPorReceta(ingrediente.idReceta); 
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al agregar ingrediente: $e');
      throw Exception("Error al agregar ingrediente"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar un ingrediente
  Future<void> eliminarIngrediente(int idIngrediente) async {
    try {
      // Primero obtenemos el ingrediente antes de eliminarlo para obtener su idReceta
      final ingrediente = await _ingredienteRepository.getIngredienteById(idIngrediente);
      
      await _ingredienteRepository.eliminarIngrediente(idIngrediente); // Elimina ingrediente
      await obtenerIngredientesPorReceta(ingrediente.idReceta); // Actualiza la lista después de eliminar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al eliminar ingrediente con id $idIngrediente: $e');
      throw Exception("Error al eliminar ingrediente"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para actualizar un ingrediente
  Future<void> actualizarIngrediente(IngredienteReceta ingrediente) async {
    try {
      await _ingredienteRepository.actualizarIngrediente(ingrediente); // Actualiza ingrediente
      await obtenerIngredientesPorReceta(ingrediente.idReceta); // Actualiza la lista después de actualizar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al actualizar ingrediente con id ${ingrediente.idIngrediente}: $e');
      throw Exception("Error al actualizar ingrediente"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar ingredientes por receta
  Future<void> eliminarIngredientesPorReceta(int idReceta) async {
    try {
      await _ingredienteRepository.eliminarIngredientesPorReceta(idReceta); // Elimina todos los ingredientes de una receta
      await obtenerIngredientesPorReceta(idReceta); // Actualiza la lista de ingredientes
    } catch (e) {
      CustomLogger().logError('Error al eliminar ingredientes por receta: $e');
      throw Exception("Error al eliminar ingredientes por receta");
    }
  }

  // Método para obtener un ingrediente por su ID
  Future<IngredienteReceta> obtenerIngredientePorId(int idIngrediente) async {
    try {
      return await _ingredienteRepository.getIngredienteById(idIngrediente); // Obtiene un ingrediente específico
    } catch (e) {
      CustomLogger().logError('Error al obtener ingrediente por ID: $e');
      throw Exception("Error al obtener ingrediente por ID");
    }
  }
}
