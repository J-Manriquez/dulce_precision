import 'package:dulce_precision/database/metodos/gastosFijos_metodos.dart';
import 'package:dulce_precision/database/metodos/metodos_db_dp.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:flutter/material.dart'; // Importamos el paquete de Flutter
import 'package:dulce_precision/utils/custom_logger.dart'; // Importamos el logger para el manejo de errores

class GastosFijosProvider with ChangeNotifier {
  List<GastoFijo> _gastosFijos = []; // Lista privada de gastos fijos
  final GastoFijoRepository _gastoFijoRepository =
      GastoFijoRepository(); // Instancia del repositorio
  final MetodosRepository _metodosRepository =
      MetodosRepository(); // Instancia del repositorio

  // Getter para la lista de gastos fijos
  List<GastoFijo> get gastosFijos => _gastosFijos;

  // Método para obtener todos los gastos fijos desde la base de datos
  Future<void> obtenerGastosFijos() async {
    try {
      _gastosFijos = await _gastoFijoRepository
          .getAllGastosFijos(); // Obtiene los gastos fijos del repositorio
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al obtener gastos fijos: $e');
      throw Exception(
          "Error al obtener gastos fijos"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para agregar un gasto fijo
  Future<void> agregarGastoFijo(GastoFijo gastoFijo) async {
    try {
      await _gastoFijoRepository
          .insertGastoFijo(gastoFijo); // Inserta el gasto fijo
      await obtenerGastosFijos(); // Actualiza la lista después de insertar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al agregar gasto fijo: $e');
      throw Exception(
          "Error al agregar gasto fijo"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar un gasto fijo por su ID
  Future<void> eliminarGastoFijo(int idGF) async {
    try {
      await _gastoFijoRepository
          .eliminarGastoFijo(idGF); // Elimina el gasto fijo
      await obtenerGastosFijos(); // Actualiza la lista después de eliminar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al eliminar gasto fijo con id $idGF: $e');
      throw Exception(
          "Error al eliminar gasto fijo"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para eliminar todo el contenido de la tabla de gastos fijos
  Future<void> eliminarContenidoTablaGastosFijos() async {
    try {
      await _metodosRepository.deleteTableContent(
          'gastosFijos'); // Elimina el contenido de la tabla 'gastosFijos'
      await obtenerGastosFijos(); // Actualiza la lista después de eliminar
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    } catch (e) {
      CustomLogger()
          .logError('Error al eliminar contenido de la tabla gastos fijos: $e');
      throw Exception(
          "Error al eliminar contenido de la tabla gastos fijos"); // Lanzamos una excepción para manejo externo
    }
  }

  // Método para actualizar un gasto fijo
  Future<void> actualizarGastoFijo(GastoFijo gastoFijo) async {
    try {
      await _gastoFijoRepository
          .actualizarGastoFijo(gastoFijo); // Actualiza el gasto fijo en el repositorio
      await obtenerGastosFijos(); // Actualiza la lista después de actualizar
    } catch (e) {
      // Registro de errores usando CustomLogger
      CustomLogger().logError('Error al actualizar gasto fijo con id ${gastoFijo.idGF}: $e');
      throw Exception(
          "Error al actualizar gasto fijo"); // Lanzamos una excepción para manejo externo
    }
  }
}
