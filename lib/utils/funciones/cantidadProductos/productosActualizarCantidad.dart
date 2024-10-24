import 'package:flutter/material.dart'; // Importación para BuildContext
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/utils/funciones/cantidadProductos/nombresCompararPyI.dart';
import 'package:dulce_precision/utils/funciones/cantidadProductos/tipoUnidadRestar.dart';

// Función principal para ejecutar las comparaciones y procesar los resultados
Future<void> actualizarCantidadProductos(int idReceta, BuildContext context) async {
  try {
    CustomLogger().logInfo('COMPARANDO NOMBRES PARA ACTUALIZAR CANTIDAD DE PRODUCTOS');
    // Paso 1: Comparar nombres y obtener las coincidencias
    List<Map<String, String>> coincidencias =
        await compararNombresPyI(idReceta);

    CustomLogger().logInfo('COMPARANDO TIPO DE UNIDAD Y RESTANDO CANTIDAD DE PRODUCTOS');
    // Paso 2: Comparar tipos de unidad utilizando las coincidencias
    await verificarYActualizarProductos(coincidencias, context);
    
    // Opción: Manejo de éxito
    CustomLogger().logInfo('Procesamiento completado exitosamente.');
  } catch (e) {
    // Manejo de errores
    CustomLogger().logError('Error durante el procesamiento de ingredientes: $e');
  }
}
