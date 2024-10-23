import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../utils/custom_logger.dart'; // Importamos logger

class DatabaseHelper {
  // Variable estática para la instancia única de la base de datos
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Constructor privado para crear una única instancia
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Inicializamos la base de datos
  Database? _database;

  Future<Database> get database async {
    // Si la base de datos ya ha sido creada, simplemente regresamos esa instancia
    if (_database != null) return _database!;
    // Si no, la creamos
    CustomLogger().logInfo('Inicializando la base de datos...');
    _database = await _initDB();
    return _database!;
  }

  // Método para inicializar la base de datos y crear las tablas
  Future<Database> _initDB() async {
    try {
      // Obtenemos la ruta del directorio donde se almacenará la base de datos
      String path = join(await getDatabasesPath(), 'dp_database.db');
      CustomLogger().logInfo('Ruta de la base de datos: $path');

      // Creamos la base de datos y definimos las tablas
      return await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          // Creación de tablas
          try {
            CustomLogger().logInfo('Creando tablas en la base de datos...');
            // 1 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS Productos (
                    idProducto INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada producto
                    nombreProducto TEXT NOT NULL, -- Nombre del producto
                    precioProducto REAL NOT NULL, -- Precio del producto
                    cantidadProducto REAL NOT NULL, -- Cantidad disponible del producto
                    tipoUnidadProducto TEXT NOT NULL, -- Unidad del producto (ej. kg, litros)
                    cantidadUnidadesProducto REAL NOT NULL -- Cantidad por unidad
                  );
                ''');
            CustomLogger().logInfo('Tabla Productos creada correctamente');

            // 2 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS recetas (
                    idReceta INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada receta
                    nombreReceta TEXT NOT NULL, -- Nombre de la receta
                    descripcionReceta TEXT, -- Descripción de la receta
                    costoReceta TEXT -- Precio de la receta
                  );
                ''');
            CustomLogger().logInfo('Tabla recetas creada correctamente');
            // 3 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS ingredientesRecetas (
                    idIngrediente INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada ingrediente
                    nombreIngrediente TEXT NOT NULL, -- Nombre del ingrediente
                    costoIngrediente TEXT NOT NULL, -- Costo del ingrediente
                    cantidadIngrediente REAL NOT NULL, -- Cantidad usada del ingrediente
                    tipoUnidadIngrediente TEXT NOT NULL, -- Unidad del ingrediente (ej. gramos, litros)
                    idReceta INTEGER, -- ID de la receta asociada
                    FOREIGN KEY (idReceta) REFERENCES recetas(idReceta) -- Relación con la tabla recetas
                  );
                ''');
            CustomLogger()
                .logInfo('Tabla ingredientesRecetas creada correctamente');
            // 4 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS gastosFijos (
                    idGF INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada gasto fijo
                    nombreGF TEXT NOT NULL, -- Nombre del gasto fijo
                    valorGF REAL NOT NULL -- Valor del gasto fijo
                  );
                ''');
            CustomLogger().logInfo('Tabla gastosFijos creada correctamente');
            // 5 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS ventas (
                    idVenta INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada venta
                    nombreVenta TEXT NOT NULL, -- Nombre de la venta
                    horaVenta TEXT NOT NULL, -- Hora de la venta
                    fechaVenta TEXT NOT NULL, -- Fecha de la venta
                    productoVenta TEXT NOT NULL, -- receta a vender
                    cantidadVenta REAL NOT NULL, -- Cantidad de productos que se obtienen de la receta
                    pctjGFVenta REAL NOT NULL, -- Porcentaje de gastos fijos aplicados a la venta
                    desgloseGFVenta TEXT NOT NULL, -- Desglose de gastos fijos
                    precioGFVenta REAL NOT NULL, -- % de GF aplicado a la sumatoria de precios de los gastos fijos aplicado al precio final del producto
                    costoRecetaVenta REAL NOT NULL, -- costo de hacer la receta (ingredientes)
                    pctjGananciaVenta REAL NOT NULL, -- Porcentaje de ganancia deseado con la venta
                    precioPorProductoVenta REAL NOT NULL -- Precio final por producto
                  );
                ''');
            CustomLogger().logInfo('Tabla ventas creada correctamente');
            // 6 -----------------------------------------------------------------------------
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS historialproducto (
                    idHistorialProducto INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada historial
                    antesHP TEXT NOT NULL, -- Cantidad antes del cambio
                    despuesHP TEXT NOT NULL, -- Cantidad después del cambio
                    fechaHP TEXT NOT NULL, -- Fecha del cambio
                    horaHP TEXT NOT NULL -- Hora del cambio
                  );
                ''');
            CustomLogger()
                .logInfo('Tabla historialproducto creada correctamente');
            // 7 -----------------------------------------------------------------------------
            // Creación de la tabla Limitaciones
            await db.execute('''
                  CREATE TABLE IF NOT EXISTS historialGF (
                    idHistorialGF INTEGER PRIMARY KEY AUTOINCREMENT, -- ID único para cada historial de gastos fijos
                    antesHGF TEXT NOT NULL, -- Valor antes del cambio
                    despuesHGF TEXT NOT NULL, -- Valor después del cambio
                    fechaHGF TEXT NOT NULL, -- Fecha del cambio
                    horaHGF TEXT NOT NULL -- Hora del cambio
                  );
                ''');
            CustomLogger().logInfo('Tabla historialGF creada correctamente');

            // Agrega el resto de las tablas aquí, similar al anterior
          } catch (e, stacktrace) {
            CustomLogger().logError(
                'Error al crear las tablas: $e\nStacktrace: $stacktrace');
          }
        },
      );
    } catch (e, stacktrace) {
      CustomLogger().logError(
          'Error al inicializar la base de datos: $e\nStacktrace: $stacktrace');
      rethrow;
    }
  }

  // Método para cerrar la base de datos

  Future<void> closeDB() async {
    try {
      final db = await database;
      db.close();
    } catch (e) {
      CustomLogger().logError('Error al cerrar la base de datos: $e');
    }
  }
}
