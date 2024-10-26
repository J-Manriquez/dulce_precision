import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/database/providers/productos_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Función para verificar la compatibilidad de unidades y actualizar productos e ingredientes
Future<void> verificarYActualizarProductos(
    List<Map<String, String>> coincidencias, BuildContext context) async {
  ProductRepository productoRepositorio = ProductRepository();
  ProductosProvider productosProvider = ProductosProvider();
  IngredienteRecetaRepository ingredienteRecetaRepository =
      IngredienteRecetaRepository();
  List<String> productosNoCompatibles = [];

  for (var coincidencia in coincidencias) {
    int idProducto = int.parse(coincidencia['idProducto']!);
    int idIngrediente = int.parse(coincidencia['idIngrediente']!);

    Producto producto = await productoRepositorio.getProductoById(idProducto);
    IngredienteReceta ingrediente =
        await ingredienteRecetaRepository.getIngredienteById(idIngrediente);

    bool tiposCompatibles = false;
    double cantidadIngredienteTransformada = ingrediente.cantidadIngrediente;

    // Verificar si las unidades de medida son iguales
    if (producto.tipoUnidadProducto == ingrediente.tipoUnidadIngrediente) {
      tiposCompatibles =
          true; // Las unidades son iguales, no es necesario convertir
    } else if (sonTiposCompatibles(
        producto.tipoUnidadProducto, ingrediente.tipoUnidadIngrediente)) {
      tiposCompatibles = true;
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
      }
    }

    if (tiposCompatibles) {
      var cantidadActual = producto.cantidadProducto;
      var nuevaCantidad = cantidadActual - cantidadIngredienteTransformada;

      // Condición 0: Si la cantidadProducto es 0 y hay 0 unidades
      if (nuevaCantidad == 0 && producto.cantidadUnidadesProducto == 0) {
        producto = Producto(
          idProducto: idProducto,
          cantidadProducto: 0,
          nombreProducto: producto.nombreProducto,
          tipoUnidadProducto: producto.tipoUnidadProducto,
          precioProducto: producto.precioProducto,
          cantidadUnidadesProducto: 0,
          cantidadOriginalProducto: producto.cantidadOriginalProducto,
        );

        final mensaje = 'El producto ${producto.nombreProducto} se agotó.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensaje)));
        CustomLogger().logError('Producto agotado: ${producto.nombreProducto}');
        continue; // Saltar a la siguiente coincidencia
      } // Condición 1: Si la cantidadProducto es menor que la cantidad de ingrediente y hay más de una unidad
      else if (nuevaCantidad < 0 && producto.cantidadUnidadesProducto >= 1) {
        // Sumar la cantidad original para compensar la falta de cantidad
        nuevaCantidad = producto.cantidadOriginalProducto +
            cantidadActual -
            cantidadIngredienteTransformada;
        // Reducir una unidad del producto
        var nuevasUnidades = producto.cantidadUnidadesProducto - 1;

        producto = Producto(
          idProducto: idProducto,
          cantidadProducto: nuevaCantidad,
          nombreProducto: producto.nombreProducto,
          tipoUnidadProducto: producto.tipoUnidadProducto,
          precioProducto: producto.precioProducto,
          cantidadUnidadesProducto: nuevasUnidades,
          cantidadOriginalProducto: producto.cantidadOriginalProducto,
        );

        // Verificar si ahora la cantidad de unidades es 0, para mostrar el mensaje de producto agotado
        if (nuevasUnidades == 0 && nuevaCantidad <= producto.cantidadOriginalProducto*30) {
          final mensaje = 'El producto ${producto.nombreProducto} casi se agota.';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(mensaje)));
          CustomLogger()
              .logError('Producto agotado: ${producto.nombreProducto}');
          continue; // Saltar a la siguiente coincidencia
        }

        // Condición 2: Si la cantidadProducto llega a 0 pero hay más de una unidad restante
      } else if (nuevaCantidad == 0 && producto.cantidadUnidadesProducto > 1) {
        var nuevasUnidades = producto.cantidadUnidadesProducto - 1;

        producto = Producto(
          idProducto: idProducto,
          cantidadProducto:
              producto.cantidadOriginalProducto, // Restablecer cantidadProducto
          nombreProducto: producto.nombreProducto,
          tipoUnidadProducto: producto.tipoUnidadProducto,
          precioProducto: producto.precioProducto,
          cantidadUnidadesProducto: nuevasUnidades,
          cantidadOriginalProducto: producto.cantidadOriginalProducto,
        );

        // Verificar si ahora la cantidad de unidades es 0, para mostrar el mensaje de producto agotado
        if (nuevasUnidades == 0) {
          final mensaje = 'El producto ${producto.nombreProducto} se agotó.';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(mensaje)));
          CustomLogger()
              .logError('Producto agotado: ${producto.nombreProducto}');
          continue; // Saltar a la siguiente coincidencia
        }

        // Condición 3: Si la cantidadProducto es insuficiente y ya no hay más unidades para compensar
      } else if (nuevaCantidad < 0 && producto.cantidadUnidadesProducto == 0) {
        final mensaje =
            'Cantidad insuficiente de ${producto.nombreProducto} para la receta.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(mensaje)));
        CustomLogger().logError(
            'Cantidad insuficiente del producto: ${producto.nombreProducto}');
        continue; // Saltar a la siguiente coincidencia
      } else {
        // Condición 4: Si la cantidad es suficiente para cubrir el ingrediente
        producto = Producto(
          idProducto: idProducto,
          cantidadProducto: nuevaCantidad,
          nombreProducto: producto.nombreProducto,
          tipoUnidadProducto: producto.tipoUnidadProducto,
          precioProducto: producto.precioProducto,
          cantidadUnidadesProducto: producto.cantidadUnidadesProducto,
          cantidadOriginalProducto: producto.cantidadOriginalProducto,
        );
      }

      try {
        await productosProvider.actualizarProducto(producto);
        CustomLogger().logInfo(
            'Producto actualizado: ${producto.nombreProducto}, nueva cantidad: ${nuevaCantidad}');
      } catch (e) {
        CustomLogger().logError('Error al actualizar producto: $e');
      }
    } else {
      // Si no son compatibles, agregar el producto a la lista de productos no compatibles
      productosNoCompatibles.add(producto.nombreProducto);
      CustomLogger().logError(
          'UNIDAD NO COMPATIBLE ENTRE PRODUCTO ${producto.nombreProducto} (${producto.tipoUnidadProducto}) E INGREDIENTE ${ingrediente.nombreIngrediente} (${ingrediente.tipoUnidadIngrediente})');
    }
  }

  // Si hay productos no compatibles, mostrar un Snackbar al usuario
  if (productosNoCompatibles.isNotEmpty) {
    final mensaje =
        'Unidades no compatibles en los productos: ${productosNoCompatibles.join(", ")}';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }
  Provider.of<ProductosProvider>(context, listen: false).obtenerProductos();
  CustomLogger().logInfo('Verificación de unidades finalizada');
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
