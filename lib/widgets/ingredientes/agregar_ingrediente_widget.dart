import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import '../tipo_unidad_dropdown.dart';
import 'package:dulce_precision/models/theme_model.dart'; // Importamos el modelo de tema
import 'package:dulce_precision/models/font_size_model.dart'; // Importamos el modelo de tamaños de fuente
import 'package:provider/provider.dart'; // Importa Provider

class AgregarIngredientesWidget extends StatefulWidget {
  const AgregarIngredientesWidget({super.key});

  @override
  AgregarIngredientesWidgetState createState() => AgregarIngredientesWidgetState();
}

class AgregarIngredientesWidgetState extends State<AgregarIngredientesWidget> {
  List<Map<String, dynamic>> _ingredientes = [];

  void _agregarIngrediente() {
    setState(() {
      _ingredientes.add({
        'nombre': '',
        'cantidad': '',
        'tipoUnidad': 'unidad',
      });
    });
  }

  void _eliminarIngrediente(int index) {
    setState(() {
      _ingredientes.removeAt(index);
    });
  }

  void _actualizarIngrediente(int index, String key, String value) {
  setState(() {
    _ingredientes[index][key] = value;
    CustomLogger().logInfo('tipo unidad, Ingrediente actualizado: ${_ingredientes[index]}');

  });
}

  void actualizarIngredientesExistentes(List<Map<String, dynamic>> ingredientes) {
    setState(() {
      _ingredientes = ingredientes;
    });
  }

  // New method to retrieve ingredients
  List<Map<String, dynamic>> obtenerIngredientes() {
    return _ingredientes;
  }

  // New method to clear ingredients
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
        ElevatedButton(
          onPressed: _agregarIngrediente,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 40),
            backgroundColor: themeModel.secondaryButtonColor.withOpacity(0.5),
            foregroundColor: themeModel.primaryTextColor,
            textStyle: TextStyle(
              fontSize: fontSizeModel.subtitleSize,
              color: themeModel.primaryTextColor,
            ),
          ),
          child: Text('Añadir Ingrediente'),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _ingredientes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Nombre del Ingrediente',
                            labelStyle: TextStyle(
                              color: _ingredientes[index]['nombre'].isEmpty
                                  ? themeModel.secondaryTextColor // Color del label cuando no hay texto
                                  : themeModel.secondaryTextColor, // Color del label cuando hay texto
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: themeModel.secondaryButtonColor.withOpacity(0.5), // Color del borde cuando está enfocado
                                width: 3.0, // Grosor del borde
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: themeModel.secondaryTextColor, // Color del borde cuando está habilitado
                                width: 1.0, // Grosor del borde
                              ),
                            ),
                          ),
                          onChanged: (value) => _actualizarIngrediente(index, 'nombre', value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: themeModel.secondaryButtonColor.withOpacity(0.6)),
                        onPressed: () => _eliminarIngrediente(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Cantidad',
                            labelStyle: TextStyle(
                              color: _ingredientes[index]['cantidad'].isEmpty
                                  ? themeModel.secondaryTextColor // Color del label cuando no hay texto
                                  : themeModel.secondaryTextColor, // Color del label cuando hay texto
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: themeModel.secondaryButtonColor.withOpacity(0.5), // Color del borde cuando está enfocado
                                width: 3.0, // Grosor del borde
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: themeModel.secondaryTextColor, // Color del borde cuando está habilitado
                                width: 1.0, // Grosor del borde
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _actualizarIngrediente(index, 'cantidad', value),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TipoUnidadDropdown(
                        initialValue: _ingredientes[index]['tipoUnidad'],
                        onChanged: (value) => _actualizarIngrediente(index, 'tipoUnidad', value),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
