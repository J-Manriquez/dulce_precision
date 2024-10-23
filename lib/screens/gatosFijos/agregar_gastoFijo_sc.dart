import 'package:dulce_precision/database/providers/gastosFijos_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';

class InsertarGastosFijosScreen extends StatefulWidget {
  final GastoFijo? gastoFijo;

  const InsertarGastosFijosScreen({super.key, this.gastoFijo});

  @override
  _InsertarGastosFijosScreenState createState() =>
      _InsertarGastosFijosScreenState();
}

class _InsertarGastosFijosScreenState extends State<InsertarGastosFijosScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  
  GastoFijo? _gastoFijoOriginal; // Variable para almacenar el gasto fijo original

  @override
  void initState() {
    super.initState();
    if (widget.gastoFijo != null) {
      // Guardar una copia original del gasto fijo
      _gastoFijoOriginal = GastoFijo(
        idGF: widget.gastoFijo!.idGF,
        nombreGF: widget.gastoFijo!.nombreGF,
        valorGF: widget.gastoFijo!.valorGF,
      );

      // Llenar los campos con los datos del gasto fijo
      _nombreController.text = widget.gastoFijo!.nombreGF;
      _montoController.text = widget.gastoFijo!.valorGF.toString();
    }
  }

  Future<void> _guardarGastoFijo() async {
    final gastosFijosProvider =
        Provider.of<GastosFijosProvider>(context, listen: false);

    if (_nombreController.text.isEmpty || _montoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final double? montoGastoFijo = double.tryParse(_montoController.text);
    if (montoGastoFijo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un valor numérico válido.')),
      );
      return;
    }

    final gastoFijo = GastoFijo(
      idGF: widget.gastoFijo?.idGF, // Usa el ID del gasto fijo si existe
      nombreGF: _nombreController.text,
      valorGF: montoGastoFijo,
    );

    try {
      if (widget.gastoFijo == null) {
        // Si es un nuevo gasto fijo, lo agrega
        await gastosFijosProvider.agregarGastoFijo(gastoFijo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gasto fijo insertado con éxito!')),
        );
      } else {
        // Si es un gasto fijo existente, lo actualiza
        await gastosFijosProvider.actualizarGastoFijo(gastoFijo); // Asegúrate de tener este método
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gasto fijo actualizado con éxito!')),
        );
      }

      // Limpiar campos después de guardar
      _nombreController.clear();
      _montoController.clear();
      Navigator.of(context).pop(); // Regresar a la pantalla anterior
    } catch (e) {
      CustomLogger().logError('Error al guardar el gasto fijo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el gasto fijo: $e')),
      );
    }
  }

  Future<bool> _confirmarSalida() async {
    // Muestra un diálogo de confirmación antes de salir
    return await ConfirmDialog.mostrarConfirmacion(
      context,
      '''No se aplicarán cambios al gasto
¿Está seguro de que desea volver sin guardar?'''
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return WillPopScope(
      onWillPop: () async {
        // Manejamos la acción de volver atrás
        if (_gastoFijoOriginal != null &&
            (_nombreController.text != _gastoFijoOriginal!.nombreGF ||
            _montoController.text != _gastoFijoOriginal!.valorGF.toString())) {
          // Si hay cambios, confirmamos la salida
          return await _confirmarSalida();
        }
        return true; // Permitir la salida
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.gastoFijo == null ? 'Agregar Gasto Fijo' : 'Editar Gasto Fijo',
            style: TextStyle(
              fontSize: fontSizeModel.titleSize,
              color: themeModel.primaryTextColor,
            ),
          ),
          backgroundColor: themeModel.primaryButtonColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _guardarGastoFijo,
              color: themeModel.primaryTextColor,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del Gasto Fijo'),
              ),
              TextField(
                controller: _montoController,
                decoration: const InputDecoration(labelText: 'Monto del Gasto Fijo'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
