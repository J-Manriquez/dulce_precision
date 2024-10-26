import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/utils/funciones/cantidadProductos/nombresCompararPyI.dart';

// Función para verificar la compatibilidad de unidades y retornar listas de ingredientes con y sin stock
Future<Map<String, dynamic>> verificarIngredientesStock(int idReceta) async {
  // CustomLogger()      .logInfo('Verificando ingredientes de la receta con ID: $idReceta **');
  ProductRepository productoRepositorio = ProductRepository();
  IngredienteRecetaRepository ingredienteRecetaRepository =
      IngredienteRecetaRepository();

  List<String> ingredientesConStock = [];
  List<String> ingredientesSinStock = [];

  List<Map<String, String>> coincidencias = await compararNombresPyI(idReceta);

  for (var coincidencia in coincidencias) {
    // CustomLogger()        .logInfo('buscando coincidencias para receta id: $idReceta **');

    int idProducto = int.parse(coincidencia['idProducto']!);
    int idIngrediente = int.parse(coincidencia['idIngrediente']!);

    Producto producto = await productoRepositorio.getProductoById(idProducto);
    IngredienteReceta ingrediente =
        await ingredienteRecetaRepository.getIngredienteById(idIngrediente);

    // CustomLogger().logInfo(        'Producto: ${producto.nombreProducto}, Ingrediente: ${ingrediente.nombreIngrediente}');

    bool tiposCompatibles = false;
    double cantidadIngredienteTransformada = ingrediente.cantidadIngrediente;

    // Verificar si las unidades de medida son iguales
    if (producto.tipoUnidadProducto == ingrediente.tipoUnidadIngrediente) {
      tiposCompatibles =
          true; // Las unidades son iguales, no es necesario convertir
            // CustomLogger().logInfo('las unidades son iguales');

    } else if (sonTiposCompatibles(
        producto.tipoUnidadProducto, ingrediente.tipoUnidadIngrediente)) {
      tiposCompatibles = true;
      // CustomLogger().logInfo('las unidades son compatibles');

      // Convertir la cantidad del ingrediente a la unidad del producto
      if (ingrediente.tipoUnidadIngrediente == 'gramos' &&
          producto.tipoUnidadProducto == 'kilogramos') {
        cantidadIngredienteTransformada =
            ingrediente.cantidadIngrediente / 1000;

      } else if (ingrediente.tipoUnidadIngrediente == 'kilogramos' &&
          producto.tipoUnidadProducto == 'gramos') {
        cantidadIngredienteTransformada =
            ingrediente.cantidadIngrediente * 1000;
      } else if (ingrediente.tipoUnidadIngrediente == 'mililitros' &&
          producto.tipoUnidadProducto == 'litros') {
        cantidadIngredienteTransformada =
            ingrediente.cantidadIngrediente / 1000;
      } else if (ingrediente.tipoUnidadIngrediente == 'litros' &&
          producto.tipoUnidadProducto == 'mililitros') {
        cantidadIngredienteTransformada =
            ingrediente.cantidadIngrediente * 1000;
      } else {
        CustomLogger().logError(
            'UNIDAD NO COMPATIBLE ENTRE PRODUCTO ${producto.nombreProducto} (${producto.tipoUnidadProducto}) E INGREDIENTE ${ingrediente.nombreIngrediente} (${ingrediente.tipoUnidadIngrediente})');
      }

    }

    if (tiposCompatibles) {
      // CustomLogger().logInfo('las unidades son compatibles iniciando logica de stock');

      var cantidadActual = producto.cantidadProducto;
      // CustomLogger().logInfo('cantidad actual: $cantidadActual');

      // CustomLogger().logInfo('cantidadIngredienteTransformada: $cantidadIngredienteTransformada');

      if (cantidadIngredienteTransformada > cantidadActual && producto.cantidadUnidadesProducto <= 1) {
        ingredientesSinStock.add(ingrediente.nombreIngrediente);
        // CustomLogger().logError(            'Cantidad insuficiente del ingrediente: ${ingrediente.nombreIngrediente}');
        continue; // Saltar a la siguiente coincidencia
      }
      else if (cantidadIngredienteTransformada <= cantidadActual && producto.cantidadUnidadesProducto >= 1) {
        ingredientesConStock.add(ingrediente.nombreIngrediente);
        // CustomLogger().logInfo('ingrediente con stock: ${ingrediente.nombreIngrediente}');
        continue; // Saltar a la siguiente coincidencia
      }
      else {
        CustomLogger().logError(
            'LOGICA NO ESPERADA');
        continue; // Saltar a la siguiente coincidencia
      }
      
    } else {
      CustomLogger().logError(
          'UNIDAD NO COMPATIBLE ENTRE PRODUCTO ${producto.nombreProducto} (${producto.tipoUnidadProducto}) E INGREDIENTE ${ingrediente.nombreIngrediente} (${ingrediente.tipoUnidadIngrediente})');
    }
  }

  // Verificar si hay ingredientes sin stock
  bool recetaDisponible = ingredientesSinStock.isEmpty;
  // CustomLogger().logInfo('Receta disponible: $recetaDisponible');
  // CustomLogger().logInfo('Ingredientes con stock: $ingredientesConStock');
  // CustomLogger().logInfo('Ingredientes sin stock: $ingredientesSinStock');

  // Retornar un mapa con las listas de ingredientes y el estado de la receta
  return {
    'ingredientesConStock': ingredientesConStock,
    'ingredientesSinStock': ingredientesSinStock,
    'recetaDisponible': recetaDisponible,
  };
}

// Función auxiliar para comprobar compatibilidad de unidades
bool sonTiposCompatibles(
    String tipoUnidadProducto, String tipoUnidadIngrediente) {
  const Map<String, List<String>> compatibilidad = {
    'unidad': ['unidad'],
    'gramos': ['kilogramos'],
    'kilogramos': ['gramos'],
    'mililitros': ['litros'],
    'litros': ['mililitros'],
  };

  return compatibilidad[tipoUnidadProducto]?.contains(tipoUnidadIngrediente) ??
      false;
}
