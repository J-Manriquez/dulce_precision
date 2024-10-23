import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';
import '../../models/font_size_model.dart';
import '../../widgets/settings/color_picker_widget.dart'; // Importa el widget de selección de color

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos los modelos de tema y tamaño de fuente desde Provider
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: themeModel.primaryIconColor),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Colores',
                style: TextStyle(
                  fontSize: fontSizeModel.titleSize, // Tamaño dinámico del título
                  color: themeModel.primaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        backgroundColor: themeModel.primaryButtonColor, // Color dinámico del AppBar
      ),
      body: Container(
        color: themeModel.backgroundColor, // Fondo dinámico
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [// Botón para Tema Claro
              ElevatedButton(
                onPressed: () {
                  themeModel.setLightTheme(); // Seleccionar el tema claro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeModel.primaryButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'Tema Claro',
                  style: TextStyle(
                    fontSize: fontSizeModel.textSize,
                    color: themeModel.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Botón para Tema Oscuro
              ElevatedButton(
                onPressed: () {
                  themeModel.setDarkTheme(); // Seleccionar el tema oscuro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeModel.primaryButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'Tema Oscuro',
                  style: TextStyle(
                    fontSize: fontSizeModel.textSize,
                    color: themeModel.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Botón para Tema Personalizado
              ElevatedButton(
                onPressed: () {
                  themeModel.setCustomTheme(); // Seleccionar el tema personalizado
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeModel.primaryButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  'Tema Personalizado',
                  style: TextStyle(
                    fontSize: fontSizeModel.textSize,
                    color: themeModel.secondaryTextColor,
                  ),
                ),
              ),
              // Selector de color de fondo
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Fondo', // Indicamos que el color es para el fondo
                  selectedColor: themeModel.backgroundColor,
                  onColorChanged: (newColor) {
                    themeModel.setBackgroundColor(newColor); // Actualizar color de fondo
                  },
                ),
              ),  
              // Selector de color de botón principal
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Botón principal',
                  selectedColor: themeModel.primaryButtonColor,
                  onColorChanged: (newColor) {
                    themeModel.setPrimaryButtonColor(newColor); // Actualizar botón principal
                  },
                ),
              ),
              // Selector de color de botón secundario
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Botón secundario',
                  selectedColor: themeModel.secondaryButtonColor,
                  onColorChanged: (newColor) {
                    themeModel.setSecondaryButtonColor(newColor); // Actualizar botón secundario
                  },
                ),
              ),  
              // Selector de color de texto principal
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Texto principal',
                  selectedColor: themeModel.primaryTextColor,
                  onColorChanged: (newColor) {
                    themeModel.setPrimaryTextColor(newColor); // Actualizar color de texto principal
                  },
                ),
              ),   
              // Selector de color de texto secundario
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Texto secundario',
                  selectedColor: themeModel.secondaryTextColor,
                  onColorChanged: (newColor) {
                    themeModel.setSecondaryTextColor(newColor); // Actualizar color de texto secundario
                  },
                ),
              ),
              // Selector de color de ícono principal
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Icono principal',
                  selectedColor: themeModel.primaryIconColor,
                  onColorChanged: (newColor) {
                    themeModel.setPrimaryIconColor(newColor); // Actualizar color del ícono principal
                  },
                ),
              ),
              // Selector de color de ícono secundario
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: themeModel.primaryButtonColor, // Fondo negro
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ColorPickerWidget(
                  optionName: 'Icono secundario',
                  selectedColor: themeModel.secondaryIconColor,
                  onColorChanged: (newColor) {
                    themeModel.setSecondaryIconColor(newColor); // Actualizar color del ícono secundario
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
