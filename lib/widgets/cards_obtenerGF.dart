import 'package:dulce_precision/database/providers/gastosFijos_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/widgets/customTextField_ventas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ObtenerGastosFijosWG extends StatefulWidget {
  final Function(double porcentaje, double totalPorcentaje,
      List<GastoCalculado> detalleGastos) onGastoConfirmado;

  ObtenerGastosFijosWG({required this.onGastoConfirmado});

  @override
  _ObtenerGastosFijosWGState createState() => _ObtenerGastosFijosWGState();
}

class GastoCalculado {
  final GastoFijo gasto;
  final double valorCalculado;

  GastoCalculado(this.gasto, this.valorCalculado);
}

class _ObtenerGastosFijosWGState extends State<ObtenerGastosFijosWG> {
  List<int> _selectedGastosIds = [];
  List<GastoCalculado> _gastosCalculados = [];
  double _totalPorcentaje = 0.0;
  double _porcentaje = 0.0;
  bool _isConfirmed = false;
  bool _calculosActualizados = false;

  void _calcularGastosSeleccionados() {
    final gastoFijoProvider =
        Provider.of<GastosFijosProvider>(context, listen: false);
    setState(() {
      _calculosActualizados = true;
      // Ahora calculamos para todos los gastos
      _gastosCalculados = gastoFijoProvider.gastosFijos.map((gasto) {
        return GastoCalculado(
          gasto,
          gasto.valorGF * _porcentaje / 100,
        );
      }).toList();

      // El total solo se calcula para los gastos seleccionados
      _totalPorcentaje = _gastosCalculados
          .where(
              (gastoCalc) => _selectedGastosIds.contains(gastoCalc.gasto.idGF))
          .fold(0.0, (sum, gastoCalc) => sum + gastoCalc.valorCalculado);
    });
  }

  double _getValorCalculado(GastoFijo gasto) {
    if (!_calculosActualizados) return 0.0;
    return gasto.valorGF * _porcentaje / 100;
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    if (_isConfirmed) {
      return _buildResultado();
    }

    return Consumer<GastosFijosProvider>(
      builder: (context, gastoFijoProvider, child) {
        if (gastoFijoProvider.gastosFijos.isEmpty) {
          gastoFijoProvider.obtenerGastosFijos();
        }
        if (gastoFijoProvider.gastosFijos.isEmpty) {
          // Si no hay gastos fijos, mostramos un estado vacío
          return _buildEmptyState();
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: //TextField(
                      //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _porcentaje = double.tryParse(value) ?? 0.0;
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //     labelText: 'Porcentaje (%)',
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      CustomTextField(
                    keyboardType: TextInputType.numberWithOptions(
                        decimal:
                            true), // Permite entrada de números con decimales
                    onChanged: (value) {
                      setState(() {
                        _porcentaje = double.tryParse(value) ??
                            0.0; // Actualiza la variable con el valor ingresado o 0 si es inválido
                      });
                    },
                    decoration: InputDecoration(
                      labelText:
                          'Porcentaje (%)', // Etiqueta del campo de texto
                      border: OutlineInputBorder(), // Borde del campo de texto
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _calcularGastosSeleccionados,
                  child: Text(
                    'Calcular',
                    style: TextStyle(fontSize: fontSizeModel.textSize),
                  ),
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          themeModel.primaryButtonColor),
                      foregroundColor:
                          WidgetStateProperty.all(themeModel.primaryTextColor)),
                ),
              ],
            ),
            SizedBox(height: 16),
            gastoFijoProvider.gastosFijos.isEmpty
                ? _buildEmptyState()
                : _buildGastoFijoList(gastoFijoProvider),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isConfirmed = true;
                });
                // Solo pasamos los gastos seleccionados al confirmar
                final gastosSeleccionados = _gastosCalculados
                    .where((gastoCalc) =>
                        _selectedGastosIds.contains(gastoCalc.gasto.idGF))
                    .toList();
                widget.onGastoConfirmado(
                    _porcentaje, _totalPorcentaje, gastosSeleccionados);
              },
              child: Text(
                'Confirmar Selección',
                style: TextStyle(fontSize: fontSizeModel.textSize),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(themeModel.primaryButtonColor),
                  foregroundColor:
                      WidgetStateProperty.all(themeModel.primaryTextColor)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No se encontraron gastos fijos, puedes crearlos desde el menu',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGastoFijoList(GastosFijosProvider gastoFijoProvider) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: gastoFijoProvider.gastosFijos.length,
      itemBuilder: (context, index) {
        final gasto = gastoFijoProvider.gastosFijos[index];
        final valorCalculado = _getValorCalculado(gasto);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Transform.scale(
                  scale: fontSizeModel.iconSize * 0.05,
                  child: Checkbox(
                    value: _selectedGastosIds.contains(gasto.idGF),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedGastosIds.add(gasto.idGF!);
                        } else {
                          _selectedGastosIds.remove(gasto.idGF);
                        }
                        _calcularGastosSeleccionados();
                      });
                    },
                    activeColor: themeModel
                        .primaryButtonColor, // Cambia esto al color que prefieras
                    checkColor: themeModel.primaryTextColor,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    gasto.nombreGF,
                    style: TextStyle(
                        fontSize: fontSizeModel.textSize,
                        color: themeModel.secondaryTextColor),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '\$${NumberFormat.decimalPattern('es_ES').format(gasto.valorGF.round())}',
                    style: TextStyle(
                        fontSize: fontSizeModel.textSize,
                        color: themeModel.secondaryTextColor),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(right: 4.0, left: 8.0),
                    child: Text(
                      _calculosActualizados
                          ? '\$${valorCalculado.round()}'
                          : 'Esperando %',
                      style: TextStyle(
                        fontSize: fontSizeModel.textSize,
                        fontWeight: FontWeight.bold,
                        color: themeModel.primaryButtonColor,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          readOnly: true, // El campo de texto es de solo lectura
          decoration: InputDecoration(
            labelText: 'Resumen de cálculos', // Etiqueta del campo de texto
            border: OutlineInputBorder(), // Borde del campo de texto
          ),
          controller: TextEditingController(
            text:
                'Porcentaje aplicado: $_porcentaje%\n' // Texto a mostrar en el campo de texto
                'Total calculado: \$${_totalPorcentaje.toStringAsFixed(2)}',
          ),
        ),
        SizedBox(height: 16),
        CustomTextField(
          readOnly: true, // El campo de texto es de solo lectura
          decoration: InputDecoration(
            labelText:
                'Detalle de gastos seleccionados', // Etiqueta del campo de texto
            border: OutlineInputBorder(), // Borde del campo de texto
          ),
          controller: TextEditingController(
            text: _gastosCalculados
                .where((gastoCalc) => _selectedGastosIds.contains(
                    gastoCalc.gasto.idGF)) // Filtra los gastos seleccionados
                .map((gastoCalc) =>
                    '${gastoCalc.gasto.nombreGF}: \$${gastoCalc.valorCalculado.toStringAsFixed(2)}') // Formatea cada gasto
                .join(
                    '\n'), // Une los gastos en una cadena de texto separada por saltos de línea
          ),
        ),
      ],
    );
  }
}
