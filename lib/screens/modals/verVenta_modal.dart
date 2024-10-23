import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/database/providers/ventas_provider.dart';
import 'package:dulce_precision/models/db_model.dart'; // Importamos el modelo Venta

// Modal para ver el detalle de una venta
Future<void> mostrarDetalleVentaModal(BuildContext context, int idVenta) async {
  // Obtenemos el provider de ventas
  final ventasProvider = Provider.of<VentasProvider>(context, listen: false);

  // Cargamos la venta por su ID
  Venta? venta = await ventasProvider.getVentaById(idVenta);

  // Obtenemos los modelos de tema y tamaño de fuente
  final themeModel = Provider.of<ThemeModel>(context, listen: false);
  final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

  // Si la venta no existe, mostramos un error
  if (venta == null) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('La venta no fue encontrada.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar el modal con los detalles de la venta
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.95, // Ancho en 95% de la pantalla
          height: MediaQuery.of(context).size.height *
              0.9, // Alto en 90% de la pantalla
          decoration: BoxDecoration(
            color: themeModel.backgroundColor, // Color de fondo del modal
            borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 0, vertical: 10), // Padding para el título
                child: Center(
                  child: Text(
                    'Detalle de Venta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fontSizeModel.titleSize,
                      color: themeModel.primaryTextColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // text para mostrar los detalles
                      _buildDetailRow('Nombre de Venta:', venta.nombreVenta,
                          themeModel, fontSizeModel),
                      _buildDetailRow(
                          'Hora de Venta:',
                          (DateFormat("HH:mm").format(
                              DateFormat("HH:mm:ss").parse(venta.horaVenta))),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow('Fecha de Venta:', venta.fechaVenta,
                          themeModel, fontSizeModel),
                      _buildDetailRow('Producto Vendido:', venta.productoVenta,
                          themeModel, fontSizeModel),
                      _buildDetailRow(
                          'Cantidad Vendida:',
                          venta.cantidadVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow('Porcentaje de Gastos Fijos:',
                      (venta.pctjGFVenta == 0.0 || venta.pctjGFVenta >= 1.0)
                              ? '${venta.pctjGFVenta.round()}%'
                              : '${venta.pctjGFVenta.toStringAsFixed(2)}%',
                          themeModel, fontSizeModel),
                      _buildDetailRow('Desglose de Gastos Fijos:',
                          venta.desgloseGFVenta, themeModel, fontSizeModel),
                      _buildDetailRow(
                          'Monto Total Gastos Fijos:',
                          venta.precioGFVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow(
                          'Costo de la Receta:',
                          venta.costoRecetaVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow(
                          'Porcentaje de Ganancia:',
                          (venta.pctjGananciaVenta == 0.0 || venta.pctjGananciaVenta >= 1.0)
                              ? '${venta.pctjGananciaVenta.round()}%'
                              : '${venta.pctjGananciaVenta.toStringAsFixed(2)}%',
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow(
                          'Monto de Ganancia:',
                          venta.montoGananciaVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow(
                          'Precio por Producto:',
                          venta.precioPorProductoVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                      _buildDetailRow(
                          'Precio de Venta de la Receta:',
                          venta.precioFinalVenta.round().toString(),
                          themeModel,
                          fontSizeModel),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16), // Padding para el botón "Cerrar"
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    backgroundColor: themeModel.primaryButtonColor,
                    foregroundColor: themeModel.primaryTextColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el modal
                  },
                  child: Text(
                    'Cerrar',
                    style: TextStyle(
                      fontSize: fontSizeModel.subtitleSize,
                      color: themeModel.primaryTextColor,
                    ),
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

// Widget para construir cada fila de detalles
Widget _buildDetailRow(String label, String value, ThemeModel themeModel,
    FontSizeModel fontSizeModel) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo (nombre)
        Text(
          '$label',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:
                fontSizeModel.subtitleSize, // Tamaño de subtítulo para el label
            color:
                themeModel.primaryButtonColor, // Color principal para el label
          ),
        ),
        // Valor (contenido)
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSizeModel
                  .textSize, // Tamaño de texto dinámico para el valor
              color: themeModel
                  .primaryTextColor, // Color principal para el contenido
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Divider(
            color: themeModel.primaryTextColor,
            thickness: 1,
          ),
        )
      ],
    ),
  );
}
