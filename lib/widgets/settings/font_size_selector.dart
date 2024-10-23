import 'package:dulce_precision/models/font_size_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/theme_model.dart';

class FontSizeSelector extends StatelessWidget {
  final String label;
  final double currentSize;
  final double min; // Tamaño mínimo
  final double max; // Tamaño máximo
  final ValueChanged<double> onSizeChanged;

  const FontSizeSelector({
    super.key,
    required this.label,
    required this.currentSize,
    required this.min,
    required this.max,
    required this.onSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Obtenemos los modelos de tamaño de fuente y tema (colores)
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: fontSizeModel.textSize, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: currentSize,
          min: min, // Utilizar el tamaño mínimo proporcionado
          max: max, // Utilizar el tamaño máximo proporcionado
          divisions: (max - min).toInt(), // Divisiones basadas en rango
          label: currentSize.toString(),
          activeColor: themeModel.primaryButtonColor,
          onChanged: onSizeChanged,
        ),
      ],
    );
  }
}
