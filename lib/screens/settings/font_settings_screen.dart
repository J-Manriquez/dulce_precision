import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/font_size_model.dart';
import '../../models/theme_model.dart'; // Para manejar los colores dinámicos
import '../../widgets/font_size_selector.dart';

class FontSettingsScreen extends StatelessWidget {
  const FontSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos los modelos de tamaño de fuente y tema (colores)
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
     appBar: AppBar(
        leading:  Container(
          alignment: Alignment.center, // Centra el contenido en el contenedor
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: themeModel.primaryIconColor),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () {
              Navigator.of(context).pop(); // Volver a la pantalla anterior
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Tamaño de Textos',
                style: TextStyle(
                  fontSize: fontSizeModel.titleSize, // Tamaño dinámico del título
                  color: themeModel.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: themeModel.primaryButtonColor,
      ),
      body: Container(
        color: themeModel.backgroundColor, // Fondo dinámico
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Agregamos Scroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  fontSizeModel.resetFontSizes(); // Restablecer tamaños
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeModel.primaryButtonColor, // Color del botón
                  minimumSize: Size(double.infinity, 48), // Ancho completo del botón
                ),
                child: Text(
                  'Restablecer tamaños predeterminados',
                  style: TextStyle(
                    fontSize: fontSizeModel.textSize, // Tamaño dinámico
                    color: themeModel.secondaryTextColor, // Color del texto del botón
                  ),
                  textAlign: TextAlign.center, // Centrar el texto
                ),
              ),
              const SizedBox(height: 20),
              
              // Cuadro de muestra de los cambios de tamaño
              Container(
                width: double.infinity, // Ancho completo
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: themeModel.secondaryButtonColor.withOpacity(0.7), // Fondo del cuadro
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrado verticalmente
                  children: [
                    Text(
                      'Título de Ejemplo',
                      style: TextStyle(
                        fontSize: fontSizeModel.titleSize, // Tamaño dinámico del título
                        color: themeModel.secondaryTextColor, // Color del texto dinámico
                      ),
                      textAlign: TextAlign.center, // Centrado horizontalmente
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Subtítulo de Ejemplo',
                      style: TextStyle(
                        fontSize: fontSizeModel.subtitleSize, // Tamaño dinámico del subtítulo
                        color: themeModel.secondaryTextColor, // Color del texto dinámico
                      ),
                      textAlign: TextAlign.center, // Centrado horizontalmente
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Este es un ejemplo de texto.',
                      style: TextStyle(
                        fontSize: fontSizeModel.textSize, // Tamaño dinámico del texto
                        color: themeModel.secondaryTextColor, // Color del texto dinámico
                      ),
                      textAlign: TextAlign.center, // Centrado horizontalmente
                    ),
                    const SizedBox(height: 20),
                    // Row para los íconos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centra los íconos
                      children: [
                        Icon(Icons.home, size: fontSizeModel.iconSize, color: themeModel.secondaryIconColor),
                        const SizedBox(width: 20), // Espacio entre íconos
                        Icon(Icons.favorite, size: fontSizeModel.iconSize, color: themeModel.secondaryIconColor),
                        const SizedBox(width: 20), // Espacio entre íconos
                        Icon(Icons.settings, size: fontSizeModel.iconSize, color: themeModel.secondaryIconColor),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              // Selector para el tamaño del título
              FontSizeSelector(
                label: 'Tamaño del Título',
                currentSize: fontSizeModel.titleSize,
                min: 20.0, // Tamaño mínimo para título
                max: 35.0, // Tamaño máximo para título
                onSizeChanged: (newSize) {
                  fontSizeModel.setTitleSize(newSize);
                },
              ),
              const SizedBox(height: 20),
              // Selector para el tamaño del subtítulo
              FontSizeSelector(
                label: 'Tamaño del Subtítulo',
                currentSize: fontSizeModel.subtitleSize,
                min: 15.0, // Tamaño mínimo para subtítulo
                max: 30.0, // Tamaño máximo para subtítulo
                onSizeChanged: (newSize) {
                  fontSizeModel.setSubtitleSize(newSize);
                },
              ),
              const SizedBox(height: 20),
              // Selector para el tamaño del texto
              FontSizeSelector(
                label: 'Tamaño del Texto',
                currentSize: fontSizeModel.textSize,
                min: 10.0, // Tamaño mínimo para texto
                max: 25.0, // Tamaño máximo para texto
                onSizeChanged: (newSize) {
                  fontSizeModel.setTextSize(newSize);
                },
              ),
              const SizedBox(height: 20),
              // Selector para el tamaño de los íconos
              FontSizeSelector(
                label: 'Tamaño de los Íconos',
                currentSize: fontSizeModel.iconSize,
                min: 20.0, // Tamaño mínimo para íconos
                max: 50.0, // Tamaño máximo para íconos
                onSizeChanged: (newSize) {
                  fontSizeModel.setIconSize(newSize); // Asegúrate de que setIconSize esté definido
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
