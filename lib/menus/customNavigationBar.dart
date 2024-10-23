//Archivo: menus/custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart'; // Importa el modelo de tema
import '../models/font_size_model.dart'; // Importa el modelo de tamaños de fuente

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex; // Índice seleccionado
  final Function(int)
      onItemTapped; // Función de callback para la selección de elementos

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex, // Requiere el índice seleccionado
    required this.onItemTapped, // Requiere la función de callback
  });

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business,
              size: fontSizeModel.iconSize), // Tamaño dinámico del ícono
          label: 'Almacen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on,
              size: fontSizeModel.iconSize), // Tamaño dinámico del ícono
          label: 'Ventas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant,
              size: fontSizeModel.iconSize), // Tamaño dinámico del ícono
          label: 'Recetas',
        ),
      ],
      currentIndex: selectedIndex, // Índice actualmente seleccionado
      selectedItemColor:
          themeModel.secondaryButtonColor, // Color del ítem seleccionado
      unselectedItemColor:
          themeModel.primaryIconColor, // Color del ítem no seleccionado
      backgroundColor: themeModel
          .primaryButtonColor, // Color de fondo del BottomNavigationBar
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(
        fontSize: fontSizeModel
            .textSize, // Tamaño del texto para el ítem seleccionado
        color: themeModel.secondaryIconColor,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: fontSizeModel.textSize -
            2, // Tamaño del texto para el ítem no seleccionado
        color: themeModel.primaryIconColor,
      ),
      onTap: onItemTapped, // Llama a la función cuando se selecciona un ítem
    );
  }
}
