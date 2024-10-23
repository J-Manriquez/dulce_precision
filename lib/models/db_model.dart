class Producto {
  final int? idProducto; // Puede ser null al crear un nuevo producto
  final String nombreProducto;
  final double precioProducto;
  final double cantidadProducto;
  final String tipoUnidadProducto;
  final double cantidadUnidadesProducto;

  // Constructor
  Producto({
    this.idProducto,
    required this.nombreProducto,
    required this.precioProducto,
    required this.cantidadProducto,
    required this.tipoUnidadProducto,
    required this.cantidadUnidadesProducto,
  });

  // Sobrescribe el método toString para proporcionar una representación en cadena del objeto
  @override
  String toString() {
    return 'Producto(nombreProducto: $nombreProducto, precioProducto: $precioProducto, cantidadProducto: $cantidadProducto, tipoUnidadProducto: $tipoUnidadProducto, cantidadUnidadesProducto: $cantidadUnidadesProducto)';
  }

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idProducto': idProducto,
      'nombreProducto': nombreProducto,
      'precioProducto': precioProducto,
      'cantidadProducto': cantidadProducto,
      'tipoUnidadProducto': tipoUnidadProducto,
      'cantidadUnidadesProducto': cantidadUnidadesProducto,
    };
  }

  // Método para convertir un mapa en un objeto Producto
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      idProducto: map['idProducto'],
      nombreProducto: map['nombreProducto'],
      precioProducto: map['precioProducto'],
      cantidadProducto: map['cantidadProducto'],
      tipoUnidadProducto: map['tipoUnidadProducto'],
      cantidadUnidadesProducto: map['cantidadUnidadesProducto'],
    );
  }
}

class Receta {
  final int? idReceta;
  final String nombreReceta;
  final String? descripcionReceta; // Puede ser null
  final String? costoReceta; // Puede ser null

  // Constructor
  Receta({
    this.idReceta,
    required this.nombreReceta,
    this.descripcionReceta,
    this.costoReceta,
  });

  // Sobrescribe el método toString para proporcionar una representación en cadena del objeto
  @override
  String toString() {
    return 'Receta(nombreReceta: $nombreReceta, descripcionReceta: $descripcionReceta, costoReceta: $costoReceta)';
  }

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idReceta': idReceta,
      'nombreReceta': nombreReceta,
      'descripcionReceta': descripcionReceta,
      'costoReceta': costoReceta,
    };
  }

  // Método para convertir un mapa en un objeto Receta
  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      idReceta: map['idReceta'],
      nombreReceta: map['nombreReceta'],
      descripcionReceta: map['descripcionReceta'],
      costoReceta: map['costoReceta'],
    );
  }
}

class IngredienteReceta {
  final int? idIngrediente;
  final String nombreIngrediente;
  final String costoIngrediente;
  final double cantidadIngrediente;
  final String tipoUnidadIngrediente;
  int idReceta; // Relacionado con la tabla Recetas

  // Constructor
  IngredienteReceta({
    this.idIngrediente,
    required this.nombreIngrediente,
    required this.costoIngrediente,
    required this.cantidadIngrediente,
    required this.tipoUnidadIngrediente,
    required this.idReceta,
  });

  // Sobrescribe el método toString para proporcionar una representación en cadena del objeto
  @override
  String toString() {
    return 'IngredienteReceta(nombreIngrediente: $nombreIngrediente, costoIngrediente: $costoIngrediente,cantidadIngrediente: $cantidadIngrediente, tipoUnidadIngrediente: $tipoUnidadIngrediente, idReceta: $idReceta)';
  }

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idIngrediente': idIngrediente,
      'nombreIngrediente': nombreIngrediente,
      'costoIngrediente': costoIngrediente,
      'cantidadIngrediente': cantidadIngrediente,
      'tipoUnidadIngrediente': tipoUnidadIngrediente,
      'idReceta': idReceta,
    };
  }

  // Método para convertir un mapa en un objeto IngredienteReceta
  factory IngredienteReceta.fromMap(Map<String, dynamic> map) {
    return IngredienteReceta(
      idIngrediente: map['idIngrediente'],
      nombreIngrediente: map['nombreIngrediente'],
      costoIngrediente: map['costoIngrediente'],
      cantidadIngrediente: map['cantidadIngrediente'],
      tipoUnidadIngrediente: map['tipoUnidadIngrediente'],
      idReceta: map['idReceta'],
    );
  }
}

class GastoFijo {
  final int? idGF;
  final String nombreGF;
  final double valorGF;

  // Constructor
  GastoFijo({
    this.idGF,
    required this.nombreGF,
    required this.valorGF,
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idGF': idGF,
      'nombreGF': nombreGF,
      'valorGF': valorGF,
    };
  }

  // Sobrescribe el método toString para proporcionar una representación en cadena del objeto
  @override
  String toString() {
    return 'GastoFijo(nombreGF: $nombreGF, valorGF: $valorGF)';
  }

  // Método para convertir un mapa en un objeto GastoFijo
  factory GastoFijo.fromMap(Map<String, dynamic> map) {
    return GastoFijo(
      idGF: map['idGF'],
      nombreGF: map['nombreGF'],
      valorGF: map['valorGF'],
    );
  }
}

class Venta {
  final int? idVenta;
  final String nombreVenta;
  final String horaVenta;
  final String fechaVenta;
  final String productoVenta; // Relacionado con la tabla Productos
  final double cantidadVenta;
  final double pctjGFVenta;
  final String desgloseGFVenta;
  final double precioGFVenta;
  final double costoRecetaVenta;
  final double pctjGananciaVenta;
  final double montoGananciaVenta;
  final double precioPorProductoVenta;
  final double precioFinalVenta;

  // Constructor
  Venta({
    this.idVenta,
    required this.nombreVenta,
    required this.horaVenta,
    required this.fechaVenta,
    required this.productoVenta,
    required this.cantidadVenta,
    required this.pctjGFVenta,
    required this.desgloseGFVenta,
    required this.precioGFVenta,
    required this.costoRecetaVenta,
    required this.pctjGananciaVenta,
    required this.montoGananciaVenta,
    required this.precioPorProductoVenta,
    required this.precioFinalVenta,
  });

  // Sobrescribe el método toString para proporcionar una representación en cadena del objeto
  @override
  String toString() {
    return 'Venta(nombreVenta: $nombreVenta, horaVenta: $horaVenta, fechaVenta: $fechaVenta, productoVenta: $productoVenta, cantidadVenta: $cantidadVenta, pctjGFVenta: $pctjGFVenta, desgloseGFVenta: $desgloseGFVenta, precioGFVenta: $precioGFVenta, costoRecetaVenta: $costoRecetaVenta, pctjGananciaVenta: $pctjGananciaVenta, montoGananciaVenta: $montoGananciaVenta, precioPorProductoVenta: $precioPorProductoVenta, precioFinalVenta: $precioFinalVenta)';
  }

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idVenta': idVenta,
      'nombreVenta': nombreVenta,
      'horaVenta': horaVenta,
      'fechaVenta': fechaVenta,
      'productoVenta': productoVenta,
      'cantidadVenta': cantidadVenta,
      'pctjGFVenta': pctjGFVenta,
      'desgloseGFVenta': desgloseGFVenta,
      'precioGFVenta': precioGFVenta,
      'costoRecetaVenta': costoRecetaVenta,
      'pctjGananciaVenta': pctjGananciaVenta,
      'montoGananciaVenta': montoGananciaVenta,
      'precioPorProductoVenta': precioPorProductoVenta,
      'precioFinalVenta': precioFinalVenta,
    };
  }

  // Método para convertir un mapa en un objeto Venta
  factory Venta.fromMap(Map<String, dynamic> map) {
    return Venta(
      idVenta: map['idVenta'],
      nombreVenta: map['nombreVenta'],
      horaVenta: map['horaVenta'],
      fechaVenta: map['fechaVenta'],
      productoVenta: map['productoVenta'],
      cantidadVenta: map['cantidadVenta'],
      pctjGFVenta: map['pctjGFVenta'],
      desgloseGFVenta: map['desgloseGFVenta'],
      precioGFVenta: map['precioGFVenta'],
      costoRecetaVenta: map['costoRecetaVenta'],
      pctjGananciaVenta: map['pctjGananciaVenta'],
      montoGananciaVenta: map['montoGananciaVenta'],
      precioPorProductoVenta: map['precioPorProductoVenta'],
      precioFinalVenta: map['precioFinalVenta'],
    );
  }
}

class HistorialProducto {
  final int? idHistorialProducto;
  final double antesHP;
  final double despuesHP;
  final String fechaHP;
  final String horaHP;

  // Constructor
  HistorialProducto({
    this.idHistorialProducto,
    required this.antesHP,
    required this.despuesHP,
    required this.fechaHP,
    required this.horaHP,
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idHistorialProducto': idHistorialProducto,
      'antesHP': antesHP,
      'despuesHP': despuesHP,
      'fechaHP': fechaHP,
      'horaHP': horaHP,
    };
  }

  // Método para convertir un mapa en un objeto HistorialProducto
  factory HistorialProducto.fromMap(Map<String, dynamic> map) {
    return HistorialProducto(
      idHistorialProducto: map['idHistorialProducto'],
      antesHP: map['antesHP'],
      despuesHP: map['despuesHP'],
      fechaHP: map['fechaHP'],
      horaHP: map['horaHP'],
    );
  }
}

class HistorialGF {
  final int? idHistorialGF;
  final double antesHGF;
  final double despuesHGF;
  final String fechaHGF;
  final String horaHGF;

  // Constructor
  HistorialGF({
    this.idHistorialGF,
    required this.antesHGF,
    required this.despuesHGF,
    required this.fechaHGF,
    required this.horaHGF,
  });

  // Método para convertir el objeto en un mapa
  Map<String, dynamic> toMap() {
    return {
      'idHistorialGF': idHistorialGF,
      'antesHGF': antesHGF,
      'despuesHGF': despuesHGF,
      'fechaHGF': fechaHGF,
      'horaHGF': horaHGF,
    };
  }

  // Método para convertir un mapa en un objeto HistorialGF
  factory HistorialGF.fromMap(Map<String, dynamic> map) {
    return HistorialGF(
      idHistorialGF: map['idHistorialGF'],
      antesHGF: map['antesHGF'],
      despuesHGF: map['despuesHGF'],
      fechaHGF: map['fechaHGF'],
      horaHGF: map['horaHGF'],
    );
  }
}
