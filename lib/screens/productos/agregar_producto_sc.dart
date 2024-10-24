import 'package:dulce_precision/screens/productos/productos_screen.dart';
import 'package:dulce_precision/utils/funciones/preciosIngredientes/ingredientesCalcularCostos.dart';
import 'package:dulce_precision/utils/funciones/preciosRecetas/recetasCalcularCostos.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/widgets/tipo_unidad_dropdown.dart';

class InsertarProductosScreen extends StatefulWidget {
  final Producto? producto;

  const InsertarProductosScreen({super.key, this.producto});

  @override
  _InsertProductScreenState createState() => _InsertProductScreenState();
}

class _InsertProductScreenState extends State<InsertarProductosScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _cantidadUnidadController =
      TextEditingController();

  String _tipoUnidadSeleccionada = 'unidad'; // Cambiado a 'unidad' por defecto
  Producto? _productoOriginal; // Para almacenar la copia original

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      // Guardar copia original del producto
      _productoOriginal = Producto(
        idProducto: widget.producto!.idProducto,
        nombreProducto: widget.producto!.nombreProducto,
        precioProducto: widget.producto!.precioProducto,
        cantidadProducto: widget.producto!.cantidadProducto,
        tipoUnidadProducto: widget.producto!.tipoUnidadProducto,
        cantidadUnidadesProducto: widget.producto!.cantidadUnidadesProducto,
      );

      // Llenar los campos con los datos del producto
      _nombreController.text = widget.producto!.nombreProducto;
      _precioController.text = widget.producto!.precioProducto.toString();
      _cantidadController.text = widget.producto!.cantidadProducto.toString();
      _cantidadUnidadController.text =
          widget.producto!.cantidadUnidadesProducto.toString();
      _tipoUnidadSeleccionada = widget.producto!.tipoUnidadProducto;
    }
  }

  Future<void> restaurarProducto() async {
    if (_productoOriginal == null) return;

    final productRepo = ProductRepository();
    try {
      await productRepo.actualizarProducto(_productoOriginal!);

      // Actualizar costos
      await actualizarCostosAllIngredientes();
      await calcularCostoCadaRecetas();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Producto restaurado exitosamente')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al restaurar el producto: $e')),
      );
    }
  }

  Future<void> _guardarProducto() async {
    final productRepo = ProductRepository();

    if (_nombreController.text.isEmpty ||
        _precioController.text.isEmpty ||
        _cantidadController.text.isEmpty ||
        _cantidadUnidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final double? precioProducto = double.tryParse(_precioController.text);
    final double? cantidadProducto = double.tryParse(_cantidadController.text);
    final double? cantidadUnidadesProducto =
        double.tryParse(_cantidadUnidadController.text);

    if (precioProducto == null ||
        cantidadProducto == null ||
        cantidadUnidadesProducto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, ingresa valores numéricos válidos.')),
      );
      return;
    }

    final producto = Producto(
      idProducto: widget.producto?.idProducto,
      nombreProducto: _nombreController.text,
      precioProducto: precioProducto,
      cantidadProducto: cantidadProducto,
      tipoUnidadProducto: _tipoUnidadSeleccionada,
      cantidadUnidadesProducto: cantidadUnidadesProducto,
    );

    try {
      if (widget.producto == null) {
        int id = await productRepo.insertProducto(producto);
        print("Producto insertado con ID: $id");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto insertado con éxito!')),
        );
      } else {
        await productRepo.actualizarProducto(producto);
        print("Producto actualizado con ID: ${producto.idProducto}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto actualizado con éxito!')),
        );
      }

      // Limpiar campos
      _nombreController.clear();
      _precioController.clear();
      _cantidadController.clear();
      _cantidadUnidadController.clear();

      // Actualizar costos
      await actualizarCostosAllIngredientes();
      await calcularCostoCadaRecetas();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Costos actualizados')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el producto: $e')),
      );
    }
  }

  Future<void> _confirmarSalida() async {
    // Esta función mostrará un cuadro de diálogo de confirmación
    final confirm = await ConfirmDialog.mostrarConfirmacion(
      context,
      'Hay cambios no guardados.\n¿Está seguro de que desea volver sin guardar?',
    );
    if (confirm) {
      await restaurarProducto();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductosScreen(),
        ),
      );
      if (mounted) {
        // Verificamos si el widget sigue montado antes de acceder al contexto
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se guardaron los cambios')));
      }
    } 
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return WillPopScope(
        onWillPop: () async {
          // Manejamos la acción de volver atrás
          if (_productoOriginal != null &&
              (_nombreController.text != _productoOriginal!.nombreProducto ||
                  _precioController.text !=
                      _productoOriginal!.precioProducto.toString() ||
                  _cantidadController.text !=
                      _productoOriginal!.cantidadProducto.toString() ||
                  _cantidadUnidadController.text !=
                      _productoOriginal!.cantidadUnidadesProducto.toString() ||
                  _tipoUnidadSeleccionada !=
                      _productoOriginal!.tipoUnidadProducto)) {
            // Si hay cambios, confirmamos la salida
            await _confirmarSalida();
          }
          return true; // Permitir la salida
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                _confirmarSalida();
              },
            ),
            title: Text(
              widget.producto == null ? 'Agregar Producto' : 'Editar Producto',
              style: TextStyle(
                fontSize: fontSizeModel.titleSize,
                color: themeModel.primaryTextColor,
              ),
            ),
            backgroundColor: themeModel.primaryButtonColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () =>
                    {_guardarProducto(), Navigator.of(context).pop()},
                color: themeModel.primaryTextColor,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre del Producto',
                      labelStyle: TextStyle(
                        color: themeModel.secondaryTextColor,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: fontSizeModel.textSize,
                      color: themeModel.secondaryTextColor,
                    ),
                  ),
                  TextField(
                    controller: _precioController,
                    decoration: InputDecoration(
                      labelText: 'Precio del Producto',
                      labelStyle: TextStyle(
                        color: themeModel.secondaryTextColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: fontSizeModel.textSize,
                      color: themeModel.secondaryTextColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _cantidadController,
                          decoration: InputDecoration(
                            labelText: 'Cantidad de Producto',
                            labelStyle: TextStyle(
                              color: themeModel.secondaryTextColor,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: fontSizeModel.textSize,
                            color: themeModel.secondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TipoUnidadDropdown(
                          initialValue: _tipoUnidadSeleccionada,
                          onChanged: (newValue) {
                            setState(() {
                              _tipoUnidadSeleccionada = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _cantidadUnidadController,
                    decoration: InputDecoration(
                      labelText: 'Cantidad de unidades del producto',
                      labelStyle: TextStyle(
                        color: themeModel.secondaryTextColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: fontSizeModel.textSize,
                      color: themeModel.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ));
  }
}
