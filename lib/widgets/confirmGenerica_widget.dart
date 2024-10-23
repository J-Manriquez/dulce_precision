import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';

// Clase para mostrar un cuadro de confirmación genérico
class ConfirmDialog {
  // Método genérico para mostrar un modal de confirmación
  static Future<bool> mostrarConfirmacion(
      BuildContext context, String mensaje) async {
    // Obtener los modelos de tema y tamaño de fuente a través del Provider
    final themeModel = Provider.of<ThemeModel>(context, listen: false);
    final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

    // Mostrar el cuadro de diálogo y esperar la respuesta
    return await showDialog<bool>(
          context: context,
          builder: (context) => Dialog(
            // Contenedor principal del cuadro de diálogo
            child: Container(
              decoration: BoxDecoration(
                color: themeModel.backgroundColor, // Color de fondo del cuadro de diálogo
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Espaciado interno
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Tamaño mínimo ajustado al contenido
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Expandir en horizontal
                  children: [
                    // Título del cuadro de diálogo
                    Text(
                      'Confirmación', // Título fijo
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeModel.titleSize, // Tamaño de fuente del título
                        color: themeModel.primaryTextColor, // Color del texto
                      ),
                    ),
                    const SizedBox(height: 10), // Espaciado entre el título y el mensaje
                    // Mensaje de confirmación pasado como parámetro
                    Center(
                      child: Text(
                        mensaje, // Texto personalizado
                        style: TextStyle(
                          fontSize: fontSizeModel.textSize, // Tamaño de fuente del mensaje
                          color: themeModel.primaryTextColor, // Color del texto
                        ),
                        textAlign: TextAlign.center, // Centrar el texto
                      ),
                    ),
                    const SizedBox(height: 20), // Espaciado entre el mensaje y los botones
                    // Fila de botones para cancelar o confirmar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado uniforme
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Botón de "Cancelar"
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: themeModel.primaryButtonColor, // Color de fondo
                              foregroundColor: themeModel.primaryTextColor, // Color del texto
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: fontSizeModel.subtitleSize, // Tamaño de fuente del botón
                              ),
                            ),
                            // Al presionar, se cierra el cuadro de diálogo y retorna false
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ),
                        const SizedBox(width: 10), // Separación entre los botones
                        // Botón de "Confirmar"
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: themeModel.primaryTextColor, // Color de fondo
                              foregroundColor: themeModel.primaryButtonColor, // Color del texto
                            ),
                            child: Text(
                              'Confirmar',
                              style: TextStyle(
                                fontSize: fontSizeModel.subtitleSize, // Tamaño de fuente del botón
                              ),
                            ),
                            // Al presionar, se cierra el cuadro de diálogo y retorna true
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ) ??
        false; // Retorna false si se cierra el cuadro de diálogo sin selección
  }
}
