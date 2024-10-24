import 'package:dulce_precision/database/insertar_repositorio.dart';
import 'package:dulce_precision/utils/funciones/aparienciaText_funciones.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/screens/productos/agregar_producto_sc.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/database/providers/productos_provider.dart'; // Import the ProductosProvider

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductosProvider>(context, listen: false).obtenerProductos();
    });
  }

  Future<void> _eliminarProducto(BuildContext context, int idProducto) async {
    var msj = '¿Estás seguro de que deseas eliminar este producto?';
    final confirmar = await ConfirmDialog.mostrarConfirmacion(context, msj);

    if (confirmar == true) {
      try {
        await Provider.of<ProductosProvider>(context, listen: false)
            .eliminarProducto(idProducto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto eliminado con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el producto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final productosProvider = Provider.of<ProductosProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeModel.primaryButtonColor,
        // title: Text(
        //   '',
        //   style: TextStyle(
        //     fontSize: fontSizeModel.titleSize,
        //     color: themeModel.primaryTextColor,
        //   ),
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: fontSizeModel.iconSize,
              color: themeModel.primaryIconColor,
            ),
            onPressed: () async {
              await insertarRepositorio(context);
            },
          ),
        ],
      ),
      backgroundColor: themeModel.primaryTextColor, // Fondo dinámico
      body: Consumer<ProductosProvider>(
        builder: (context, provider, child) {
          if (provider.productos.isEmpty) {
            return Center(
              child: Text(
                'No hay productos disponibles',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.secondaryTextColor,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.productos.length,
            itemBuilder: (context, index) {
              final producto = provider.productos[index];

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
                              mayuscPrimeraLetra(producto.nombreProducto),
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Precio: \$${producto.precioProducto.round()}',
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              ),
                            ),
                            Text(
                              // 'Cantidad de Producto: \n${producto.cantidadProducto.round()} ${producto.tipoUnidadProducto}',
                              (producto.cantidadProducto == 0.0 || producto.cantidadProducto >= 1.0)
                              ? 'Cantidad de Producto: \n${producto.cantidadProducto.round()} ${producto.tipoUnidadProducto}'
                              : 'Cantidad de Producto: \n${producto.cantidadProducto.toStringAsFixed(2)} ${producto.tipoUnidadProducto}',
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize,
                                color: themeModel.secondaryTextColor,
                              ),
                            ),
                            Text(
                              'Cantidad de unidades: ${producto.cantidadUnidadesProducto.round()}',
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InsertarProductosScreen(
                                      producto: producto),
                                ),
                              ).then(
                                  (_) => productosProvider.obtenerProductos());
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
                              _eliminarProducto(context, producto.idProducto!);
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
