import 'package:dulce_precision/database/metodos/metodos_db_dp.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/models/db_model.dart'; // Modelo Producto
import 'package:dulce_precision/database/metodos/productos_metodos.dart'; // Repositorio de productos

class ProductosProvider with ChangeNotifier {
  List<Producto> _productos = []; // Lista privada de productos
  final ProductRepository _productRepository =
      ProductRepository(); // Instancia del repositorio
  final MetodosRepository _metodosRepository =
      MetodosRepository(); // Instancia del repositorio
  List<Producto> get productos =>
      _productos; // Getter para la lista de productos

  // Método para obtener productos desde la base de datos
  Future<void> obtenerProductos() async {
    try {
      _productos = await _productRepository
          .getAllProductos(); // Obtiene productos del repositorio
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al obtener productos: $e');
      // Aquí puedes manejar los errores, como mostrar un mensaje al usuario.
      throw Exception(
          "Error al obtener productos"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para agregar un producto
  Future<void> agregarProducto(Producto producto) async {
    try {
      await _productRepository.insertProducto(producto); // Inserta producto
      await obtenerProductos(); // Actualiza la lista después de insertar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al agregar producto: $e');
      throw Exception(
          "Error al agregar producto"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar un producto
  Future<void> eliminarProducto(int idProducto) async {
    try {
      await _productRepository.eliminarProducto(idProducto); // Elimina producto
      await obtenerProductos(); // Actualiza la lista después de eliminar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger()
          .logError('Error al eliminar producto con id $idProducto: $e');
      throw Exception(
          "Error al eliminar producto"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar todo el contenido de la tabla de recetas
  Future<void> eliminarContenidoTablaProductos() async {
    try {
      await _metodosRepository.deleteTableContent(
          'productos'); // Elimina el contenido de la tabla 'recetas'
      await obtenerProductos(); // Actualiza la lista después de eliminar
      notifyListeners(); // Notifica a los listeners
    } catch (e) {
      CustomLogger()
          .logError('Error al eliminar contenido de la tabla recetas: $e');
      throw Exception(
          "Error al eliminar contenido de la tabla recetas"); // Lanzamos una excepción para manejo externo
    }
  }
}
