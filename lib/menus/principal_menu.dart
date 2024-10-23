// Archivo: menus/custom_drawer.dart
import 'package:dulce_precision/screens/gatosFijos/gastosFijos_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_model.dart'; // Importa el modelo de tema
import '../models/font_size_model.dart'; // Importa el modelo de tamaños de fuente
import '../screens/settings/settings_screen.dart'; // Importa la pantalla de configuraciones

class PrincipalMenu extends StatelessWidget {
  final List<String> pageTitles; // Lista de títulos de las páginas
  final int selectedIndex; // Índice seleccionado

  const PrincipalMenu({
    super.key,
    required this.pageTitles, // Requiere la lista de títulos de las páginas
    required this.selectedIndex, // Requiere el índice seleccionado
  });

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Drawer(
      backgroundColor: themeModel.backgroundColor, // Color dinámico para el Drawer
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: themeModel.primaryButtonColor, // Color del header del Drawer
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: themeModel.primaryIconColor),
                  iconSize: fontSizeModel.iconSize,
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el Drawer
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  pageTitles[selectedIndex], // Muestra el título de la página seleccionada
                  style: TextStyle(
                    color: themeModel.primaryTextColor, // Color del texto
                    fontSize: fontSizeModel.titleSize, // Tamaño del texto
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.attach_money,
                size: fontSizeModel.iconSize,
                color: themeModel.secondaryIconColor),
            title: Text(
              'Gastos Fijos',
              style: TextStyle(
                color: themeModel.primaryTextColor,
                fontSize: fontSizeModel.textSize,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GastosFijosScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings,
                size: fontSizeModel.iconSize,
                color: themeModel.secondaryIconColor),
            title: Text(
              'Configuraciones',
              style: TextStyle(
                color: themeModel.primaryTextColor,
                fontSize: fontSizeModel.textSize,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info,
                size: fontSizeModel.iconSize,
                color: themeModel.secondaryIconColor),
            title: Text(
              'Acerca de',
              style: TextStyle(
                color: themeModel.primaryTextColor,
                fontSize: fontSizeModel.textSize,
              ),
            ),
            onTap: () {
              // Implementa la navegación a la pantalla "Acerca de"
            },
          ),
        ],
      ),
    );
  }
}
