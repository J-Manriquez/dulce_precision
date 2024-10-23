import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:dulce_precision/models/db_model.dart'; // Importamos el modelo Receta

class RecetaRepository {
  // Método para obtener una receta por su ID
  Future<Receta?> obtenerRecetaPorId(int idReceta) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'recetas', // Nombre de la tabla
        where: 'idReceta = ?', // Condición para buscar por idReceta
        whereArgs: [idReceta], // Argumento para el ID de la receta
      );

      // Verificamos si se encontró alguna receta
      if (maps.isNotEmpty) {
        return Receta.fromMap(
            maps.first); // Convertimos el primer mapa a un objeto Receta
      } else {
        return null; // Si no se encuentra la receta, devolvemos null
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener receta con id $idReceta: $e');
      throw Exception("Error al obtener receta");
    }
  }

  // Método para eliminar una receta
  Future<void> eliminarReceta(int idReceta) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      await db.delete(
        'recetas', // Nombre de la tabla
        where: 'idReceta = ?', // Condición para buscar la receta
        whereArgs: [idReceta], // Argumento para el ID de la receta
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al eliminar receta con id $idReceta: $e');
      throw Exception("Error al eliminar receta");
    }
  }

  // Método para actualizar una receta en la base de datos
  Future<int> actualizarReceta(Receta receta) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      return await db.update(
        'recetas', // Nombre de la tabla
        receta.toMap(), // Convierte la receta a un mapa
        where: 'idReceta = ?', // Condición para actualizar la receta
        whereArgs: [receta.idReceta], // ID de la receta a actualizar
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger()
          .logError('Error al actualizar receta con id ${receta.idReceta}: $e');
      throw Exception("Error al actualizar receta");
    }
  }

  // Método para obtener todas las recetas de la base de datos
  Future<List<Receta>> getAllRecetas() async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('recetas'); // Realizamos la consulta

      // Convertimos la lista de mapas a una lista de recetas
      return List.generate(maps.length, (i) {
        return Receta.fromMap(
            maps[i]); // Creamos un objeto Receta a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener todas las recetas: $e');
      throw Exception("Error al obtener todas las recetas");
    }
  }

  // Método para insertar una nueva receta en la base de datos
  Future<int> insertReceta(Receta receta) async {
    print('INSERTANDO RECETA');
    // Obtenemos la instancia de la base de datos
    final db = await DatabaseHelper().database;

    try {
      // Insertamos la receta en la tabla 'recetas'
      return await db.insert(
        'recetas', // Nombre de la tabla
        receta
            .toMap(), // Convertimos la receta a un mapa usando el método toMap()
        conflictAlgorithm: ConflictAlgorithm
            .ignore, // Si existe un conflicto (ej. id duplicado), reemplazamos el registro
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al insertar receta: $e');
      throw Exception("Error al insertar receta");
    }
  }
}
