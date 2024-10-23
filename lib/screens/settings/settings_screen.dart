import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/font_size_model.dart'; // Importamos el modelo de tamaño de fuente
import '../../models/theme_model.dart'; // Importamos el modelo de tema
import 'themes_screen.dart'; // Importamos la pantalla de temas
import 'font_settings_screen.dart'; // Importamos la pantalla de configuración de fuentes
import 'user_data_screen.dart'; // Asegúrate de importar la pantalla de datos del usuario

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeModel = Provider.of<FontSizeModel>(
        context); // Obtenemos el modelo de tamaño de fuente
    final themeModel =
        Provider.of<ThemeModel>(context); // Obtenemos el modelo de tema

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
                'Configuración',
                style: TextStyle(
                  fontSize:
                      fontSizeModel.titleSize, // Tamaño dinámico para subtítulo
                  color:
                      themeModel.primaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        backgroundColor:
            themeModel.primaryButtonColor, // Color dinámico del AppBar
      ),
      body: Container(
        color: themeModel.backgroundColor, // Fondo dinámico
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Subtítulo principal
              Text(
                'Usuario',
                style: TextStyle(
                  fontSize: fontSizeModel.subtitleSize, // Subtítulo dinámico
                  color:
                      themeModel.secondaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              // Rediseñando los primeros 4 botones en dos filas
              GridView.count(
                shrinkWrap:
                    true, // Permite que el GridView se ajuste a su contenido
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 1, // Relación de aspecto cuadrado
                crossAxisSpacing: 16.0, // Espaciado horizontal entre botones
                mainAxisSpacing: 16.0, // Espaciado vertical entre botones
                children: [
                  // Primer botón: Navega a user_data_screen.dart
                  _buildButton(
                    context,
                    label: 'Datos de Usuario',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserDataScreen()),
                      );
                    },
                  ),
                  // Segundo botón: Vacío por ahora
                  _buildButton(
                    context,
                    label: 'Botón Vacío 1',
                    onPressed: () {
                      // No hace nada por ahora
                    },
                  ),
                  // Tercer botón: Vacío por ahora
                  _buildButton(
                    context,
                    label: 'Botón Vacío 2',
                    onPressed: () {
                      // No hace nada por ahora
                    },
                  ),
                  // Cuarto botón: Vacío por ahora
                  _buildButton(
                    context,
                    label: 'Botón Vacío 3',
                    onPressed: () {
                      // No hace nada por ahora
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Subtítulo "Apariencia"
              Text(
                'Apariencia',
                style: TextStyle(
                  fontSize: fontSizeModel
                      .subtitleSize, // Tamaño dinámico para subtítulo
                  color:
                      themeModel.secondaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              // Dos botones adicionales relacionados con "Apariencia"
              GridView.count(
                shrinkWrap: true, // Ajuste automático del GridView
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 1, // Relación de aspecto cuadrado
                crossAxisSpacing: 16.0, // Espaciado horizontal entre botones
                mainAxisSpacing: 16.0, // Espaciado vertical entre botones
                children: [
                  // Botón 1: Navega a themes_screen.dart
                  _buildButton(
                    context,
                    label: 'Cambiar Colores',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ThemesScreen()),
                      );
                    },
                  ),
                  // Botón 2: Navega a font_settings_screen.dart
                  _buildButton(
                    context,
                    label: 'Cambiar Tamaños',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FontSettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Subtítulo "Apariencia"
              Text(
                'Extra',
                style: TextStyle(
                  fontSize: fontSizeModel
                      .subtitleSize, // Tamaño dinámico para subtítulo
                  color:
                      themeModel.secondaryTextColor, // Color dinámico del texto
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              // Dos botones adicionales relacionados con "Apariencia"
              GridView.count(
                shrinkWrap: true, // Ajuste automático del GridView
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 1, // Relación de aspecto cuadrado
                crossAxisSpacing: 16.0, // Espaciado horizontal entre botones
                mainAxisSpacing: 16.0, // Espaciado vertical entre botones
                children: [
                  // Botón 1: Navega a themes_screen.dart
                  _buildButton(
                    context,
                    label: 'Centros Medicos',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => CentrosMedicosScreen()),
                      // );
                    },
                  ),
                  // Botón 2: Navega a font_settings_screen.dart
                  _buildButton(
                    context,
                    label: 'otro',
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const FontSettingsScreen()),
                      // );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir los botones con el diseño cuadrado y esquinas redondeadas
  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    final themeModel = Provider.of<ThemeModel>(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            themeModel.primaryButtonColor, // Color dinámico del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Esquinas redondeadas
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: themeModel.secondaryTextColor, // Color dinámico del texto
          fontSize: Provider.of<FontSizeModel>(context)
              .textSize, // Tamaño dinámico del texto
        ),
        textAlign: TextAlign.center, // Centrar el texto en el botón
      ),
    );
  }
}
