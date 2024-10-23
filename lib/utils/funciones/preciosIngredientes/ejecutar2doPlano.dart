// background_tasks.dart

import 'package:dulce_precision/database/dp_db.dart'; // Importa las dependencias necesarias
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/ingredientesCalcularCostos.dart';
import 'package:dulce_precision/utils/funciones/preciosRecetas/recetasCalcularCostos.dart';

// Esta función se ejecutará en un Isolate
Future<void> runBackgroundTasks() async {
  CustomLogger().logInfo('Intento de abrir la base de datos y crear tablas');
  
  try {
    // Inicializamos la base de datos
    DatabaseHelper databaseHelper = DatabaseHelper(); // Aquí se llama a la base de datos
    await databaseHelper.database; // Asegura que la base de datos esté inicializada
  } catch (e) {
    CustomLogger().logError('Error al inicializar la base de datos: $e');
    return; // Termina la ejecución si hay un error
  }

  // Actualiza los costos de los ingredientes y las recetas
  await actualizarCostosAllIngredientes();
  await calcularCostoCadaRecetas();
}
