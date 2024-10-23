import 'package:dulce_precision/database/providers/gastosFijos_provider.dart';
import 'package:dulce_precision/menus/menuGastosFijos.dart';
import 'package:dulce_precision/screens/gatosFijos/agregar_gastoFijo_sc.dart';
import 'package:dulce_precision/utils/funciones/aparienciaText_funciones.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';

class GastosFijosScreen extends StatefulWidget {
  const GastosFijosScreen({super.key});

  @override
  _GastosFijosScreenState createState() => _GastosFijosScreenState();
}

class _GastosFijosScreenState extends State<GastosFijosScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar los gastos fijos al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GastosFijosProvider>(context, listen: false).obtenerGastosFijos();
    });
  }

  Future<void> _eliminarGastoFijo(BuildContext context, int idGastoFijo) async {
    var mensaje = '¿Estás seguro de que deseas eliminar este gasto fijo?';
    final confirmar = await ConfirmDialog.mostrarConfirmacion(context, mensaje);

    if (confirmar == true) {
      try {
        await Provider.of<GastosFijosProvider>(context, listen: false)
            .eliminarGastoFijo(idGastoFijo);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gasto fijo eliminado con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el gasto fijo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final gastosFijosProvider = Provider.of<GastosFijosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeModel.primaryButtonColor,
        title: Text(
          'Gastos Fijos',
          style: TextStyle(
            fontSize: fontSizeModel.titleSize,
            color: themeModel.primaryTextColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: fontSizeModel.iconSize,
              color: themeModel.primaryIconColor,
            ),
            onPressed: () async {
              // Navegar a la pantalla para insertar un nuevo gasto fijo
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsertarGastosFijosScreen(),
                ),
              ).then((_) => gastosFijosProvider.obtenerGastosFijos());
            },
          ),
          MenuGastosFijos()
        ],
      ),
      backgroundColor: themeModel.primaryTextColor, // Fondo dinámico
      body: Consumer<GastosFijosProvider>(
        builder: (context, provider, child) {
          if (provider.gastosFijos.isEmpty) {
            return Center(
              child: Text(
                'No hay gastos fijos disponibles',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.gastosFijos.length,
            itemBuilder: (context, index) {
              final gastoFijo = provider.gastosFijos[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mayuscPrimeraLetra(gastoFijo.nombreGF),
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Monto: \$${gastoFijo.valorGF.round()}',
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navegar a la pantalla de edición
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsertarGastosFijosScreen(
                                      gastoFijo: gastoFijo),
                                ),
                              ).then((_) => gastosFijosProvider.obtenerGastosFijos());
                            },
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              _eliminarGastoFijo(context, gastoFijo.idGF!);
                            },
                            child: Text(
                              'Borrar',
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
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
          );
        },
      ),
    );
  }
}
