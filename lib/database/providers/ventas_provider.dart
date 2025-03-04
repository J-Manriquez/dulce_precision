import 'package:dulce_precision/database/dp_db.dart';
import 'package:dulce_precision/database/metodos/ventas_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/database/metodos/metodos_db_dp.dart'; // Importamos el repositorio de métodos generales
import 'package:flutter/material.dart'; // Importamos el paquete de Flutter
import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger para el manejo de errores

class VentasProvider with ChangeNotifier {
    List<Venta> _ventas = []; // Lista de ventas
  Venta? _venta; // Venta individual

  // Getter para una venta específica
  Venta? get venta => _venta;

  // Función para obtener todas las ventas (si ya la tienes, puedes omitir esta parte)
  Future<void> obtenerVentas() async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos
    final List<Map<String, dynamic>> ventasData = await db.query('ventas');
    _ventas = ventasData.map((venta) => Venta.fromMap(venta)).toList();
    notifyListeners();
  }

  // Nueva función para obtener una venta por su ID
  Future<Venta?> getVentaById(int idVenta) async {
    final db = await DatabaseHelper().database; // Obtenemos la instancia de la base de datos

    // Consultamos la base de datos para obtener la venta específica
    final List<Map<String, dynamic>> ventaData = await db.query(
      'ventas',
      where: 'idVenta = ?', // Condición para buscar por idVenta
      whereArgs: [idVenta],
    );

    // Si encontramos la venta, la convertimos en un objeto Venta
    if (ventaData.isNotEmpty) {
      _venta = Venta.fromMap(ventaData.first); // Convertimos el primer resultado en un objeto Venta
      notifyListeners();
      return _venta;
    }

    // Si no se encuentra ninguna venta, retornamos null
    return null;
  }
  final VentaRepository _ventaRepository = VentaRepository(); // Instancia del repositorio de ventas
  final MetodosRepository _metodosRepository = MetodosRepository(); // Instancia del repositorio de métodos generales

  // Getter para la lista de ventas
  List<Venta> get ventas => _ventas;

  // // Método para obtener todas las ventas desde la base de datos
  // Future<void> obtenerVentas() async {
  //   try {
  //     _ventas = await _ventaRepository.getAllVentas(); // Obtiene las ventas del repositorio
  //     notifyListeners(); // Notifica a los widgets que los datos han cambiado
  //   } catch (e) {
  //     // Registro de errores usando CustomLogger
  //     CustomLogger().logError('Error al obtener ventas: $e');
  //     throw Exception("Error al obtener ventas"); // Lanzamos una excepción para manejo externo
  //   }
  // }

  // Método para agregar una venta
  Future<void> agregarVenta(Venta venta) async {
    try {
      await _ventaRepository.insertarVenta(venta); // Inserta la venta
      await obtenerVentas(); // Actualiza la lista después de insertar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al agregar venta: $e');
      throw Exception("Error al agregar venta"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar una venta por su ID
  Future<void> eliminarVenta(int idVenta) async {
    try {
      await _ventaRepository.eliminarVenta(idVenta); // Elimina la venta
      await obtenerVentas(); // Actualiza la lista después de eliminar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al eliminar venta con id $idVenta: $e');
      throw Exception("Error al eliminar venta"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar todo el contenido de la tabla de ventas
  Future<void> eliminarContenidoTablaVentas() async {
    try {
      await _metodosRepository.deleteTableContent('ventas'); // Elimina el contenido de la tabla 'ventas'
      await obtenerVentas(); // Actualiza la lista después de eliminar
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      CustomLogger().logError('Error al eliminar contenido de la tabla ventas: $e');
      throw Exception("Error al eliminar contenido de la tabla ventas"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para actualizar una venta
  Future<void> actualizarVenta(Venta venta) async {
    try {
      await _ventaRepository.actualizarVenta(venta); // Actualiza la venta en el repositorio
      await obtenerVentas(); // Actualiza la lista después de actualizar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al actualizar venta con id ${venta.idVenta}: $e');
      throw Exception("Error al actualizar venta"); // Lanzamos una excepción para manejo externo
    }
  }
}
