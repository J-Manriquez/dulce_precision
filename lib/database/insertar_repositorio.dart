// import 'package:dulce_precision/database/metodos/ingredientes_recetas_mtd.dart';
import 'package:dulce_precision/database/metodos/productos_metodos.dart';
import 'package:dulce_precision/database/providers/ingredientes_provider.dart';
import 'package:dulce_precision/database/providers/productos_provider.dart';
import 'package:dulce_precision/database/providers/recetas_provider.dart';
// import 'package:dulce_precision/database/metodos/recetas_metodos.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:dulce_precision/utils/custom_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> insertarRepositorio(BuildContext context) async {
  final productoRepositorio = ProductRepository();
  // final recetaRepository = RecetaRepository();
  // final ingredienteRecetaRepository = IngredienteRecetaRepository();

  try {
    CustomLogger().logInfo('Iniciando inserción de repositorio de productos');

    // Lista de productos que se van a insertar
    var productos = <Producto>[
      Producto(
          nombreProducto: 'Harina',
          precioProducto: 890.0,
          cantidadProducto: 2000.0,
          tipoUnidadProducto: 'gramos',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Azúcar',
          precioProducto: 1090.0,
          cantidadProducto: 2.0,
          tipoUnidadProducto: 'kilogramos',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Vainilla',
          precioProducto: 1150.0,
          cantidadProducto: 155.0,
          tipoUnidadProducto: 'mililitros',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Sal',
          precioProducto: 490.0,
          cantidadProducto: 1.0,
          tipoUnidadProducto: 'kilogramos',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Aceite',
          precioProducto: 1350.0,
          cantidadProducto: 900.0,
          tipoUnidadProducto: 'mililitros',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Huevos',
          precioProducto: 5590.0,
          cantidadProducto: 30.0,
          tipoUnidadProducto: 'unidad',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Margarina',
          precioProducto: 2290.0,
          cantidadProducto: 1.0,
          tipoUnidadProducto: 'kilogramos',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Leche condensada',
          precioProducto: 1690.0,
          cantidadProducto: 1.0,
          tipoUnidadProducto: 'unidad',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Polvos de hornear',
          precioProducto: 1000.0,
          cantidadProducto: 100.0,
          tipoUnidadProducto: 'gramos',
          cantidadUnidadesProducto: 1),
      Producto(
          nombreProducto: 'Limones',
          precioProducto: 1000.0,
          cantidadProducto: 10.0,
          tipoUnidadProducto: 'unidad',
          cantidadUnidadesProducto: 1),
    ];

    // Inserta cada producto en la base de datos
    for (Producto producto in productos) {
      await productoRepositorio.insertProducto(producto);
    }
  } catch (e) {
    CustomLogger().logError('Error al insertar productos: $e');
  }
  try {
    CustomLogger().logInfo('Iniciando inserción de repositorio de recetas');

//     // Lista de recetas
//     var recetas = <Receta>[
//       Receta(
//         idReceta: 1,
//         nombreReceta: 'Pie de Limón',
//         costoReceta: "0",
//         descripcionReceta: '''Masa:
// • Juntar todos los secos en un bowl (harina, azúcar, polvos de hornear).
// • El huevo en un vaso grande con la margarina hasta que se integren lo mejor posible.
// • Mezclar con los secos hasta conseguir una masa firme.
// • Enmantequilla el molde y pon harina encima.
// • Estira la masa en el molde con los dedos y hazle orificios con un tenedor por toda la base y orillas.
// • Pones en el horno precalentado unos 5 min a fuego bajo o a 180°C, a hornear por 15-20 min a fuego bajo medio, o a 200°C. Si es en horno de cocina, cada 8 min se revisa y gira la lata para controlar que no se hornee de un lado más que el otro.

// Relleno:
// • La leche condensada con el jugo de 3 limones se mezcla hasta integrar.
// • Hornea por 5 min o hasta que solidifique.

// Merengue:
// • Haces un almíbar de partes iguales de agua y azúcar, revuelves hasta conseguir burbujas que les cueste reventar.
// • Bates las dos claras de huevo hasta que empiece a formarse el merengue, vas integrando el almíbar en forma de gota, de una vez pero lentamente.

// Montar y listo. ''',
//       ),
//       Receta(
//         idReceta: 2,
//         nombreReceta: 'Para 60 galletas',
//         costoReceta: "0",
//         descripcionReceta:
//             '''• Batís el huevo, la yema, la ralladura de limón (o esencia de vainilla) y el aceite, hasta integrar bien todo. (sal, azúcar, polvo de hornear y harina)
// • Una vez hecha la masa, estiras hasta armar un rollo del ancho deseado.
// • Cortas el rollo en rodajas más o menos de un centímetro cada una. Presionas en el centro de cada una, para armar el huequito para el dulce.
// • Prende el horno para precalentar a fuego medio/bajo.
// • Ahí pasamos al dulce. Si usas frasco de dulce, simplemente rellenas los huequitos de las galletitas.
// • Si usas membrillo (o batata) en pan, vas a ponerlo en una ollita a fuego mínimo para derretirlo y que sea más maleable (podés agregar un poquito de agua, muy poco).
// • Con mucho MUCHO cuidado vas revolviendo el dulce hasta que quede completamente líquido.
// • Una vez derretido, rellenas los huequitos de las galletitas.
// • Acomodas las galletitas en una placa para horno y llevas al horno a 180 grados (fuego medio) entre 12 y 15 minutos, hasta que se doren ligeramente los bordes.
// • SIEMPRE dejar enfriar bien antes de comer porque el dulce caliente quema.''',
//       )
//     ];

// // Inserta cada receta en la base de datos
//     for (Receta receta in recetas) {
//       await recetaRepository.insertReceta(receta);
//     }
//   } catch (e) {
//     CustomLogger().logError('Error al insertar recetas: $e');
//   }
//   try {
//     CustomLogger()
//         .logInfo('Iniciando inserción de repositorio de ingredientes');

//     // Lista de ingredientes para la receta 1
//     var ingredientesRecetas = <IngredienteReceta>[
//       IngredienteReceta(
//           idIngrediente: 1,
//           nombreIngrediente: 'Harina',
//           costoIngrediente: "0",
//           cantidadIngrediente: 300.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 2,
//           nombreIngrediente: 'Azúcar',
//           costoIngrediente: "0",
//           cantidadIngrediente: 300.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 3,
//           nombreIngrediente: 'Huevos',
//           costoIngrediente: "0",
//           cantidadIngrediente: 3.0,
//           tipoUnidadIngrediente: 'unidad',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 4,
//           nombreIngrediente: 'Margarina',
//           costoIngrediente: "0",
//           cantidadIngrediente: 70.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 5,
//           nombreIngrediente: 'Leche condensada',
//           costoIngrediente: "0",
//           cantidadIngrediente: 1.0,
//           tipoUnidadIngrediente: 'unidad',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 6,
//           nombreIngrediente: 'Polvos de Hornear',
//           costoIngrediente: "0",
//           cantidadIngrediente: 45.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 1),
//       IngredienteReceta(
//           idIngrediente: 7,
//           nombreIngrediente: 'Limones',
//           costoIngrediente: "0",
//           cantidadIngrediente: 3.0,
//           tipoUnidadIngrediente: 'unidad',
//           idReceta: 1),
//     ];
//     for (IngredienteReceta ingredienteReceta in ingredientesRecetas) {
//       await ingredienteRecetaRepository
//           .insertarIngredientes([ingredienteReceta], 1);
//     }
//   } catch (e) {
//     CustomLogger().logError('Error al insertar ingredientes: $e');
//   }
//   try {
//     CustomLogger()
//         .logInfo('Iniciando inserción de repositorio de ingredientes');
//     // Lista de ingredientes para la receta 2
//     var ingredientesRecetas2 = <IngredienteReceta>[
//       IngredienteReceta(
//           idIngrediente: 8,
//           nombreIngrediente: 'Harina',
//           costoIngrediente: "0",
//           cantidadIngrediente: 900.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 9,
//           nombreIngrediente: 'Azúcar',
//           costoIngrediente: "0",
//           cantidadIngrediente: 360.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 10,
//           nombreIngrediente: 'Aceite',
//           costoIngrediente: "0",
//           cantidadIngrediente: 240.0,
//           tipoUnidadIngrediente: 'mililitros',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 11,
//           nombreIngrediente: 'Sal',
//           costoIngrediente: "0",
//           cantidadIngrediente: 15.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 12,
//           nombreIngrediente: 'Huevos',
//           costoIngrediente: "0",
//           cantidadIngrediente: 6.0,
//           tipoUnidadIngrediente: 'unidad',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 13,
//           nombreIngrediente: 'Esencia de Vainilla',
//           costoIngrediente: "0",
//           cantidadIngrediente: 45.0,
//           tipoUnidadIngrediente: 'mililitros',
//           idReceta: 2),
//       IngredienteReceta(
//           idIngrediente: 14,
//           nombreIngrediente: 'Polvos de Hornear',
//           costoIngrediente: "0",
//           cantidadIngrediente: 45.0,
//           tipoUnidadIngrediente: 'gramos',
//           idReceta: 2),
//     ];

//     for (IngredienteReceta ingredienteReceta in ingredientesRecetas2) {
//       await ingredienteRecetaRepository
//           .insertarIngredientes([ingredienteReceta], 2);
//     }
  } catch (e) {
    CustomLogger().logError('Error al insertar ingredientes: $e');
  }

  try{
    Provider.of<ProductosProvider>(context, listen: false)
                    .obtenerProductos();
    Provider.of<RecetasProvider>(context,
            listen: false)
        .obtenerRecetas();
    Provider.of<IngredientesRecetasProvider>(
            context,
            listen: false)
        .obtenerIngredientes();
  } catch (e) {
    CustomLogger().logError('Error al actualizar la ui: $e');
  }
}
