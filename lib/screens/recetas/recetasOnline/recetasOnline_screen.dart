import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:dulce_precision/widgets/confirmGenerica_widget.dart';
import 'package:flutter/material.dart';
import 'package:dulce_precision/database/metodos/recetas_metodos.dart';
import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:provider/provider.dart';

class RecetarioOnlineScreen extends StatefulWidget {
  const RecetarioOnlineScreen({super.key});

  @override
  _RecetarioOnlineScreenState createState() => _RecetarioOnlineScreenState();
}

class _RecetarioOnlineScreenState extends State<RecetarioOnlineScreen> {
  final RecetaRepository recetaRepository = RecetaRepository();
  final IngredienteRecetaRepository ingredienteRecetaRepository =
      IngredienteRecetaRepository();

  // Lista de recetas inicializada como una lista vacía
  List<Receta> recetas = [];
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    // Cargar las recetas al iniciar
    _loadRecetas();
  }

  void _loadRecetas() {
    setState(() {
      recetas = [
        Receta(
          idReceta: 1,
          nombreReceta: 'Pie de Limón',
          costoReceta: "0",
          descripcionReceta: '''Masa:
• Juntar todos los secos en un bowl (harina, azúcar, polvos de hornear).
• El huevo en un vaso grande con la margarina hasta que se integren lo mejor posible.
• Mezclar con los secos hasta conseguir una masa firme.
• Enmantequilla el molde y pon harina encima.
• Estira la masa en el molde con los dedos y hazle orificios con un tenedor por toda la base y orillas.
• Pones en el horno precalentado unos 5 min a fuego bajo o a 180°C, a hornear por 15-20 min a fuego bajo medio, o a 200°C. Si es en horno de cocina, cada 8 min se revisa y gira la lata para controlar que no se hornee de un lado más que el otro.

Relleno:
• La leche condensada con el jugo de 3 limones se mezcla hasta integrar.
• Hornea por 5 min o hasta que solidifique.

Merengue:
• Haces un almíbar de partes iguales de agua y azúcar, revuelves hasta conseguir burbujas que les cueste reventar.
• Bates las dos claras de huevo hasta que empiece a formarse el merengue, vas integrando el almíbar en forma de gota, de una vez pero lentamente.

Montar y listo. ''',
        ),
        Receta(
          idReceta: 2,
          nombreReceta: 'Para 60 galletas',
          costoReceta: "0",
          descripcionReceta:
              '''• Batís el huevo, la yema, la ralladura de limón (o esencia de vainilla) y el aceite, hasta integrar bien todo. (sal, azúcar, polvo de hornear y harina)
• Una vez hecha la masa, estiras hasta armar un rollo del ancho deseado.
• Cortas el rollo en rodajas más o menos de un centímetro cada una. Presionas en el centro de cada una, para armar el huequito para el dulce.
• Prende el horno para precalentar a fuego medio/bajo.
• Ahí pasamos al dulce. Si usas frasco de dulce, simplemente rellenas los huequitos de las galletitas.
• Si usas membrillo (o batata) en pan, vas a ponerlo en una ollita a fuego mínimo para derretirlo y que sea más maleable (podés agregar un poquito de agua, muy poco).
• Con mucho MUCHO cuidado vas revolviendo el dulce hasta que quede completamente líquido.
• Una vez derretido, rellenas los huequitos de las galletitas.
• Acomodas las galletitas en una placa para horno y llevas al horno a 180 grados (fuego medio) entre 12 y 15 minutos, hasta que se doren ligeramente los bordes.
• SIEMPRE dejar enfriar bien antes de comer porque el dulce caliente quema.''',
        ),
      ];
      // Inicializar la lista _isExpanded con el mismo tamaño que recetas
      _isExpanded = List.generate(recetas.length, (_) => false);
    });
  }

  Future<void> _addRecipe(int index) async {
    var msj = '¿Está seguro de que desea agregar esta receta?';
    final confirm = await ConfirmDialog.mostrarConfirmacion(context, msj);

    if (confirm == true) {
      try {
        await recetaRepository.insertReceta(recetas[index]);
        var ingredientes = _getIngredientsForRecipe(index);
        await ingredienteRecetaRepository.insertarIngredientes(
            ingredientes, recetas[index].idReceta!);
        CustomLogger()
            .logInfo('Receta y sus ingredientes insertados correctamente');
      Provider.of<RecetasProvider>(context, listen: false).obtenerRecetas();

      } catch (e) {
        CustomLogger().logError('Error al insertar receta: $e');
      }
    } else {
      CustomLogger().logInfo('El usuario canceló la adición de la receta.');
    }
  }

  List<IngredienteReceta> _getIngredientsForRecipe(int index) {
  // Verificar cuál receta se está seleccionando y devolver los ingredientes correspondientes
  if (index == 0) {
    // Ingredientes para la primera receta (Pie de Limón)
    return [
      IngredienteReceta(
          idIngrediente: 1,
          nombreIngrediente: 'Harina',
          costoIngrediente: "0",
          cantidadIngrediente: 300.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 2,
          nombreIngrediente: 'Azúcar',
          costoIngrediente: "0",
          cantidadIngrediente: 300.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 3,
          nombreIngrediente: 'Huevos',
          costoIngrediente: "0",
          cantidadIngrediente: 3.0,
          tipoUnidadIngrediente: 'unidad',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 4,
          nombreIngrediente: 'Margarina',
          costoIngrediente: "0",
          cantidadIngrediente: 70.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 5,
          nombreIngrediente: 'Leche condensada',
          costoIngrediente: "0",
          cantidadIngrediente: 1.0,
          tipoUnidadIngrediente: 'unidad',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 6,
          nombreIngrediente: 'Polvos de Hornear',
          costoIngrediente: "0",
          cantidadIngrediente: 45.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 1),
      IngredienteReceta(
          idIngrediente: 7,
          nombreIngrediente: 'Limones',
          costoIngrediente: "0",
          cantidadIngrediente: 3.0,
          tipoUnidadIngrediente: 'unidad',
          idReceta: 1),
    ];
  } else if (index == 1) {
    // Ingredientes para la segunda receta (Para 60 galletas)
    return [
      IngredienteReceta(
          idIngrediente: 8,
          nombreIngrediente: 'Harina',
          costoIngrediente: "0",
          cantidadIngrediente: 900.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 9,
          nombreIngrediente: 'Azúcar',
          costoIngrediente: "0",
          cantidadIngrediente: 360.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 10,
          nombreIngrediente: 'Aceite',
          costoIngrediente: "0",
          cantidadIngrediente: 240.0,
          tipoUnidadIngrediente: 'mililitros',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 11,
          nombreIngrediente: 'Sal',
          costoIngrediente: "0",
          cantidadIngrediente: 15.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 12,
          nombreIngrediente: 'Huevos',
          costoIngrediente: "0",
          cantidadIngrediente: 6.0,
          tipoUnidadIngrediente: 'unidad',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 13,
          nombreIngrediente: 'Esencia de Vainilla',
          costoIngrediente: "0",
          cantidadIngrediente: 45.0,
          tipoUnidadIngrediente: 'mililitros',
          idReceta: 2),
      IngredienteReceta(
          idIngrediente: 14,
          nombreIngrediente: 'Polvos de Hornear',
          costoIngrediente: "0",
          cantidadIngrediente: 45.0,
          tipoUnidadIngrediente: 'gramos',
          idReceta: 2),
    ];
  }
  // Retornar una lista vacía si el índice no corresponde a ninguna receta
  return [];
}


  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recetario Online',
          style: TextStyle(
            fontSize: fontSizeModel.titleSize,
            color: themeModel.primaryTextColor,
          ),
        ),
        backgroundColor: themeModel.primaryButtonColor,
      ),
      body: recetas.isEmpty
          ? Center(
              child: Text(
                'No hay recetas disponibles',
                style: TextStyle(
                  fontSize: fontSizeModel.textSize,
                ),
              ),
            )
          : ListView.builder(
              itemCount: recetas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          recetas[index].nombreReceta,
                          style: TextStyle(
                            fontSize: fontSizeModel.titleSize*0.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isExpanded[index]
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isExpanded[index] = !_isExpanded[index];
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _addRecipe(index),
                            ),
                          ],
                        ),
                      ),
                      if (_isExpanded[index])
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alinear a la izquierda
                            children: [
                              Text(
                                'Ingredientes:',
                                style: TextStyle(
                                  fontSize: fontSizeModel.subtitleSize, // Aumentar el tamaño de la fuente
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Listar los ingredientes
                              ..._getIngredientsForRecipe(index)
                                  .map((ingrediente) {
                                return Text(
                                  '• ${ingrediente.cantidadIngrediente.round()} ${ingrediente.tipoUnidadIngrediente} de ${ingrediente.nombreIngrediente}',
                                  style: TextStyle(
                                    fontSize: fontSizeModel.textSize,
                                    color: themeModel.secondaryTextColor,
                                  ),
                                );
                              }),
                              const SizedBox(height: 16.0),
                              Text(
                                'Descripción:',
                                style: TextStyle(
                                  fontSize: fontSizeModel.subtitleSize, // Aumentar el tamaño de la fuente
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Muestra la descripción de la receta
                              Text(
                                recetas[index].descripcionReceta!,
                                style: TextStyle(
                                  fontSize: fontSizeModel.textSize,
                                  color: themeModel.secondaryTextColor,
                                ),
                              ),
                              // Espaciado entre descripción y lista de ingredientes
                              // Título para la lista de ingredientes
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
