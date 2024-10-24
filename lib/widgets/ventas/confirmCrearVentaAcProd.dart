import 'package:dulce_precision/main.dart';
import 'package:dulce_precision/screens/ventas/ventas_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/utils/funciones/cantidadProductos/productosActualizarCantidad.dart'; // Importa la función actualizarCantidadProductos
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';

class ConfirmarActualizacionProductosDialog {
  static Future<void> mostrarModal(BuildContext context, int idReceta,
      Future<void> Function() guardarVenta) async {
    bool _confirmacion = false;

    // Obtener los modelos de tema y tamaño de fuente a través del Provider
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Bordes redondeados
            ),
            child: Container(
              decoration: BoxDecoration(
                color: themeModel
                    .backgroundColor, // Color de fondo del cuadro de diálogo
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              padding: const EdgeInsets.all(16.0), // Espaciado interno
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
                children: [
                  Text(
                    'Crear Venta', // Título del cuadro
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeModel
                          .titleSize, // Tamaño de fuente del título
                      color: themeModel
                          .primaryTextColor, // Color del texto del título
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Espaciado entre el título y el mensaje
                  Text(
                    'Al confirmar, se creará la venta con los datos ingresados.\n\nPuedes actualizar las cantidades de productos si lo deseas marcando la casilla y confirmando.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: fontSizeModel
                          .textSize, // Tamaño de fuente del mensaje
                      color: themeModel
                          .primaryTextColor, // Color del texto del mensaje
                    ),
                  ),
                  const SizedBox(
                      height:
                          20), // Espaciado entre el mensaje y la confirmación
                  Row(
                    children: [
                      Transform.scale(
                        scale: fontSizeModel.iconSize * 0.06,
                        child: Checkbox(
                          value: _confirmacion,
                          onChanged: (bool? value) {
                            setState(() {
                              _confirmacion = value ?? false;
                            });
                          },
                          activeColor: themeModel
                              .primaryButtonColor, // Cambia esto al color que prefieras
                          checkColor: themeModel.primaryTextColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Restar cantidades de ingredientes a cantidades de productos',
                          softWrap: true,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: fontSizeModel.textSize,
                            color: themeModel.primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height:
                          20), // Espaciado entre la confirmación y los botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: themeModel
                                .primaryButtonColor, // Color del botón
                            foregroundColor: themeModel
                                .primaryTextColor, // Color del texto del botón
                          ),
                          onPressed: () => Navigator.of(context)
                              .pop(), // Acción del botón de cancelar
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: fontSizeModel
                                  .subtitleSize, // Tamaño de fuente del botón
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10), // Separación entre botones
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: themeModel
                                .primaryTextColor, // Color del botón de confirmar
                            foregroundColor: themeModel
                                .primaryButtonColor, // Color del texto del botón
                          ),
                          onPressed: _confirmacion
                              ? () async {
                                  await actualizarCantidadProductos(idReceta,
                                      context); // Ejecuta la función de actualización
                                  guardarVenta(); // Ejecuta la función guardarVenta
                                  // Navigator.of(context)
                                  //     .pop(); // Cierra el modal
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const MainScreen(),
                                    ),
                                  );
                                }
                              : guardarVenta, // Desactiva si no está confirmada la acción
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: fontSizeModel
                                  .subtitleSize, // Tamaño de fuente del botón
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
