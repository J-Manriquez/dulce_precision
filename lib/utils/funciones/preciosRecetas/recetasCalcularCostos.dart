import 'dart:async';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/recetas_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';

// Función para calcular el costo total de todas las recetas
Future<void> calcularCostoCadaRecetas() async {
  CustomLogger().logInfo('Iniciando cálculo de costo de recetas');
  final recetaRepositorio = RecetaRepository();
  final ingredienteRecetaRepositorio = IngredienteRecetaRepository();

  // double costoTotalRecetas =
  //     0.0; // Variable para almacenar el costo total de todas las recetas

  try {
    // Paso 1: Obtener todas las recetas y sus ID
    final List<Receta> recetas = await recetaRepositorio.getAllRecetas();
    List<int?> idsReceta = recetas.map((receta) => receta.idReceta).toList();

    // Verificar si hay recetas para procesar
    if (idsReceta.isEmpty) {
      CustomLogger().logInfo('No hay recetas para calcular el costo.');
      return;
    } else {
      CustomLogger()
          .logInfo('Hay ${idsReceta.length} recetas para calcular el costo.');
    }

    // Paso 2: Crear un diccionario con idReceta y sus ingredientes
    Map<int, List<IngredienteReceta>> ingredientesPorReceta = {};

    for (var idReceta in idsReceta) {
      // Obtenemos los ingredientes de la receta
      final List<IngredienteReceta> ingredientes =
          await ingredienteRecetaRepositorio
              .getAllIngredientesPorReceta(idReceta!);
      ingredientesPorReceta[idReceta] = ingredientes;
    }

    // Paso 3: Calcular el costo de cada receta
    for (var entry in ingredientesPorReceta.entries) {
      int idReceta = entry.key;
      List<IngredienteReceta> ingredientes = entry.value;

      double costoTotalReceta =
          0.0; // Variable para almacenar el costo de la receta actual
      List<String> ingredientesConCostoCero =
          []; // Lista para almacenar ingredientes con costo 0
      List<String> ingredientesConMensaje =
          []; // Lista para almacenar ingredientes con mensajes de alerta

      // Recorremos los ingredientes para calcular el costo total
      for (var ingrediente in ingredientes) {
        // Verificar si el costo contiene letras
        bool contieneLetras =
            RegExp(r'[a-zA-Z]').hasMatch(ingrediente.costoIngrediente);

        if (contieneLetras) {
          ingredientesConMensaje.add(ingrediente.nombreIngrediente);
        } else {
          // Convertir el costo a double
          double costoIngrediente =
              double.tryParse(ingrediente.costoIngrediente) ?? 0.0;

          if (costoIngrediente == 0.0) {
            // Verificamos si el costo del ingrediente es 0
            ingredientesConCostoCero.add(ingrediente.nombreIngrediente);
          } else {
            // Sumamos el costo convertido a double al costo total de la receta
            costoTotalReceta += costoIngrediente;
          }
        }
        CustomLogger().logInfo(
            'CALCULAR PRECIO RECETA: nombreIngrediente: ${ingrediente.nombreIngrediente} costoIngrediente: ${ingrediente.costoIngrediente}');
      }

      // Actualizar la receta con un mensaje adecuado
      String costoRecetaMensaje;
      if (ingredientesConMensaje.isNotEmpty) {
        costoRecetaMensaje =
            '''Estos ingredientes tienen un mensaje de alerta: \n• ${ingredientesConMensaje.join("\n• ")}''';
        CustomLogger().logInfo(
            'La receta con ID $idReceta contiene ingredientes con mensajes de alerta: ${ingredientesConMensaje.join(', ')}');
      } else if (ingredientesConCostoCero.isNotEmpty) {
        costoRecetaMensaje =
            "Estos ingredientes no tienen costo: \n${ingredientesConCostoCero.join('\n• ')}";
        CustomLogger().logInfo(
            'La receta con ID $idReceta contiene ingredientes con costo 0: ${ingredientesConCostoCero.join('\n')}');
      } else {
        costoRecetaMensaje = "$costoTotalReceta";
      }

      // Obtener y actualizar la receta
      var receta = await recetaRepositorio.obtenerRecetaPorId(idReceta);
      if (receta != null) {
        var recetaActualizada = Receta(
          idReceta: receta.idReceta,
          nombreReceta: receta.nombreReceta,
          costoReceta: costoRecetaMensaje,
          descripcionReceta: receta.descripcionReceta,
        );

        try {
          await recetaRepositorio.actualizarReceta(recetaActualizada);
          // await recetaProvider.agregarReceta(recetaActualizada);

          CustomLogger()
              .logInfo('Receta costo!: ${recetaActualizada.costoReceta}');
          CustomLogger().logInfo(
              'Receta actualizada con éxito: ${recetaActualizada.idReceta} $recetaActualizada');
        } catch (e) {
          CustomLogger()
              .logError('Error al actualizar el costo de la receta: $e');
        }
      }

      // // Si todos los ingredientes tienen un costo válido, agregamos el costo de la receta al total general
      // if (ingredientesConMensaje.isEmpty && ingredientesConCostoCero.isEmpty) {
      //   costoTotalRecetas += costoTotalReceta;
      // }
    }

    // Retornamos el costo total de todas las recetas
  } catch (e) {
    // Manejo de errores
    CustomLogger()
        .logError('Error al calcular el costo total de las recetas: $e');
    throw Exception("Error al calcular el costo total de las recetas");
  }
}
