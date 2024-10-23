import 'package:dulce_precision/models/db_model.dart';
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger para el manejo de errores

class GastoFijoRepository {
  // Método para obtener un gasto fijo por su ID
  Future<GastoFijo> getGastoFijoById(int idGF) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      // Realizamos una consulta para obtener el gasto fijo por su ID
      final List<Map<String, dynamic>> maps = await db.query(
        'gastosFijos', // Nombre de la tabla
        where: 'idGF = ?', // Condición para buscar el gasto fijo
        whereArgs: [idGF], // Argumento para el ID del gasto fijo
      );

      if (maps.isNotEmpty) {
        // Si se encuentra el gasto fijo, lo convertimos a un objeto GastoFijo
        return GastoFijo.fromMap(maps.first);
      } else {
        throw Exception('Gasto fijo no encontrado'); // Manejo de errores si no se encuentra el gasto fijo
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener gasto fijo con id $idGF: $e');
      throw Exception("Error al obtener gasto fijo");
    }
  }

  // Método para eliminar un gasto fijo
  Future<void> eliminarGastoFijo(int idGF) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      await db.delete(
        'gastosFijos', // Nombre de la tabla
        where: 'idGF = ?', // Condición para buscar el gasto fijo
        whereArgs: [idGF], // Argumento para el ID del gasto fijo
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al eliminar gasto fijo con id $idGF: $e');
      throw Exception("Error al eliminar gasto fijo");
    }
  }

  // Método para actualizar un gasto fijo en la base de datos
  Future<int> actualizarGastoFijo(GastoFijo gastoFijo) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      return await db.update(
        'gastosFijos', // Nombre de la tabla
        gastoFijo.toMap(), // Convierte el gasto fijo a un mapa
        where: 'idGF = ?', // Condición para actualizar el gasto fijo
        whereArgs: [gastoFijo.idGF], // ID del gasto fijo a actualizar
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError(
          'Error al actualizar gasto fijo con id ${gastoFijo.idGF}: $e');
      throw Exception("Error al actualizar gasto fijo");
    }
  }

  // Método para obtener todos los gastos fijos de la base de datos
  Future<List<GastoFijo>> getAllGastosFijos() async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('gastosFijos'); // Realizamos la consulta

      // Convertimos la lista de mapas a una lista de objetos GastoFijo
      return List.generate(maps.length, (i) {
        return GastoFijo.fromMap(maps[i]); // Creamos un objeto GastoFijo a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener todos los gastos fijos: $e');
      throw Exception("Error al obtener todos los gastos fijos");
    }
  }

  // Método para insertar un nuevo gasto fijo en la base de datos
  Future<int> insertGastoFijo(GastoFijo gastoFijo) async {
    // Obtenemos la instancia de la base de datos
    final db = await DatabaseHelper().database;

    try {
      // Insertamos el gasto fijo en la tabla 'gastosFijos'
      return await db.insert(
        'gastosFijos', // Nombre de la tabla
        gastoFijo.toMap(), // Convertimos el gasto fijo a un mapa usando el método toMap()
        conflictAlgorithm: ConflictAlgorithm.ignore, // Si existe un conflicto, lo ignoramos
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al insertar gasto fijo: $e');
      throw Exception("Error al insertar gasto fijo");
    }
  }
}
