import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/nombresComparar.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/tipoUnidadComparar.dart';

// Función principal para ejecutar las comparaciones y procesar los resultados
Future<void> actualizarCostosAllIngredientes() async {
  try {
    CustomLogger().logInfo('COMPARANDO NOMBRES');
    // Paso 1: Comparar nombres y obtener las coincidencias
    // await Future.delayed(Duration(seconds: 2));
    List<Map<String, String>> coincidencias = await compararNombres();

    CustomLogger().logInfo('COMPARANDO TIPO DE UNIDAD');
    // Paso 2: Comparar tipos de unidad utilizando las coincidencias
    // await Future.delayed(Duration(seconds: 2));
    List<Map<String, dynamic>> resultadosTipoUnidad =
        await compararTipoUnidad(coincidencias);

    CustomLogger().logInfo('PROCESANDO RESULTADOS');
    // Paso 3: Procesar los resultados obtenidos
    // await Future.delayed(Duration(seconds: 2));
    await procesarResultados(resultadosTipoUnidad);

    // Opción: Manejo de éxito
    print('Procesamiento completado exitosamente.');
  } catch (e) {
    // Manejo de errores
    print('Error durante el procesamiento de ingredientes: $e');
  }
}

// Función para procesar los resultados de comparación de tipos de unidad
Future<IngredienteReceta?> procesarResultados(
    List<Map<String, dynamic>> resultados) async {
  final ingredienteRecetaRepository =
      IngredienteRecetaRepository(); // Crear instancia del repositorio de ingredientes

  // Recorremos cada mapa en la lista de resultados
  for (var resultado in resultados) {
    // Obtenemos el id del ingrediente desde el mapa
    int idIngrediente = resultado['idIngrediente'];

    // Obtenemos el ingrediente usando su ID
    IngredienteReceta ingrediente =
        await ingredienteRecetaRepository.getIngredienteById(idIngrediente);
    // return ingrediente; // Retornamos el ingrediente

    // Crear un objeto IngredienteReceta con los datos que deseas actualizar
    IngredienteReceta ingredienteReceta = IngredienteReceta(
        idIngrediente: ingrediente
            .idIngrediente, // ID del ingrediente que deseas actualizar
        nombreIngrediente:
            ingrediente.nombreIngrediente, // Nuevo nombre del ingrediente
        costoIngrediente: "${resultado['costoIngrediente']}", // Nuevo costo
        cantidadIngrediente: ingrediente.cantidadIngrediente, // Nueva cantidad
        tipoUnidadIngrediente:
            ingrediente.tipoUnidadIngrediente, // Nueva unidad
        idReceta:
            ingrediente.idReceta // ID de la receta asociada (si es aplicable)
        );

    try {
      // Llamamos a la función para actualizar el ingrediente
      await ingredienteRecetaRepository
          .actualizarIngrediente(ingredienteReceta);
    } catch (e) {
      // Manejo de errores
      print('Error al actualizar compatible del ingrediente: $e');
    }

    // Retornamos el ingrediente
  }
  return null;
}
