import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/providers/ingredientes_provider.dart';
import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObtenerRecetasWG extends StatefulWidget {
  final Function(Receta)
      onRecetaConfirmada; // Callback para confirmar la receta

  const ObtenerRecetasWG({super.key, required this.onRecetaConfirmada});

  @override
  _ObtenerRecetasWGState createState() => _ObtenerRecetasWGState();
}

class _ObtenerRecetasWGState extends State<ObtenerRecetasWG> {
  int? _selectedRecetaId; // Almacena el ID de la receta seleccionada
  int? _expandedIndex; // Almacena el índice de la tarjeta expandida actualmente

  @override
  Widget build(BuildContext context) {
    // Cargar las recetas del proveedor
    Provider.of<RecetasProvider>(context, listen: false).obtenerRecetas();
    final recetaProvider = Provider.of<RecetasProvider>(context);

    return Scaffold(
      body: recetaProvider.recetas.isEmpty
          ? _buildEmptyState() // Construye el estado vacío
          : _buildRecetaListWithButton(
              recetaProvider), // Construye la lista con el botón
    );
  }

  // Construye el estado vacío cuando no hay recetas
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Recetas no disponibles', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Navegar hacia atrás
            },
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  // Construye la lista de recetas junto con el botón de confirmación
  Widget _buildRecetaListWithButton(RecetasProvider recetaProvider) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return ListView.builder(
      itemCount: recetaProvider.recetas.length +
          1, // Incluye el botón como un elemento adicional
      itemBuilder: (context, index) {
        if (index < recetaProvider.recetas.length) {
          // Construye las tarjetas de recetas
          Receta receta = recetaProvider.recetas[index];
          String estado = _determinarEstadoReceta(receta.costoReceta);
          return Card(
              margin: const EdgeInsets.all(8.0),
              color: Colors.white,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  _buildListTile(receta, index, estado),
                  if (_expandedIndex == index) _buildDetails(receta),
                ],
              ));
        } else {
          // Construye el botón de confirmación al final de la lista
          return _buildConfirmButton();
        }
      },
    );
  }

  // Construye el ListTile para cada receta
  ListTile _buildListTile(Receta receta, int index, String estado) {
    // Verificar si el costo es válido y mayor que 0
    final isValidCost = (double.tryParse(receta.costoReceta!) ?? 0) > 0;
    
    return ListTile(
      leading: Radio<int>(
        value: receta.idReceta!,
        groupValue: _selectedRecetaId,
        onChanged: (int? value) {
          if (!isValidCost) {
            // Muestra un SnackBar si la receta no está disponible
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pueden seleccionar recetas no disponibles'),
              ),
            );
          } else {
            setState(() {
              _selectedRecetaId = value;
            });
          }
        },
      ),
      title: Text(
        receta.nombreReceta,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _expandedIndex == index ? Icons.visibility : Icons.visibility_off,
              color: Colors.blueAccent,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                if (_expandedIndex == index) {
                  _expandedIndex = null; // Cierra la tarjeta si ya está abierta
                } else {
                  _expandedIndex =
                      index; // Abre la nueva tarjeta y cierra la anterior
                }
              });
            },
          ),
          const SizedBox(width: 8),
          Text(
            estado,
            style: TextStyle(
              fontSize: 14,
              color: estado == 'Disponible' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // // Construye los detalles de la receta
  // Padding _buildDetails(Receta receta) {
  //   final themeModel = Provider.of<ThemeModel>(context);
  //   final fontSizeModel = Provider.of<FontSizeModel>(context);

  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text('Descripción:',
  //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 8),
  //         Text(
  //           receta.descripcionReceta ?? 'Sin descripción',
  //           style: const TextStyle(fontSize: 14, color: Colors.black54),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Padding _buildDetails(Receta receta) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final ingredientesProvider =
        Provider.of<IngredientesRecetasProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future:
            ingredientesProvider.obtenerIngredientesPorReceta(receta.idReceta!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar ingredientes: ${snapshot.error}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: fontSizeModel.textSize,
                ),
              ),
            );
          }

          final ingredientes = ingredientesProvider.ingredientes;

          if (ingredientes.isEmpty) {
            return Center(
              child: Text(
                'No hay ingredientes disponibles',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  color: themeModel.primaryButtonColor,
                ),
              ),
            );
          }

          // Separar ingredientes en dos listas según el tipo de costo
          final ingredientesConCosto = ingredientes
              .where((ing) => (double.tryParse(ing.costoIngrediente)) != null)
              .toList();

          final ingredientesSinCosto = ingredientes
              .where((ing) => double.tryParse(ing.costoIngrediente) == null)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ingredientes:',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                  fontWeight: FontWeight.bold,
                  color: themeModel.primaryButtonColor,
                ),
              ),
              const SizedBox(height: 8),
              // Listado de ingredientes con costo numérico
              if (ingredientesConCosto.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredientesConCosto.length,
                  itemBuilder: (context, index) {
                    final ingrediente = ingredientesConCosto[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ingrediente.nombreIngrediente,
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize - 2,
                                color: themeModel.secondaryTextColor,
                              ),
                            ),
                          ),
                          Text(
                            '\$${double.parse(ingrediente.costoIngrediente).round()}',
                            style: TextStyle(
                              fontSize: fontSizeModel.textSize - 2,
                              color: themeModel.primaryButtonColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                // Costo total
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: themeModel.primaryButtonColor.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Costo Total: ',
                        style: TextStyle(
                          fontSize: fontSizeModel.textSize,
                          fontWeight: FontWeight.bold,
                          color: themeModel.primaryButtonColor,
                        ),
                      ),
                      Text(
                        '\$${_calcularCostoTotal(ingredientesConCosto)}',
                        style: TextStyle(
                          fontSize: fontSizeModel.textSize,
                          color: themeModel.primaryButtonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Listado de ingredientes sin costo numérico
              if (ingredientesSinCosto.isNotEmpty) ...[
                const SizedBox(height: 16),
                if (ingredientesConCosto.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: themeModel.primaryButtonColor.withOpacity(0.1),
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredientesSinCosto.length,
                  itemBuilder: (context, index) {
                    final ingrediente = ingredientesSinCosto[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ${ingrediente.nombreIngrediente}:',
                            style: TextStyle(
                              fontSize: fontSizeModel.textSize - 2,
                              color: themeModel.secondaryTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, top: 4.0),
                            child: Text(
                              ingrediente.costoIngrediente,
                              style: TextStyle(
                                fontSize: fontSizeModel.textSize - 2,
                                color: themeModel.secondaryTextColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // Método auxiliar para calcular el costo total (solo ingredientes con costo numérico)
  int _calcularCostoTotal(List<IngredienteReceta> ingredientes) {
    double total = ingredientes.fold(0.0, (sum, ingrediente) {
      return sum + (double.tryParse(ingrediente.costoIngrediente) ?? 0.0);
    });
    return total.round();
  }

  // Construye el botón de confirmación
  Widget _buildConfirmButton() {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    // Corregimos la verificación
    bool isSelectedRecetaAvailable = false;
    if (_selectedRecetaId != null) {
      final selectedReceta = Provider.of<RecetasProvider>(context, listen: false)
          .recetas
          .firstWhere((receta) => receta.idReceta == _selectedRecetaId);
      final cost = double.tryParse(selectedReceta.costoReceta!) ?? 0;
      isSelectedRecetaAvailable = cost > 0;
    }

    return Visibility(
      visible: isSelectedRecetaAvailable,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmSelection,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: themeModel.primaryButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Confirmar selección',
            style: TextStyle(
              fontSize: fontSizeModel.textSize,
              fontWeight: FontWeight.bold,
              color: themeModel.primaryTextColor,
            ),
          ),
        ),
      ),
    );
}

  // Confirma la selección de la receta
  // Modificamos _confirmSelection para usar el callback
  void _confirmSelection() {
    if (_selectedRecetaId != null) {
      // Busca la receta seleccionada en el proveedor
      Receta selectedReceta =
          Provider.of<RecetasProvider>(context, listen: false)
              .recetas
              .firstWhere((receta) => receta.idReceta == _selectedRecetaId);

      // Verifica si la receta está disponible
      if (selectedReceta.costoReceta == '0') {
        // Muestra un SnackBar si la receta no está disponible
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pueden seleccionar recetas no disponibles')),
        );
      } else {
        widget.onRecetaConfirmada(
            selectedReceta); // Llama al callback con la receta seleccionada
      }
    } else {
      // Muestra un SnackBar si no hay receta seleccionada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una receta')),
      );
    }
  }
  // void _confirmSelection() {
  //   if (_selectedRecetaId != null) {
  //     // Busca la receta seleccionada en el proveedor
  //     Receta selectedReceta = Provider.of<RecetasProvider>(context, listen: false)
  //         .recetas
  //         .firstWhere((receta) => receta.idReceta == _selectedRecetaId);
  //     widget.onRecetaConfirmada(selectedReceta); // Llama al callback con la receta seleccionada
  //   } else {
  //     // Muestra un SnackBar si no hay receta seleccionada
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Por favor, selecciona una receta')),
  //     );
  //   }
  // }

  // Determina el estado de la receta según su costo
  String _determinarEstadoReceta(String? costoReceta) {
    if (costoReceta == null ||
        costoReceta.isEmpty ||
        double.tryParse(costoReceta) == null) {
      return 'No disponible';
    }
    double? costo = double.tryParse(costoReceta);
    return (costo != null && costo > 0) ? 'Disponible' : 'No disponible';
  }
}
