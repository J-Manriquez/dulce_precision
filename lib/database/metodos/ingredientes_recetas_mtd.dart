import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger personalizado
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:dulce_precision/models/db_model.dart'; // Importamos el modelo IngredienteReceta

class IngredienteRecetaRepository {
  // Método para obtener todos los ingredientes de la tabla
  Future<List<IngredienteReceta>> getAllIngredientes() async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      // Obtenemos todos los registros de la tabla 'ingredientesRecetas'
      final List<Map<String, dynamic>> maps =
          await db.query('ingredientesRecetas');

      // Convertimos la lista de mapas a una lista de objetos IngredienteReceta
      return List.generate(maps.length, (i) {
        return IngredienteReceta.fromMap(
            maps[i]); // Creamos un objeto IngredienteReceta a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener todos los ingredientes: $e');
      throw Exception("Error al obtener todos los ingredientes");
    }
  }

  Future<void> eliminarIngredientesPorReceta(int idReceta) async {
    final db = await DatabaseHelper().database;
    try {
      await db.delete(
        'ingredientesRecetas',
        where: 'idReceta = ?',
        whereArgs: [idReceta],
      );
    } catch (e) {
      CustomLogger().logError(
          'Error al eliminar ingredientes de la receta con id $idReceta: $e');
      throw Exception("Error al eliminar ingredientes de la receta");
    }
  }

  // Método para obtener un ingrediente por su ID
  Future<IngredienteReceta> getIngredienteById(int idIngrediente) async {
    try {
      final db = await DatabaseHelper()
          .database; // Obtenemos la instancia de la base de datos
      final List<Map<String, dynamic>> maps = await db.query(
        'ingredientesRecetas', // Nombre de la tabla
        where: 'idIngrediente = ?', // Condición para buscar el ingrediente
        whereArgs: [idIngrediente], // Argumento para el ID del ingrediente
      );

      if (maps.isNotEmpty) {
        return IngredienteReceta.fromMap(
            maps.first); // Retorna el ingrediente si se encuentra
      } else {
        throw Exception('Ingrediente no encontrado'); // Manejo de errores
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger()
          .logError('Error al obtener ingrediente con id $idIngrediente: $e');
      throw Exception("Error al obtener producto");
    }
  }

  // Método para eliminar un ingrediente
  Future<void> eliminarIngrediente(int idIngrediente) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      await db.delete(
        'ingredientesRecetas', // Nombre de la tabla
        where: 'idIngrediente = ?', // Condición para buscar el ingrediente
        whereArgs: [idIngrediente], // Argumento para el ID del ingrediente
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger()
          .logError('Error al eliminar ingrediente con id $idIngrediente: $e');
      throw Exception("Error al eliminar ingrediente");
    }
  }

  // Método para actualizar un ingrediente en la base de datos
  Future<int> actualizarIngrediente(IngredienteReceta ingrediente) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      return await db.update(
        'ingredientesRecetas', // Nombre de la tabla
        ingrediente.toMap(), // Convierte el ingrediente a un mapa
        where: 'idIngrediente = ?', // Condición para actualizar el ingrediente
        whereArgs: [
          ingrediente.idIngrediente
        ], // ID del ingrediente a actualizar
      );
    } catch (e) {
      // Si ocurre un error, ls y lanzamos una excepción
      CustomLogger().logError(
          'Error al actualizar ingrediente con id ${ingrediente.idIngrediente}: $e');
      throw Exception("Error al actualizar ingrediente");
    }
  }

  // Método para obtener todos los ingredientes de una receta específica
  Future<List<IngredienteReceta>> getAllIngredientesPorReceta(
      int idReceta) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'ingredientesRecetas', // Nombre de la tabla
        where: 'idReceta = ?', // Condición para buscar por idReceta
        whereArgs: [idReceta], // Argumento para el ID de la receta
      );

      // Convertimos la lista de mapas a una lista de ingredientes
      return List.generate(maps.length, (i) {
        return IngredienteReceta.fromMap(
            maps[i]); // Creamos un objeto IngredienteReceta a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError(
          'Error al obtener todos los ingredientes para la receta con id $idReceta: $e');
      throw Exception("Error al obtener todos los ingredientes");
    }
  }

  // Método para insertar un nuevo ingrediente en la base de datos
  Future<void> insertarIngredientes(
      List<IngredienteReceta> ingredientes, int idReceta) async {
    // Obtenemos la instancia de la base de datos
    final db = await DatabaseHelper().database;

    // Log para mostrar el inicio de la inserción de ingredientes
    CustomLogger().logInfo(
        'Iniciando inserción de ingredientes para la receta con id: $idReceta');
    CustomLogger()
        .logInfo('Ingredientes a insertar: ${ingredientes.toString()}');

    try {
      // Primero, verificamos si el idReceta existe en la tabla recetas
      final existsQuery = await db.query(
        'recetas',
        where: 'idReceta = ?',
        whereArgs: [idReceta],
      );

      // Log del resultado de la consulta
      CustomLogger()
          .logInfo('Resultado de la consulta de recetas: $existsQuery');

      if (existsQuery.isEmpty) {
        throw Exception('La receta con id $idReceta no existe');
      }

      // Si la receta existe, procedemos a insertar cada ingrediente
      for (var ingrediente in ingredientes) {
        // Asignamos el idReceta al ingrediente antes de insertarlo
        ingrediente.idReceta =
            idReceta; // Asegúrate de que 'idReceta' es una propiedad de 'IngredienteReceta'

        // Log para mostrar el ingrediente que se va a insertar
        CustomLogger()
            .logInfo('Insertando ingrediente: ${ingrediente.toMap()}');

        await db.insert(
          'ingredientesRecetas',
          ingrediente.toMap(), // Convertimos el ingrediente a un mapa
          conflictAlgorithm: ConflictAlgorithm.ignore, // Manejo de conflictos
        );

        // Log de éxito tras la inserción del ingrediente
        CustomLogger().logInfo(
            'Ingrediente insertado: ${ingrediente.nombreIngrediente} para la receta id: $idReceta');
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al insertar ingredientes: $e');
      rethrow; // Re-lanzamos la excepción para que pueda ser manejada por el llamador
    }
  }
}
