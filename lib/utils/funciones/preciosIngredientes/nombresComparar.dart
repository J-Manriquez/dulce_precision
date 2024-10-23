// Importamos las librerías necesarias
import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/normalizar_nombres.dart';

// Función para comparar los nombres normalizados de los productos e ingredientes.
// Retorna una lista de coincidencias con el formato [nombreProducto, nombreIngrediente].
Future<List<Map<String, String>>> compararNombres() async {
  final productoRepositorio = ProductRepository();
  final ingredienteRecetaRepository = IngredienteRecetaRepository();

  // Obtenemos todos los productos e ingredientes
  final List<Producto> productos = await productoRepositorio.getAllProductos();
  final List<IngredienteReceta> ingredientes = await ingredienteRecetaRepository.getAllIngredientes();

  List<Map<String, String>> coincidencias = []; // Lista para almacenar las coincidencias encontradas
  List<int> ingredientesSinCoincidencia = []; // Lista para almacenar los idIngrediente sin coincidencias

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
      ingredientesSinCoincidencia.add(ingrediente.idIngrediente!);
    }
  }

  // Actualizamos el costo de los ingredientes que no encontraron coincidencia
  for (var idIngrediente in ingredientesSinCoincidencia) {
    // Obtener el ingrediente por ID
    IngredienteReceta ingrediente = await ingredienteRecetaRepository.getIngredienteById(idIngrediente);
    
    IngredienteReceta ingredienteReceta = IngredienteReceta(
            idIngrediente: ingrediente
                .idIngrediente, // ID del ingrediente que deseas actualizar
            nombreIngrediente:
                ingrediente.nombreIngrediente, // Nuevo nombre del ingrediente
            costoIngrediente: "No se encontro un producto con el nombre de este ingrediente para calcular el costo",
            cantidadIngrediente: ingrediente.cantidadIngrediente, // Nueva cantidad
            tipoUnidadIngrediente: ingrediente.tipoUnidadIngrediente, // Nueva unidad
            idReceta: ingrediente.idReceta // ID de la receta asociada (si es aplicable)
            );
    // Actualizamos el ingrediente en la base de datos
    await ingredienteRecetaRepository.actualizarIngrediente(ingredienteReceta);
  }

  // Retornamos la lista de coincidencias encontradas
  return coincidencias;
}
