import 'package:dulce_precision/models/db_model.dart';
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger para el manejo de errores

class VentaRepository {
  // Método para insertar una nueva venta en la base de datos
  Future<int> insertarVenta(Venta venta) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      // Insertamos la venta en la tabla 'ventas'
      return await db.insert(
        'ventas', // Nombre de la tabla
        venta.toMap(), // Convertimos la venta a un mapa usando el método toMap()
        conflictAlgorithm: ConflictAlgorithm.ignore, // Si existe un conflicto, lo ignoramos
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al insertar venta: $e');
      throw Exception("Error al insertar venta");
    }
  }

  // Método para obtener una venta por su ID
  Future<Venta> getVentaById(int idVenta) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      // Realizamos una consulta para obtener la venta por su ID
      final List<Map<String, dynamic>> maps = await db.query(
        'ventas', // Nombre de la tabla
        where: 'idVenta = ?', // Condición para buscar la venta
        whereArgs: [idVenta], // Argumento para el ID de la venta
      );

      if (maps.isNotEmpty) {
        // Si se encuentra la venta, la convertimos a un objeto Venta
        return Venta.fromMap(maps.first);
      } else {
        throw Exception('Venta no encontrada'); // Manejo de errores si no se encuentra la venta
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener venta con id $idVenta: $e');
      throw Exception("Error al obtener venta");
    }
  }

  // Método para actualizar una venta en la base de datos
  Future<int> actualizarVenta(Venta venta) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      return await db.update(
        'ventas', // Nombre de la tabla
        venta.toMap(), // Convierte la venta a un mapa
        where: 'idVenta = ?', // Condición para actualizar la venta
        whereArgs: [venta.idVenta], // ID de la venta a actualizar
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError(
          'Error al actualizar venta con id ${venta.idVenta}: $e');
      throw Exception("Error al actualizar venta");
    }
  }

  // Método para eliminar una venta
  Future<void> eliminarVenta(int idVenta) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      await db.delete(
        'ventas', // Nombre de la tabla
        where: 'idVenta = ?', // Condición para buscar la venta
        whereArgs: [idVenta], // Argumento para el ID de la venta
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al eliminar venta con id $idVenta: $e');
      throw Exception("Error al eliminar venta");
    }
  }

  // Método para obtener todas las ventas de la base de datos
  Future<List<Venta>> getAllVentas() async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps = await db.query('ventas'); // Realizamos la consulta

      // Convertimos la lista de mapas a una lista de objetos Venta
      return List.generate(maps.length, (i) {
        return Venta.fromMap(maps[i]); // Creamos un objeto Venta a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener todas las ventas: $e');
      throw Exception("Error al obtener todas las ventas");
    }
  }
}
