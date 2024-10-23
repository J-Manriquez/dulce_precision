import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/recetas_metodos.dart';
import 'package:dulce_precision/database/providers/ingredientes_provider.dart';
import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/screens/modals/refresh_modal.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/ingredientesCalcularCostos.dart';
import 'package:dulce_precision/utils/funciones/preciosRecetas/recetasCalcularCostos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/db_model.dart'; // Asegúrate de tener este modelo importado

// Modal para ver los detalles de la receta
Future<void> mostrarDetallesModal(BuildContext context, int? idReceta) {
  final themeModel = Provider.of<ThemeModel>(context, listen: false);
  final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

  final recetaRepositorio = RecetaRepository();
  final ingredienteRecetaRepositorio = IngredienteRecetaRepository();

  // funcion
  // Función asíncrona que actualiza los costos de ingredientes y recetas con una animación de carga.
  Future<void> actualizarConAnimacion(
      BuildContext context, int? idReceta) async {
    // Mostrar un diálogo de carga para indicar que se está realizando una operación.
    refreshDialog(context, color: themeModel.primaryButtonColor);

    try {
      // Llamadas a funciones que realizan actualizaciones en los costos.
      await actualizarCostosAllIngredientes(); // Actualiza los costos de todos los ingredientes.
      await calcularCostoCadaRecetas(); // Calcula el costo de cada receta.

      // Actualizar proveedores con la nueva información de recetas e ingredientes.
      await Provider.of<RecetasProvider>(context, listen: false)
          .obtenerRecetas(); // Obtiene las recetas actualizadas.
      await Provider.of<IngredientesRecetasProvider>(context, listen: false)
          .obtenerIngredientes(); // Obtiene los ingredientes actualizados.

      // Cerrar el diálogo de carga.
      Navigator.of(context).pop(); // Cierra el diálogo de carga.

      // Cerrar el modal actual (si corresponde).
      Navigator.of(context)
          .pop(); // Esto cierra el modal que se estaba mostrando.

      // Volver a abrir el modal con datos actualizados.
      await mostrarDetallesModal(
          context, idReceta); // Muestra los detalles de la receta actualizada.
    } catch (e) {
      // Cerrar el diálogo de carga en caso de error.
      Navigator.of(context)
          .pop(); // Asegúrate de cerrar el diálogo incluso si hay un error.

      // Mostrar un mensaje de error utilizando un SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error al actualizar los costos'), // Mensaje de error para el usuario.
        ),
      );
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<Receta?>(
        future: recetaRepositorio.obtenerRecetaPorId(idReceta!),
        builder: (context, recetaSnapshot) {
          if (recetaSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!recetaSnapshot.hasData || recetaSnapshot.data == null) {
            return const Center(child: Text('No se pudo cargar la receta.'));
          }
          final receta = recetaSnapshot.data!;

          return FutureBuilder<List<IngredienteReceta>>(
            future: ingredienteRecetaRepositorio
                .getAllIngredientesPorReceta(idReceta),
            builder: (context, ingredientesSnapshot) {
              if (ingredientesSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!ingredientesSnapshot.hasData ||
                  ingredientesSnapshot.data!.isEmpty) {
                return const Center(child: Text('No hay ingredientes disponibles.'));
              }
              final ingredientes = ingredientesSnapshot.data!;
              return Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Ancho en 80% de la pantalla
                  height: MediaQuery.of(context).size.height *
                      0.8, // Alto en 60% de la pantalla
                  decoration: BoxDecoration(
                    color:
                        themeModel.backgroundColor, // Color de fondo del modal
                    borderRadius:
                        BorderRadius.circular(20), // Esquinas redondeadas
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16), // Padding para el título
                        child: Text(
                          'Costos de la receta: \n${receta.nombreReceta}',
                          style: TextStyle(
                            fontSize: fontSizeModel.titleSize,
                            color: themeModel.primaryTextColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nueva fila para mostrar el precio de la receta y el botón para actualizar
                              // Verifica si el costo de la receta es un número válido o contiene letras
                              if (receta.costoReceta != null) ...[
                                // Expresión regular para verificar si contiene letras
                                RegExp(r'[a-zA-Z]')
                                        .hasMatch(receta.costoReceta!)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical:
                                                    4), // Padding para el botón "Cerrar"
                                            child: Text(
                                              '${receta.costoReceta}', // Muestra el precio de la receta
                                              style: TextStyle(
                                                fontSize:
                                                    fontSizeModel.textSize,
                                                color:
                                                    themeModel.primaryTextColor,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25,
                                                vertical:
                                                    0), // Padding para el botón "Cerrar"
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size(double.infinity, 30),
                                                backgroundColor:
                                                    themeModel.primaryTextColor,
                                                foregroundColor: themeModel
                                                    .primaryButtonColor,
                                              ),
                                              onPressed: () async {
                                                await actualizarConAnimacion(
                                                    context, idReceta);
                                              },
                                              child: const Icon(Icons.refresh),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical:
                                                0), // Padding para el botón "Cerrar"
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              RegExp(r'[a-zA-Z]').hasMatch(
                                                      receta.costoReceta!)
                                                  ? '''Precio:\nNo se puede calcular'''
                                                  : 'Precio: \$${(double.tryParse(receta.costoReceta!) ?? 0.0).round()}',
                                              style: TextStyle(
                                                fontSize:
                                                    fontSizeModel.textSize,
                                                color:
                                                    themeModel.primaryTextColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await actualizarConAnimacion(
                                                    context, idReceta);
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.refresh,
                                                  size: fontSizeModel.iconSize,
                                                  color: themeModel
                                                      .primaryButtonColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                              // Muestra la lista de ingredientes
                              ...ingredientes.map((ingrediente) {
                                // Verificar si el costo contiene letras usando una expresión regular
                                bool contieneLetras = RegExp(r'[a-zA-Z]')
                                    .hasMatch(ingrediente.costoIngrediente);

                                // Si el costo no contiene letras, realizar la conversión y redondeo
                                String costoMostrar = contieneLetras
                                    ? ingrediente
                                        .costoIngrediente // Conservar el valor original si contiene letras
                                    : '\$${(double.tryParse(ingrediente.costoIngrediente) ?? 0.0).round()}'; // Redondear si es un número

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical:
                                          10), // Padding para cada ingrediente
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ${ingrediente.nombreIngrediente}', // Nombre del ingrediente
                                        style: TextStyle(
                                          fontSize: fontSizeModel.textSize,
                                          color: themeModel.primaryTextColor,
                                        ),
                                      ),
                                      Text(
                                        'Costo: $costoMostrar', // Muestra el costo basado en la condición
                                        style: TextStyle(
                                          fontSize: fontSizeModel.textSize,
                                          color: themeModel.primaryTextColor,
                                        ),
                                      ),
                                      Divider(
                                        color: themeModel.primaryTextColor,
                                        thickness: 1,
                                        height: 10,
                                      ),
                                      const SizedBox(
                                          height:
                                              8), // Espacio entre ingredientes
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16), // Padding para el botón "Cerrar"
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            backgroundColor: themeModel.primaryButtonColor,
                            foregroundColor: themeModel.primaryTextColor,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el modal
                          },
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              fontSize: fontSizeModel.subtitleSize,
                              color: themeModel.primaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
