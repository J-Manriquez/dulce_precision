import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/providers/ingredientes_provider.dart';
import 'package:dulce_precision/widgets/ingredientes/agregar_ingrediente_widget.dart';
import 'package:dulce_precision/widgets/tipo_unidad_dropdown.dart';

class EditarIngredientesWidget extends StatefulWidget {
  final int idReceta;

  const EditarIngredientesWidget({super.key, required this.idReceta});

  @override
  EditarIngredientesWidgetState createState() =>
      EditarIngredientesWidgetState();
}

class EditarIngredientesWidgetState extends State<EditarIngredientesWidget> {
  final IngredienteRecetaRepository _ingredienteRepo =
      IngredienteRecetaRepository();
  List<IngredienteReceta> _ingredientes = [];
  final GlobalKey<AgregarIngredientesWidgetState> _agregarIngredientesKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    _cargarIngredientes();
  }

  Future<void> _cargarIngredientes() async {
    try {
      final ingredientes =
          await _ingredienteRepo.getAllIngredientesPorReceta(widget.idReceta);
      setState(() {
        _ingredientes = ingredientes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ingredientes: $e')),
      );
    }
  }

  List<IngredienteReceta> obtenerIngredientesEditados() {
    return _ingredientes;
  }

  List<Map<String, dynamic>> obtenerNuevosIngredientes() {
    return _agregarIngredientesKey.currentState?.obtenerIngredientes() ?? [];
  }

  void limpiarIngredientes() {
    setState(() {
      _ingredientes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        ..._ingredientes
            .map((ingrediente) =>
                _buildIngredienteItem(ingrediente, themeModel, fontSizeModel))
            ,
        const SizedBox(height: 20),
        AgregarIngredientesWidget(key: _agregarIngredientesKey),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildIngredienteItem(IngredienteReceta ingrediente,
      ThemeModel themeModel, FontSizeModel fontSizeModel) {
    final nombreController =
        TextEditingController(text: ingrediente.nombreIngrediente);
    final cantidadController =
        TextEditingController(text: ingrediente.cantidadIngrediente.toString());
    String tipoUnidad = ingrediente.tipoUnidadIngrediente;
    CustomLogger().logInfo('Tipo de Unidad: $tipoUnidad');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _actualizarIngrediente(ingrediente,
                          nombre: nombreController.text);
                    }
                  },
                  child: TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Ingrediente',
                      labelStyle:
                          TextStyle(color: themeModel.secondaryTextColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              themeModel.secondaryButtonColor.withOpacity(0.5),
                          width: 3.0,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: themeModel.secondaryTextColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.remove_circle,
                    color: themeModel.secondaryButtonColor.withOpacity(0.6)),
                onPressed: () =>
                    _eliminarIngrediente(ingrediente.idIngrediente!),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      _actualizarIngrediente(ingrediente,
                          cantidad: double.tryParse(cantidadController.text));
                    }
                  },
                  child: TextField(
                    controller: cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontSize: fontSizeModel.textSize,
                        color: themeModel.secondaryTextColor),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TipoUnidadDropdown(
                  initialValue: tipoUnidad,
                  onChanged: (String newValue) {
                    setState(() {
                      tipoUnidad = newValue;
                      _actualizarIngrediente(ingrediente, tipoUnidad: newValue);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _actualizarIngrediente(IngredienteReceta ingrediente,
      {String? nombre, double? cantidad, String? tipoUnidad}) async {
    final ingredienteActualizado = IngredienteReceta(
      idIngrediente: ingrediente.idIngrediente,
      nombreIngrediente: nombre ?? ingrediente.nombreIngrediente,
      costoIngrediente: ingrediente.costoIngrediente,
      cantidadIngrediente: cantidad ?? ingrediente.cantidadIngrediente,
      tipoUnidadIngrediente: tipoUnidad ?? ingrediente.tipoUnidadIngrediente,
      idReceta: ingrediente.idReceta,
    );

    try {
      await Provider.of<IngredientesRecetasProvider>(context, listen: false)
          .actualizarIngrediente(ingredienteActualizado);
      // Actualizamos el ingrediente en la lista local
      setState(() {
        final index = _ingredientes.indexWhere(
            (ing) => ing.idIngrediente == ingrediente.idIngrediente);
        if (index != -1) {
          _ingredientes[index] = ingredienteActualizado;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar ingrediente: $e')),
      );
    }
  }

  Future<void> _eliminarIngrediente(int idIngrediente) async {
    try {
      await Provider.of<IngredientesRecetasProvider>(context, listen: false)
          .eliminarIngrediente(idIngrediente);
      await _cargarIngredientes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrediente eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar ingrediente: $e')),
      );
    }
  }
}
