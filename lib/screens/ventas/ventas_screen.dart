import 'package:dulce_precision/screens/modals/verVenta_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/database/providers/ventas_provider.dart'; // Importamos el provider de ventas
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart'; // Para la confirmación genérica
import 'package:dulce_precision/models/font_size_model.dart'; // Modelo para controlar los tamaños de fuente
import 'package:dulce_precision/models/theme_model.dart'; // Modelo para los temas
// Pantalla para agregar ventas

class VentasScreen extends StatefulWidget {
  const VentasScreen({Key? key}) : super(key: key);

  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar las ventas al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VentasProvider>(context, listen: false).obtenerVentas();
    });
  }

  Future<void> _eliminarVenta(BuildContext context, int idVenta) async {
    var mensaje = '¿Estás seguro de que deseas eliminar esta venta?';
    final confirmar = await ConfirmDialog.mostrarConfirmacion(context, mensaje);

    if (confirmar == true) {
      try {
        await Provider.of<VentasProvider>(context, listen: false)
            .eliminarVenta(idVenta);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Venta eliminada con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la venta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context); // Modelo del tema
    final fontSizeModel =
        Provider.of<FontSizeModel>(context); // Modelo de tamaño de fuente
    final ventasProvider =
        Provider.of<VentasProvider>(context); // Proveedor de ventas

    return Scaffold(
      body: Consumer<VentasProvider>(
        builder: (context, provider, child) {
          if (provider.ventas.isEmpty) {
            return Center(
              child: Text(
                'No hay ventas disponibles',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize, // Tamaño de texto dinámico
                  color:
                      themeModel.secondaryTextColor, // Color del texto dinámico
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.ventas.length, // Cantidad de ventas
            itemBuilder: (context, index) {
              final venta =
                  provider.ventas[index]; // Obtener cada venta individualmente

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
                              venta.nombreVenta, // Nombre de la venta
                              style: TextStyle(
                                fontSize: fontSizeModel
                                    .textSize, // Tamaño de texto dinámico
                                color: themeModel
                                    .secondaryTextColor, // Color del texto dinámico
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fecha: ${venta.fechaVenta}', // Fecha de la venta
                              style: TextStyle(
                                fontSize: fontSizeModel
                                    .textSize, // Tamaño de texto dinámico
                                color: themeModel
                                    .secondaryTextColor, // Color del texto dinámico
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Receta: ${venta.productoVenta}', // Producto vendido
                              style: TextStyle(
                                fontSize: fontSizeModel
                                    .textSize, // Tamaño de texto dinámico
                                color: themeModel
                                    .secondaryTextColor, // Color del texto dinámico
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
                              mostrarDetalleVentaModal(context, venta.idVenta!);
                            },
                            child: Text(
                              'Ver',
                              style: TextStyle(
                                fontSize: fontSizeModel
                                    .textSize, // Tamaño de texto dinámico
                                color: themeModel
                                    .secondaryTextColor, // Color del texto dinámico
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              _eliminarVenta(
                                  context, venta.idVenta!); // Eliminar venta
                            },
                            child: Text(
                              'Borrar',
                              style: TextStyle(
                                fontSize: fontSizeModel
                                    .textSize, // Tamaño de texto dinámico
                                color: themeModel
                                    .secondaryTextColor, // Color del texto dinámico
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
