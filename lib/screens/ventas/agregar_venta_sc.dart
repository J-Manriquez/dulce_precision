import 'package:dulce_precision/database/providers/ventas_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/widgets/ventas/cards_obtenerGF.dart';
import 'package:dulce_precision/widgets/ventas/cards_obtenerRecetas.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/widgets/customTextField_ventas.dart';
import 'package:dulce_precision/widgets/ventas/confirmCrearVentaAcProd.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AgregarVentaSC extends StatefulWidget {
  const AgregarVentaSC({super.key});

  @override
  _AgregarVentaSCState createState() => _AgregarVentaSCState();
}

class _AgregarVentaSCState extends State<AgregarVentaSC> {
  bool _mostrarObtenerRecetas = true;
  bool _agregarGastosFijos = false;
  Receta? _recetaSeleccionada;
  DateTime now = DateTime.now();
  double _porcentaje = 0.0;
  double _totalCalculado = 0.0;
  List<GastoCalculado> _gastosCalculados = [];
  bool _gastosConfirmados =
      false; // Variable para saber si los gastos fueron confirmados
  double _porcentajeGanancia = 0.0;
  double _montoGanancia = 0.0;
  double _precioPorProducto = 0.0;
  double _precioVentaReceta = 0.0;

  final ScrollController _scrollController = ScrollController();

  // Controladores para los campos de texto
  final TextEditingController _nombreVentaController = TextEditingController();
  final TextEditingController _ventasPorRecetaController =
      TextEditingController();
  final TextEditingController _porcentajeGananciaController =
      TextEditingController();

  bool _mostrarInfoVentas = false;
  bool _mostrarInfoGanancia = false;

  void _onRecetaConfirmada(Receta receta) {
    setState(() {
      _recetaSeleccionada = receta;
      _mostrarObtenerRecetas = false;
    });
  }

  // Nueva función para manejar la confirmación de los gastos provenientes de ObtenerGastosFijosWG
  void _onGastoConfirmado(double porcentaje, double totalPorcentaje,
      List<GastoCalculado> detalleGastos) {
    setState(() {
      _porcentaje = porcentaje;
      _totalCalculado = totalPorcentaje;
      _gastosCalculados = detalleGastos;
      _gastosConfirmados = true; // Indicar que la selección ha sido confirmada
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: themeModel.secondaryIconColor),
            iconSize: fontSizeModel.iconSize, // Tamaño dinámico del ícono
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          'Crear Venta',
          style: TextStyle(
            fontSize: fontSizeModel.titleSize,
            color: themeModel.primaryTextColor,
          ),
        ),
        backgroundColor: themeModel.primaryButtonColor,
        actions: [
          if (_recetaSeleccionada != null)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await ConfirmarActualizacionProductosDialog.mostrarModal(
                  context,
                  _recetaSeleccionada!.idReceta!,
                  () => _guardarDatosVenta(),
                ); // Pasa el ID de la receta al modal
              },
              color: themeModel.primaryTextColor,
            ),
        ],
      ),
      body: _mostrarObtenerRecetas
          ? Center(
              child: ObtenerRecetasWG(onRecetaConfirmada: _onRecetaConfirmada),
            )
          : _buildDetalleVenta(),
    );
  }

  Widget _buildDetalleVenta() {
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    String formattedDate = DateFormat('dd/MM/yyyy').format(now);
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nombreVentaController, // Controlador agregado
                labelText:
                    'Ingresa nombre o motivo de la venta', // Texto de la etiqueta
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del TextField
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                readOnly: true, // Campo de solo lectura
                controller: TextEditingController(
                    text: formattedTime), // Controlador con el valor de la hora
                labelText: 'Hora', // Texto de la etiqueta
                suffixIcon: const Icon(
                    Icons.access_time), // Icono al final del campo de texto
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del TextField
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                readOnly: true, // El campo es de solo lectura
                controller: TextEditingController(
                    text:
                        formattedDate), // Controlador con el valor de la fecha
                labelText: 'Fecha', // Etiqueta del campo
                suffixIcon: const Icon(Icons
                    .calendar_today), // Ícono de calendario al final del campo
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del TextField
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                readOnly: true, // El campo es de solo lectura
                controller: TextEditingController(
                  text: _recetaSeleccionada?.nombreReceta ??
                      'Sin nombre', // Valor del controlador, con un valor por defecto
                ),
                labelText: 'Receta seleccionada', // Etiqueta del campo
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del TextField
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: CustomTextField(
                      controller: _ventasPorRecetaController,
                      keyboardType: TextInputType.number,
                      labelText: 'Ventas por receta',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      color: themeModel.primaryButtonColor,
                      size: fontSizeModel.iconSize * 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarInfoVentas = !_mostrarInfoVentas;
                      });
                    },
                  ),
                ],
              ),
              if (_mostrarInfoVentas) // Texto informativo
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Text(
                //     'Es la cantidad de productos a vender que se obtienen de la receta, por ejemplo, un pie de limón se puede dividir en 8 partes para vender por separado.',
                //     style: TextStyle(
                //       color: themeModel.primaryButtonColor,
                //       fontSize: fontSizeModel.textSize * 0.8,
                //     ),
                //   ),
                // ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 1, right: 2, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeModel.backgroundColor.withOpacity(0.05),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Es la cantidad de productos a vender que se obtienen de la receta, por ejemplo, un pie de limón se puede dividir en 8 partes para vender por separado.',
                          style: TextStyle(
                            color: themeModel.primaryButtonColor,
                            fontSize: fontSizeModel.textSize * 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              const SizedBox(height: 20),
              CustomTextField(
                readOnly: true, // Campo de solo lectura
                controller: TextEditingController(
                  text: _recetaSeleccionada?.costoReceta != null
                      ? (RegExp(r'[a-zA-Z]')
                              .hasMatch(_recetaSeleccionada!.costoReceta!)
                          ? 'No se puede calcular el costo' // Mensaje en caso de que el costo no sea numérico
                          : '\$${(double.tryParse(_recetaSeleccionada!.costoReceta!) ?? 0.0).round()}') // Formato del costo
                      : 'Costo no calculado', // Mensaje si no hay costo
                ),
                labelText: 'Costo de la receta', // Etiqueta del campo
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde del TextField
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller:
                          _porcentajeGananciaController, // Controlador agregado
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Teclado numérico con opción decimal
                      onChanged: (value) {
                        setState(() {
                          _porcentajeGanancia = double.tryParse(value) ??
                              0.0; // Actualiza el porcentaje de ganancia
                        });
                      },
                      labelText: 'Porcentaje (%)', // Etiqueta del campo
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // Borde del TextField
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _calcularPorcentajeGanancia,
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            themeModel.primaryButtonColor),
                        foregroundColor: WidgetStateProperty.all(
                            themeModel.primaryTextColor)),
                    child: Text(
                      'Calcular',
                      style: TextStyle(fontSize: fontSizeModel.textSize),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      readOnly: true, // Campo de solo lectura
                      controller: TextEditingController(
                        text: _porcentajeGanancia != 0.0
                            ? '\$${_montoGanancia.round()}' // Mostrar el monto de ganancia si el porcentaje es distinto de 0
                            : 'Esperando % de ganancia', // Mensaje si no se ha ingresado un porcentaje
                      ),
                      labelText: 'Porcentaje de ganancia', // Etiqueta del campo
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // Borde del TextField
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info,
                      color: themeModel.primaryButtonColor,
                      size: fontSizeModel.iconSize * 1.5,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarInfoGanancia = !_mostrarInfoGanancia;
                      });
                    },
                  ),
                ],
              ),
              if (_mostrarInfoGanancia) // Texto informativo
                Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 1, right: 2, bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: themeModel.backgroundColor.withOpacity(0.05),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Este porcentaje se añade al costo original de la receta y costos fijos para cubrir no solo los costos directos, sino también para generar una ganancia y permitir la expansión del negocio.',
                          style: TextStyle(
                            color: themeModel.primaryButtonColor,
                            fontSize: fontSizeModel.textSize * 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Añadir gastos fijos',
                    style: TextStyle(
                        fontSize: fontSizeModel.textSize,
                        fontWeight: FontWeight.bold,
                        color: themeModel.primaryButtonColor),
                  ),
                  Switch(
                    value: _agregarGastosFijos,
                    onChanged: (bool value) {
                      setState(() {
                        _agregarGastosFijos = value;
                        _gastosConfirmados = false; // Reiniciar la confirmación
                        if (!value) {
                          _gastosCalculados.clear();
                          _totalCalculado = 0.0;
                        }
                      });
                    },
                    activeColor: themeModel.secondaryIconColor,
                    inactiveTrackColor:
                        themeModel.secondaryTextColor.withOpacity(0.75),
                    activeTrackColor: themeModel.primaryButtonColor,
                    inactiveThumbColor: themeModel.secondaryIconColor,
                  ),
                ],
              ),
              if (_agregarGastosFijos) ...[
                const SizedBox(height: 16),
                if (!_gastosConfirmados)
                  Container(
                    child: SingleChildScrollView(
                      child: ObtenerGastosFijosWG(
                        onGastoConfirmado: _onGastoConfirmado,
                      ),
                    ),
                  ),
                if (_gastosConfirmados) ...[
                  const SizedBox(height: 16),
                  _buildResultadoGastos(),
                ],
              ],
              const SizedBox(height: 16),
              Text(
                'Resultados obtenidos',
                style: TextStyle(
                    fontSize: fontSizeModel.textSize,
                    fontWeight: FontWeight.bold,
                    color: themeModel.primaryButtonColor),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _calcularPrecioVentaReceta(),
                ),
                labelText: 'Precio venta por receta',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                readOnly: true,
                controller: TextEditingController(
                  text: _calcularPrecioPorProducto(),
                ),
                labelText: 'Precio por unidad',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Resumen de la venta',
                style: TextStyle(
                    fontSize: fontSizeModel.textSize,
                    fontWeight: FontWeight.bold,
                    color: themeModel.primaryButtonColor),
              ),
              _buildResumenVenta(),
            ],
          ),
        ),
      ),
    );
  }

  String _calcularPrecioPorProducto() {
    final ventasPorReceta =
        double.tryParse(_ventasPorRecetaController.text.trim()) ?? 1.0;
    final totalPorcentaje = _agregarGastosFijos ? _totalCalculado : 0.0;
    final costoReceta =
        (double.tryParse(_recetaSeleccionada!.costoReceta!) ?? 0.0).round();
    final precioVentaReceta = (costoReceta + _montoGanancia + totalPorcentaje);
    _precioVentaReceta = precioVentaReceta;
    final precioPorProducto =
        (costoReceta + _montoGanancia + totalPorcentaje) / ventasPorReceta;
    _precioPorProducto = precioPorProducto;
    return '\$${precioPorProducto.round()}';
  }

  String _calcularPrecioVentaReceta() {
    final totalPorcentaje = _agregarGastosFijos ? _totalCalculado : 0.0;
    final costoReceta =
        (double.tryParse(_recetaSeleccionada!.costoReceta!) ?? 0.0).round();
    final precioVentaReceta = (costoReceta + _montoGanancia + totalPorcentaje);
    _precioVentaReceta = precioVentaReceta;
    return '\$${precioVentaReceta.round()}';
  }

  Future<void> _guardarDatosVenta() async {
    // Asegurarse de que los controladores y variables relevantes están llenos
    final nombreVenta = _nombreVentaController.text.isNotEmpty
        ? _nombreVentaController.text
        : 'Sin definir';
    final hora = DateFormat('HH:mm:ss').format(now);
    final fecha = DateFormat('dd/MM/yyyy').format(now);
    final receta = _recetaSeleccionada?.nombreReceta ?? 'Sin receta';
    final ventasPorReceta = _ventasPorRecetaController.text.isNotEmpty
        ? double.parse(_ventasPorRecetaController.text)
        : 1.0;
    final costoReceta = double.parse(_recetaSeleccionada!.costoReceta!);
    final porcentajeGanancia = _porcentajeGanancia;
    final montoGanancia = _montoGanancia;
    final porcentajeGastosFijos = _agregarGastosFijos ? _porcentaje : 0.0;
    final desgloseGF = _gastosConfirmados
        ? _gastosCalculados
            .map((gasto) =>
                '\n   • ${gasto.gasto.nombreGF}: \$${gasto.valorCalculado.round()}')
            .join(', ')
        : 'Sin detalle';
    final montoGastosFijos = _agregarGastosFijos ? _totalCalculado : 0.0;
    final precioVentaReceta = _precioVentaReceta;
    final precioPorProducto = _precioPorProducto;

    // Crear un mapa con los datos
    var venta = Venta(
      nombreVenta: nombreVenta,
      horaVenta: hora,
      fechaVenta: fecha,
      productoVenta: receta,
      cantidadVenta: ventasPorReceta,
      pctjGFVenta: porcentajeGastosFijos,
      desgloseGFVenta: desgloseGF,
      precioGFVenta: montoGastosFijos,
      costoRecetaVenta: costoReceta,
      pctjGananciaVenta: porcentajeGanancia,
      montoGananciaVenta: montoGanancia,
      precioPorProductoVenta: precioPorProducto,
      precioFinalVenta: precioVentaReceta,
    );
    await Provider.of<VentasProvider>(context, listen: false)
        .agregarVenta(venta);
  }

  Widget _buildResumenVenta() {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final String resumen =
        '''Nombre o Motivo: ${(_nombreVentaController.text == '' ? 'Sin definir' : _nombreVentaController.text)}
• Hora: ${DateFormat('HH:mm:ss').format(now)}
• Fecha: ${DateFormat('dd/MM/yyyy').format(now)}
Receta: ${_recetaSeleccionada?.nombreReceta ?? 'N/A'}
• Ventas por receta: ${_ventasPorRecetaController.text}
• Costo receta: \$${(double.tryParse(_recetaSeleccionada!.costoReceta!) ?? 0.0).round()}
Porcentaje de Ganancia: ${_porcentajeGanancia.round()}%
• Monto Ganancia: \$${_montoGanancia.round()}
Porcentaje de Gastos Fijos: ${_agregarGastosFijos ? (_porcentaje == 0.0 ? '${_porcentaje.round()}%' : '$_porcentaje%') : '0%'}
• Detalle Gastos Fijos: ${_gastosConfirmados ? _gastosCalculados.map((gasto) => '\n   • ${gasto.gasto.nombreGF}: \$${gasto.valorCalculado.round()}').join(', ') : 'Sin detalle'}
• Monto Gastos Fijos: \$${_agregarGastosFijos ? _totalCalculado.round() : 0}
Precio de venta por receta: \$${_precioVentaReceta.round()}
Precio de venta por unidad: \$${_precioPorProducto.round()}''';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: themeModel.backgroundColor.withOpacity(0.05),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          resumen,
          style: TextStyle(
            color: themeModel.primaryButtonColor,
            fontSize: fontSizeModel.textSize,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  void _calcularPorcentajeGanancia() {
    final String? costoRecetaString = _recetaSeleccionada?.costoReceta;
    final double costoReceta =
        double.tryParse(costoRecetaString ?? '0.0') ?? 0.0;
    setState(() {
      _montoGanancia = costoReceta * _porcentajeGanancia / 100;
    });
  }

  // Método para mostrar el detalle de los gastos confirmados
  Widget _buildResultadoGastos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          readOnly: true, // El campo de texto es de solo lectura
          decoration: const InputDecoration(
            labelText: 'Porcentaje ingresado', // Etiqueta del campo de texto
            border: OutlineInputBorder(), // Borde del campo de texto
          ),
          controller: TextEditingController(
            text: '$_porcentaje%', // Muestra el porcentaje ingresado
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          readOnly: true, // El campo de texto es de solo lectura
          decoration: const InputDecoration(
            labelText:
                'Detalle de gastos seleccionados', // Etiqueta del campo de texto
            border: OutlineInputBorder(), // Borde del campo de texto
          ),
          controller: TextEditingController(
            text: _gastosCalculados
                .map((gastoCalc) =>
                    '${gastoCalc.gasto.nombreGF}: \$${gastoCalc.valorCalculado.round()}') // Formatea cada gasto redondeando su valor
                .join(
                    '\n'), // Une los gastos en una cadena de texto separada por saltos de línea
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          readOnly: true, // El campo de texto es de solo lectura
          decoration: const InputDecoration(
            labelText: 'Total calculado', // Etiqueta del campo de texto
            border: OutlineInputBorder(), // Borde del campo de texto
          ),
          controller: TextEditingController(
            text:
                '\$${_totalCalculado.round()}', // Muestra el total calculado redondeado
          ),
        ),
      ],
    );
  }
}
