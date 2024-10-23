// Añade este método a tu clase DatabaseHelper
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:sqflite/sqflite.dart'; // Importamos el paquete de SQLite
import 'package:dulce_precision/database/dp_db.dart'; // Importamos el helper de la base de datos
import 'package:path/path.dart'; // Asegúrate de incluir este import

class MetodosRepository {
   // Función para borrar la base de datos
  Future<void> eliminarDatabase() async {
    // Obtiene la ruta de la base de datos
    String path = join(await getDatabasesPath(), 'dp_database.db');
    
    // Elimina la base de datos
    try {
      await deleteDatabase(path); // Método de sqflite para eliminar la base de datos
      CustomLogger().logInfo('Base de datos eliminada: $path');
    } catch (e) {
      CustomLogger().logError('Error al eliminar la base de datos: $e');
    }
  }

  // Método para obtener todo el contenido de una tabla
  Future<List<Map<String, dynamic>>> getTableContent(String tableName) async {
    try {
      final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos

      // Realizamos la consulta para obtener todo el contenido de la tabla
      List<Map<String, dynamic>> result = await db.query(tableName);

      // Log de éxito
      CustomLogger().logInfo('mostrando contenido de la tabla: $tableName');
      CustomLogger().logInfo(result.toString());

      return result;
    } catch (e) {
      // Log de error
      CustomLogger().logError('Error al recuperar el contenido de la tabla $tableName: $e');
      return [];
    }
  }
  // Método para listar todas las tablas de la base de datos
  Future<List<String>> listTables() async {
    try {
      final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos

      // Ejecutamos la consulta para obtener los nombres de las tablas
      List<Map<String, dynamic>> result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';"
      );

      // Mapeamos los resultados para obtener solo los nombres de las tablas
      List<String> tableNames = result.map((table) => table['name'] as String).toList();

      CustomLogger().logInfo('Lista de tablas existentes: $tableNames');
      return tableNames;
    } catch (e) {
      CustomLogger().logError('Error al listar las tablas: $e');
      return [];
    }
  }

  Future<void> deleteTable(String tableName) async {
    try {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
      await db.execute(
          'DROP TABLE IF EXISTS $tableName'); // Elimina la tabla si existe
      CustomLogger()
          .logInfo('Tabla $tableName eliminada correctamente'); // Log de éxito
    } catch (e) {
      CustomLogger().logError(
          'Error al eliminar la tabla $tableName: $e'); // Log de error
    }
  }

  Future<void> deleteAllTables() async {
  try {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos    
    // Lista de todas las tablas que has creado en tu base de datos
    List<String> tables = [
      'Productos',
      'recetas',
      'ingredientesRecetas',
      'gastosFijos',
      'ventas',
      'historialproducto',
      'historialGF',
      // Agrega aquí cualquier tabla adicional que tengas
    ];

    // Itera sobre cada tabla y la elimina
    for (String tableName in tables) {
      await db.execute('DROP TABLE IF EXISTS $tableName');
      CustomLogger().logInfo('Tabla $tableName eliminada correctamente');
    }
  } catch (e) {
    CustomLogger().logError('Error al eliminar las tablas: $e');
  }
}

/// Método para eliminar todo el contenido de una tabla específica
  Future<void> deleteTableContent(String tableName) async {
    // custom info para mostrar nombre tabla
    CustomLogger().logInfo('Eliminando contenido de la tabla: $tableName');

    try {
      final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos

      // Ejecutamos la consulta para eliminar todos los registros de la tabla especificada
      await db.delete(
        tableName, // Nombre de la tabla de la que queremos eliminar el contenido
      );

      // Log de éxito
      CustomLogger().logInfo('Contenido de la tabla $tableName eliminado correctamente');
    } catch (e) {
      // Log de error en caso de fallos
      CustomLogger().logError('Error al eliminar el contenido de la tabla $tableName: $e');
    }
  }

}
