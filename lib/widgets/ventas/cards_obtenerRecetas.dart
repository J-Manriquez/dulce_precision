import 'package:dulce_precision/database/providers/ingredientes_provider.dart';
import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:dulce_precision/utils/funciones/ventas/verificarStock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObtenerRecetasWG extends StatefulWidget {
  final Function(Receta) onRecetaConfirmada;
  const ObtenerRecetasWG({super.key, required this.onRecetaConfirmada});

  @override
  _ObtenerRecetasWGState createState() => _ObtenerRecetasWGState();
}

class _ObtenerRecetasWGState extends State<ObtenerRecetasWG> {
  int? _selectedRecetaId;
  int? _expandedIndex;
  Map<int, Future<Map<String, dynamic>>> _stockResultados = {};
  Map<int, bool> _stockDisponible = {};
  Map<int, List<String>> _ingredientesSinStock = {};
  Map<int, List<IngredienteReceta>> _ingredientesPorReceta = {};
  Map<int, bool> _loadingIngredientes = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarDatos();
    });
  }

  Future<void> _inicializarDatos() async {
    final recetaProvider = Provider.of<RecetasProvider>(context, listen: false);
    await recetaProvider.obtenerRecetas();

    for (var receta in recetaProvider.recetas) {
      if (receta.idReceta != null) {
        _loadingIngredientes[receta.idReceta!] = true;

        try {
          final resultados =
              await obtenerResultadosIngredientes(receta.idReceta!);
          if (mounted) {
            setState(() {
              _stockResultados[receta.idReceta!] = Future.value(resultados);
              _stockDisponible[receta.idReceta!] =
                  resultados['recetaDisponible'] ?? false;
              _ingredientesSinStock[receta.idReceta!] =
                  List<String>.from(resultados['ingredientesSinStock'] ?? []);
            });
          }
        } catch (e) {
          CustomLogger().logError('Error al obtener resultados: $e');
        }
      }
    }
  }

  Widget divider() {
    final themeModel = Provider.of<ThemeModel>(context);
    return Container(
      width: double.infinity,
      height: 1,
      color: themeModel.primaryButtonColor.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 16),
    );
  }

  Future<Map<String, dynamic>> obtenerResultadosIngredientes(
      int idReceta) async {
    CustomLogger().logInfo(
        'Obteniendo resultados de ingredientes para receta: $idReceta');
    try {
      Map<String, dynamic> resultados =
          await verificarIngredientesStock(idReceta);
      return resultados;
    } catch (e) {
      CustomLogger().logError('Error al verificar ingredientes: $e');
      return {'recetaDisponible': false, 'ingredientesSinStock': <String>[]};
    }
  }

  Future<void> _cargarIngredientes(int idReceta) async {
    if (_loadingIngredientes[idReceta] ?? false) {
      final ingredientesProvider =
          Provider.of<IngredientesRecetasProvider>(context, listen: false);
      try {
        // Ahora asignamos directamente el valor retornado por la función
        final ingredientes = await ingredientesProvider
            .obtenerIngredientesPorRecetaCards(idReceta);
        if (mounted) {
          setState(() {
            _ingredientesPorReceta[idReceta] =
                ingredientes; // Ahora ingredientes tiene un valor
            _loadingIngredientes[idReceta] = false;
          });
        }
      } catch (e) {
        CustomLogger().logError('Error al cargar ingredientes: $e');
        if (mounted) {
          setState(() {
            _loadingIngredientes[idReceta] = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recetaProvider = Provider.of<RecetasProvider>(context);
    return Scaffold(
      body: recetaProvider.recetas.isEmpty
          ? _buildEmptyState()
          : _buildRecetaListWithButton(recetaProvider),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Recetas no disponibles', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecetaListWithButton(RecetasProvider recetaProvider) {
    return ListView.builder(
      itemCount: recetaProvider.recetas.length + 1,
      itemBuilder: (context, index) {
        if (index < recetaProvider.recetas.length) {
          Receta receta = recetaProvider.recetas[index];
          String estado = _determinarEstadoReceta(receta);

          if (_expandedIndex == index) {
            _cargarIngredientes(receta.idReceta!);
          }

          return Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildListTile(receta, index, estado),
                  if (_expandedIndex == index)
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildDetails(receta),
                    ),
                ],
              ),
            ),
          );
        } else {
          return _buildConfirmButton();
        }
      },
    );
  }

  Widget _buildListTile(Receta receta, int index, String estado) {
    final themeModel = Provider.of<ThemeModel>(context);
    final disponible = (double.tryParse(receta.costoReceta!) ?? 0) > 0 &&
        (_stockDisponible[receta.idReceta!] ?? false);

    return ListTile(
      leading: Radio<int>(
        value: receta.idReceta!,
        groupValue: _selectedRecetaId,
        onChanged: disponible
            ? (int? value) {
                // Si la receta está disponible, seleccionamos
                setState(() => _selectedRecetaId = value);
              }
            : (int? value) {
                // Si la receta no está disponible, mostramos un Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Esta receta no está disponible.'),
                  ),
                );
              },
        fillColor: WidgetStateColor.resolveWith(
            (states) => themeModel.primaryButtonColor),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              color: themeModel.primaryButtonColor,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _expandedIndex = _expandedIndex == index ? null : index;
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

  Widget _buildDetails(Receta receta) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    final ingredientesSinStock =
        _ingredientesSinStock[receta.idReceta!] ?? []; // Añade esta línea

    if (_loadingIngredientes[receta.idReceta!] ?? true) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(themeModel.primaryButtonColor),
          ),
        ),
      );
    }

    final ingredientes = _ingredientesPorReceta[receta.idReceta!] ?? [];
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

    // Separar ingredientes por tipo
    final ingredientesConCosto = ingredientes
        .where((ing) => (double.tryParse(ing.costoIngrediente) ?? 0) > 0)
        .toList();

    final ingredientesCostoCero = ingredientes
        .where((ing) => double.tryParse(ing.costoIngrediente) == 0.0)
        .toList();

    final ingredientesSinCosto = ingredientes
        .where((ing) => double.tryParse(ing.costoIngrediente) == null)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ingredientesSinStock.isNotEmpty) ...[
            ..._buildIngredientesSinStock(
                ingredientesSinStock, fontSizeModel, themeModel),
          const SizedBox(height: 16),
          ],
          if (ingredientesCostoCero.isNotEmpty) ...[
            ..._buildIngredientesCostoCero(
                ingredientesCostoCero, fontSizeModel, themeModel),
            const SizedBox(height: 16),
          ],
          if (ingredientesSinCosto.isNotEmpty) ...[
            ..._buildIngredientesSinCosto(
                ingredientesSinCosto, fontSizeModel, themeModel),
            const SizedBox(height: 16),
          ],
          if (ingredientesConCosto.isNotEmpty) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: themeModel.primaryButtonColor.withOpacity(0.8),
              margin: const EdgeInsets.only(bottom: 16),
            ),
            Text(
              'Ingredientes:',
              style: TextStyle(
                fontSize: fontSizeModel.textSize,
                fontWeight: FontWeight.bold,
                color: themeModel.primaryButtonColor,
              ),
            ),
            const SizedBox(height: 8),
            ..._buildIngredientesConCosto(
                ingredientesConCosto, fontSizeModel, themeModel),
          const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildIngredientesSinStock(List<String> ingsSinStock,
      FontSizeModel fontSizeModel, ThemeModel themeModel) {
    // Cambiamos para retornar una lista de Widgets
    return [
      divider(),
      Text(
        '• Ingredientes sin Stock',
        style: TextStyle(
          fontSize: fontSizeModel.textSize - 2,
          color: themeModel.secondaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      // Convertimos los ingredientes en una lista de widgets
      ...ingsSinStock.map((ingrediente) => Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 4.0),
            child: Text(
              '• $ingrediente',
              style: TextStyle(
                fontSize: fontSizeModel.textSize - 2,
                color: themeModel.secondaryTextColor,
              ),
            ),
          )),
    ];
  }

  List<Widget> _buildIngredientesConCosto(List<IngredienteReceta> ingredientes,
      FontSizeModel fontSizeModel, ThemeModel themeModel) {
    return [
      ...ingredientes.map(
        (ingrediente) => Padding(
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
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.only(top: 0.0),
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
              '\$${_calcularCostoTotal(ingredientes)}',
              style: TextStyle(
                fontSize: fontSizeModel.textSize,
                color: themeModel.primaryButtonColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildIngredientesCostoCero(List<IngredienteReceta> ingredientes,
      FontSizeModel fontSizeModel, ThemeModel themeModel) {
    return [
      divider(),
      Text(
        '• Ingredientes con costo 0',
        style: TextStyle(
          fontSize: fontSizeModel.textSize - 2,
          color: themeModel.secondaryTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      ...ingredientes.map(
        (ingrediente) => Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 4.0),
          child: Text(
            '• ${ingrediente.nombreIngrediente}',
            style: TextStyle(
              fontSize: fontSizeModel.textSize - 2,
              color: themeModel.secondaryTextColor,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Text(
          'Que el costo de ingredientes sea 0, significa que el producto con el mismo nombre no tiene precio',
          style: TextStyle(
            fontSize: fontSizeModel.textSize - 2,
            color: themeModel.secondaryTextColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildIngredientesSinCosto(List<IngredienteReceta> ingredientes,
      FontSizeModel fontSizeModel, ThemeModel themeModel) {
    return [
      divider(),
      ...ingredientes
          .map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ${ingrediente.nombreIngrediente}:',
                    style: TextStyle(
                      fontSize: fontSizeModel.textSize - 2,
                      color: themeModel.secondaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
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
            ),
          )
          .toList(),
    ];
  }

  Widget _buildConfirmButton() {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    bool isSelectedRecetaAvailable = false;
    if (_selectedRecetaId != null) {
      final selectedReceta =
          Provider.of<RecetasProvider>(context, listen: false)
              .recetas
              .firstWhere((receta) => receta.idReceta == _selectedRecetaId);
      final cost = double.tryParse(selectedReceta.costoReceta!) ?? 0;
      isSelectedRecetaAvailable =
          cost > 0 && (_stockDisponible[_selectedRecetaId] ?? false);
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

  void _confirmSelection() {
    if (_selectedRecetaId != null) {
      final selectedReceta =
          Provider.of<RecetasProvider>(context, listen: false)
              .recetas
              .firstWhere((receta) => receta.idReceta == _selectedRecetaId);

      if (double.tryParse(selectedReceta.costoReceta!) == 0 ||
          !(_stockDisponible[_selectedRecetaId] ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se pueden seleccionar recetas no disponibles')),
        );
      } else {
        widget.onRecetaConfirmada(selectedReceta);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una receta')),
      );
    }
  }

  String _determinarEstadoReceta(Receta receta) {
    CustomLogger()
        .logInfo('Determinando estado para receta: ${receta.idReceta}');

    final costoValido = (double.tryParse(receta.costoReceta ?? '0') ?? 0) > 0;
    final stockDisponible = _stockDisponible[receta.idReceta] ?? false;

    if (!costoValido || !stockDisponible) {
      return 'No disponible';
    }
    return 'Disponible';
  }

  int _calcularCostoTotal(List<IngredienteReceta> ingredientes) {
    return ingredientes
        .fold<double>(
            0.0,
            (sum, ingrediente) =>
                sum + (double.tryParse(ingrediente.costoIngrediente) ?? 0.0))
        .round();
  }

  @override
  void dispose() {
    _stockResultados.clear();
    _stockDisponible.clear();
    _ingredientesSinStock.clear();
    _ingredientesPorReceta.clear();
    _loadingIngredientes.clear();
    super.dispose();
  }
}
