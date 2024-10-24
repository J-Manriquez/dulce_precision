// Importamos las librerías necesarias
import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/normalizar_nombres.dart';

// Función para comparar los nombres normalizados de los productos e ingredientes de una receta.
// Recibe como parámetro el idReceta y retorna una lista de coincidencias con el formato [nombreProducto, nombreIngrediente].
Future<List<Map<String, String>>> compararNombresPyI(int idReceta) async {
  final productoRepositorio = ProductRepository();
  final ingredienteRecetaRepository = IngredienteRecetaRepository();

  // Obtenemos todos los productos y los ingredientes de la receta especificada
  final List<Producto> productos = await productoRepositorio.getAllProductos();
  final List<IngredienteReceta> ingredientes = await ingredienteRecetaRepository.getAllIngredientesPorReceta(idReceta);

  List<Map<String, String>> coincidencias = []; // Lista para almacenar las coincidencias encontradas
  List<String> ingredientesSinCoincidencia = []; // Lista para almacenar los idIngrediente sin coincidencias

  // Recorremos cada ingrediente y producto para comparar sus nombres normalizados
  for (var ingrediente in ingredientes) {
    bool encontrado = false; // Bandera para indicar si se encontró coincidencia para el ingrediente

    for (var producto in productos) {
      // Normalizamos los nombres del producto y el ingrediente
      String nombreProductoNormalizado = normalizar(producto.nombreProducto);
      String nombreIngredienteNormalizado = normalizar(ingrediente.nombreIngrediente);

      // Si los nombres normalizados coinciden, agregamos la coincidencia a la lista
      if (nombreProductoNormalizado == nombreIngredienteNormalizado) {
        coincidencias.add({
          'idProducto': producto.idProducto.toString(), // ID del producto
          'idIngrediente': ingrediente.idIngrediente.toString() // ID del ingrediente
        });
        encontrado = true; // Se encontró coincidencia
        break; // Salimos del bucle ya que no necesitamos seguir buscando
      }
    }

    // Si no se encontró coincidencia, agregamos el idIngrediente a la lista
    if (!encontrado) {
      ingredientesSinCoincidencia.add(ingrediente.nombreIngrediente);
    }
  }

  // Retornamos la lista de coincidencias encontradas
  return coincidencias;
}
