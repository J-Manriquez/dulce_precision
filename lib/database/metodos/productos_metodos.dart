import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:dulce_precision/models/db_model.dart'; // Importamos el modelo Producto

class ProductRepository {
  // Método para obtener un producto por su ID
  Future<Producto> getProductoById(int idProducto) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      // Realizamos una consulta para obtener el producto por su ID
      final List<Map<String, dynamic>> maps = await db.query(
        'productos', // Nombre de la tabla
        where: 'idProducto = ?', // Condición para buscar el producto
        whereArgs: [idProducto], // Argumento para el ID del producto
      );

      if (maps.isNotEmpty) {
        // Si se encuentra el producto, lo convertimos a un objeto Producto
        return Producto.fromMap(maps.first);
      } else {
        throw Exception(
            'Producto no encontrado'); // Manejo de errores si no se encuentra el producto
      }
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger()
          .logError('Error al obtener producto con id $idProducto: $e');
      throw Exception("Error al obtener producto");
    }
  }

  // Método para eliminar un producto
  Future<void> eliminarProducto(int idProducto) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      await db.delete(
        'productos', // Nombre de la tabla
        where: 'idProducto = ?', // Condición para buscar el producto
        whereArgs: [idProducto], // Argumento para el ID del producto
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger()
          .logError('Error al eliminar producto con id $idProducto: $e');
      throw Exception("Error al eliminar producto");
    }
  }

  // Método para actualizar un producto en la base de datos
  Future<int> actualizarProducto(Producto producto) async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      return await db.update(
        'productos', // Nombre de la tabla
        producto.toMap(), // Convierte el producto a un mapa
        where: 'idProducto = ?', // Condición para actualizar el producto
        whereArgs: [producto.idProducto], // ID del producto a actualizar
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError(
          'Error al actualizar producto con id ${producto.idProducto}: $e');
      throw Exception("Error al actualizar producto");
    }
  }

  // Método para obtener todos los productos de la base de datos
  Future<List<Producto>> getAllProductos() async {
    final db = await DatabaseHelper()
        .database; // Obtenemos la instancia de la base de datos
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('Productos'); // Realizamos la consulta

      // Convertimos la lista de mapas a una lista de productos
      return List.generate(maps.length, (i) {
        return Producto.fromMap(
            maps[i]); // Creamos un objeto Producto a partir del mapa
      });
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al obtener todos los productos: $e');
      throw Exception("Error al obtener todos los productos");
    }
  }

  // Método para insertar un nuevo producto en la base de datos
  Future<int> insertProducto(Producto producto) async {
    // Obtenemos la instancia de la base de datos
    final db = await DatabaseHelper().database;

    try {
      // Insertamos el producto en la tabla 'Productos'
      return await db.insert(
        'Productos', // Nombre de la tabla
        producto
            .toMap(), // Convertimos el producto a un mapa usando el método toMap()
        conflictAlgorithm: ConflictAlgorithm
            .ignore, // Si existe un conflicto (ej. id duplicado), reemplazamos el registro
      );
    } catch (e) {
      // Si ocurre un error, lo registramos y lanzamos una excepción
      CustomLogger().logError('Error al insertar producto: $e');
      throw Exception("Error al insertar producto");
    }
  }
}
