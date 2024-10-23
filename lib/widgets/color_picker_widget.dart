import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para obtener los modelos dinámicos
import '../models/theme_model.dart'; // Importa el modelo de tema
import '../models/font_size_model.dart'; // Importa el modelo de tamaño de fuente

class ColorPickerWidget extends StatefulWidget {
  final String optionName; // Nombre de la opción para usar en el texto
  final Color selectedColor; // Color seleccionado
  final ValueChanged<Color> onColorChanged; // Callback al cambiar de color

  const ColorPickerWidget({
    Key? key,
    required this.optionName, // Recibe el nombre de la opción como parámetro
    required this.selectedColor, // Recibe el color seleccionado
    required this.onColorChanged, // Recibe la función para cambiar el color
  }) : super(key: key);

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  bool _isExpanded = false; // Controla si se expanden los colores adicionales

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tema y los tamaños dinámicos
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    // Definimos los colores a mostrar (24 en total)
    final colors = [
      Color.fromRGBO(245, 245, 245, 1), // Pastel claro
      Color.fromRGBO(190, 190, 190, 1), // Tono central brillante
      Color.fromRGBO(30, 30, 30, 1),    // Más oscuro

      // Tonalidades de rojo
      Color.fromRGBO(255, 164, 163, 1), // Pastel claro
      Color.fromRGBO(226, 107, 105, 1),   // Tono central brillante
      Color.fromRGBO(203, 40, 40, 1),     // Más oscuro

      // Tonalidades de amarillo
      Color.fromRGBO(255, 255, 194, 1), // Pastel claro
      Color.fromRGBO(255, 255, 102, 1), // Tono central brillante
      Color.fromRGBO(243, 243, 0, 1),   // Más oscuro

      // Tonalidades de morado
      Color.fromRGBO(240, 170, 255, 1), // Pastel claro
      Color.fromRGBO(165, 100, 230, 1),  // Tono central brillante
      Color.fromRGBO(100, 30, 120, 1),   // Más oscuro

      // Tonalidades de naranja
      Color.fromRGBO(255, 204, 153, 1), // Pastel claro
      Color.fromRGBO(255, 140, 0, 1),   // Tono central brillante
      Color.fromRGBO(225, 142, 2, 1),   // Más oscuro

      // Tonalidades de azul
      Color.fromRGBO(151, 206, 224, 1), // Pastel claro
      Color.fromRGBO(65, 135, 192, 1),  // Tono central brillante
      Color.fromRGBO(0, 108, 161, 1),     // Más oscuro

      // Tonalidades de café
      Color.fromRGBO(211, 177, 150, 1), // Pastel claro
      Color.fromRGBO(150, 105, 30, 1),  // Tono central brillante
      Color.fromRGBO(109, 82, 61, 1),   // Más oscuro

      // Tonalidades de verde
      Color.fromRGBO(159, 221, 159, 1), // Pastel claro
      Color.fromRGBO(110, 199, 110, 1),   // Tono central brillante
      Color.fromRGBO(35, 109, 35, 1),     // Más oscuro
    ];

    // Definimos cuántos colores mostrar en la primera fila (6)
    final visibleColors = _isExpanded ? colors : colors.sublist(0, 6);

    return Container(
      padding: const EdgeInsets.all(8.0), // Añade padding
      decoration: BoxDecoration(
        color: themeModel.primaryButtonColor, // Fondo dinámico
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto al inicio
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea texto e icono en los extremos
            children: [
              // Texto dinámico con el nombre de la opción
              Text(
                '${widget.optionName}:',
                style: TextStyle(
                  fontSize: fontSizeModel.subtitleSize, // Tamaño dinámico del texto
                  color: themeModel.secondaryTextColor, // Color dinámico del texto
                ),
              ),
              // Icono "+" o "-" según el estado de expansión
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.remove : Icons.add, // Cambia el ícono
                  size: fontSizeModel.iconSize, // Tamaño dinámico del ícono
                  color: themeModel.secondaryTextColor, // Color dinámico del ícono
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // Alterna entre expandir y contraer
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10), // Añade espacio
          // Grid para mostrar los colores
          GridView.builder(
            shrinkWrap: true, // Limita el tamaño del grid
            physics: const NeverScrollableScrollPhysics(), // Deshabilita scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // Define 6 columnas
              crossAxisSpacing: 10, // Espacio entre colores
              mainAxisSpacing: 10, // Espacio entre filas
              childAspectRatio: 1, // Hace que las celdas sean cuadradas
            ),
            itemCount: visibleColors.length, // Muestra la cantidad correcta de colores
            itemBuilder: (context, index) {
              final color = visibleColors[index];
              return _buildColorCircle(color); // Llama al método para crear círculos de color
            },
          ),
        ],
      ),
    );
  }

  // Método para construir un círculo de color seleccionable
  Widget _buildColorCircle(Color color) {
    // Verifica si el color está seleccionado
    final bool isSelected = widget.selectedColor == color;

    return GestureDetector(
      onTap: () => widget.onColorChanged(color), // Cambia el color seleccionado
      child: Stack( // Usa un Stack para superponer el check
        alignment: Alignment.center, // Centra los widgets en el Stack
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Hace que el contenedor sea un círculo
              color: isSelected ? color.withOpacity(0.5) : color, // Si está seleccionado, reduce la opacidad
              border: Border.all(
                color: const Color.fromARGB(85, 0, 0, 0), // Todos los círculos tienen borde negro
                width: isSelected ? 3 : 1, // El borde es más grueso si está seleccionado
              ),
            ),
          ),
          // Si está seleccionado, muestra un ícono de verificación
          if (isSelected)
            const Icon(
              Icons.check, // Ícono de verificación
              color: Color.fromARGB(255, 131, 245, 0), // Color verde claro
              size: 20, // Tamaño del ícono
            ),
        ],
      ),
    );
  }
}
