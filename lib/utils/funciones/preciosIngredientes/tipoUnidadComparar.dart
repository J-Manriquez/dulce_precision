import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';

// Función para comparar los tipos de unidad de medida de los productos e ingredientes.
// Acepta como parámetro una lista de coincidencias obtenidas de la función compararNombres.
Future<List<Map<String, dynamic>>> compararTipoUnidad(
    List<Map<String, String>> coincidencias) async {
  List<Map<String, dynamic>> resultados =
      []; // Lista para almacenar los resultados de las comparaciones
  final productoRepositorio = ProductRepository();
  final ingredienteRecetaRepository = IngredienteRecetaRepository();

  // Recorremos cada coincidencia para obtener los ids de producto e ingrediente
  for (var coincidencia in coincidencias) {
    // Obtenemos el ID del producto e ingrediente de la coincidencia
    int idProducto = int.parse(coincidencia['idProducto']!);
    int idIngrediente = int.parse(coincidencia['idIngrediente']!);

    // Obtenemos el producto y el ingrediente por su ID
    Producto producto = await productoRepositorio.getProductoById(idProducto);
    IngredienteReceta ingrediente =
        await ingredienteRecetaRepository.getIngredienteById(idIngrediente);

    // Inicializamos variables para almacenar la información de la comparación
    bool tiposIguales = false; // Indica si los tipos de unidad son iguales
    bool tiposCompatibles =
        false; // Indica si los tipos de unidad son compatibles
    double cantidadProductoTransformada =
        producto.cantidadOriginalProducto; // Cantidad del producto transformada
    String tipoUnidad; // Tipo de unidad del producto

    // Comparamos los tipos de unidad
    if (producto.tipoUnidadProducto == ingrediente.tipoUnidadIngrediente) {
      tiposIguales = true; // Tipos iguales
      cantidadProductoTransformada =
          producto.cantidadOriginalProducto; // No se realiza transformación
      tipoUnidad = producto.tipoUnidadProducto; // Tipo de unidad original
    } else {
      // Comprobamos si son compatibles
      if (sonTiposCompatibles(
          producto.tipoUnidadProducto, ingrediente.tipoUnidadIngrediente)) {
        tiposCompatibles = true; // Tipos compatibles
        // Transformamos la cantidad según las reglas especificadas
        if (producto.tipoUnidadProducto == 'kilogramos' &&
            ingrediente.tipoUnidadIngrediente == 'gramos') {
          cantidadProductoTransformada =
              producto.cantidadOriginalProducto * 1000; // Multiplicamos por 1000
        } else if (producto.tipoUnidadProducto == 'gramos' &&
            ingrediente.tipoUnidadIngrediente == 'kilogramos') {
          cantidadProductoTransformada =
              producto.cantidadOriginalProducto / 1000; // Dividimos por 1000
        } else if (producto.tipoUnidadProducto == 'litros' &&
            ingrediente.tipoUnidadIngrediente == 'mililitros') {
          cantidadProductoTransformada =
              producto.cantidadOriginalProducto * 1000; // Multiplicamos por 1000
        } else if (producto.tipoUnidadProducto == 'mililitros' &&
            ingrediente.tipoUnidadIngrediente == 'litros') {
          cantidadProductoTransformada =
              producto.cantidadOriginalProducto / 1000; // Dividimos por 1000
        }
        tipoUnidad =
            ingrediente.tipoUnidadIngrediente; // Tipo de unidad del ingrediente
      } else {
        // Si los tipos no son compatibles, se muestra un error
        CustomLogger().logInfo(
            'UNIDAD DE MEDIDA NO COMPATIBLE ENTRE PRODUCTO ${producto.nombreProducto} (${producto.tipoUnidadProducto}) E INGREDIENTE ${ingrediente.nombreIngrediente} (${ingrediente.tipoUnidadIngrediente})');

        final ingredienteRecetaRepository =
            IngredienteRecetaRepository(); // Crear instancia del repositorio de ingredientes
        // Crear un objeto IngredienteReceta con los datos que deseas actualizar
        IngredienteReceta ingredienteReceta = IngredienteReceta(
            idIngrediente: ingrediente
                .idIngrediente, // ID del ingrediente que deseas actualizar
            nombreIngrediente:
                ingrediente.nombreIngrediente, // Nuevo nombre del ingrediente
            costoIngrediente:
                "Unidad de medida (${producto.tipoUnidadProducto}) del producto ${producto.nombreProducto} no compatible con unidad de medida (${ingrediente.tipoUnidadIngrediente}) del ingrediente ${ingrediente.nombreIngrediente}",
            cantidadIngrediente:
                ingrediente.cantidadIngrediente, // Nueva cantidad
            tipoUnidadIngrediente:
                ingrediente.tipoUnidadIngrediente, // Nueva unidad
            idReceta: ingrediente
                .idReceta // ID de la receta asociada (si es aplicable)
            );

        try {
          // Llamamos a la función para actualizar el ingrediente
          await ingredienteRecetaRepository
              .actualizarIngrediente(ingredienteReceta);
        } catch (e) {
          // Manejo de errores
          print('Error al actualizar costo no compatible del ingrediente: $e');
        }

        tipoUnidad = "No compatible";
      }
    }

    // Calculamos el costo del ingrediente
    double costoIngrediente =
        (producto.precioProducto / cantidadProductoTransformada) *
            ingrediente.cantidadIngrediente;
    CustomLogger().logInfo(
        'COSTO DEL INGREDIENTE: producto.nombreProducto = ${producto.nombreProducto} producto.precioProducto = ${producto.precioProducto} producto.cantidadProducto = ${producto.cantidadProducto} ingrediente.cantidadIngrediente = ${ingrediente.cantidadIngrediente} costoIngrediente = $costoIngrediente');
    // Agregamos la información a la lista de resultados
    resultados.add({
      'idIngrediente': ingrediente.idIngrediente,
      'idProducto': producto.idProducto,
      'tiposUnidadIguales': tiposIguales,
      'tiposUnidadCompatibles': tiposCompatibles,
      'cantidadProducto': cantidadProductoTransformada,
      'tipoUnidad': tipoUnidad,
      'precioProducto': producto.precioProducto,
      'cantidadIngrediente': ingrediente.cantidadIngrediente,
      'costoIngrediente': costoIngrediente
    });
    CustomLogger().logInfo('RESULTADO: $resultados');
  }

  // Retornamos la lista de resultados
  return resultados;
}

// Función para comprobar si los tipos de unidad son compatibles
bool sonTiposCompatibles(
    String tipoUnidadProducto, String tipoUnidadIngrediente) {
  // Definimos las unidades compatibles
  const Map<String, List<String>> compatibilidad = {
    'unidad': ['unidad'],
    'gramos': ['kilogramos'],
    'kilogramos': ['gramos'],
    'mililitros': ['litros'],
    'litros': ['mililitros'],
  };

  // Comprobamos si hay compatibilidad
  return compatibilidad[tipoUnidadProducto]?.contains(tipoUnidadIngrediente) ??
      false;
}
