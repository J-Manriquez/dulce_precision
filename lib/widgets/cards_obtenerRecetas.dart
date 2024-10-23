import 'package:dulce_precision/database/providers/recetas_provider.dart';
import 'package:dulce_precision/models/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObtenerRecetasWG extends StatefulWidget {
  final Function(Receta) onRecetaConfirmada; // Callback para confirmar la receta

  ObtenerRecetasWG({required this.onRecetaConfirmada});

  @override
  _ObtenerRecetasWGState createState() => _ObtenerRecetasWGState();
}

class _ObtenerRecetasWGState extends State<ObtenerRecetasWG> {
  int? _selectedRecetaId; // Almacena el ID de la receta seleccionada
  List<bool> _isExpanded = []; // Controla la expansión de cada tarjeta

  @override
  Widget build(BuildContext context) {
    // Cargar las recetas del proveedor
    Provider.of<RecetasProvider>(context, listen: false).obtenerRecetas();
    final recetaProvider = Provider.of<RecetasProvider>(context);

    // Inicializa el estado expandido de las tarjetas
    if (_isExpanded.length < recetaProvider.recetas.length) {
      _isExpanded = List<bool>.filled(recetaProvider.recetas.length, false);
    }

    return Scaffold(
      body: recetaProvider.recetas.isEmpty
          ? _buildEmptyState() // Construye el estado vacío
          : _buildRecetaListWithButton(recetaProvider), // Construye la lista con el botón
    );
  }

  // Construye el estado vacío cuando no hay recetas
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Recetas no disponibles', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Navegar hacia atrás
            },
            child: Text('Volver'),
          ),
        ],
      ),
    );
  }

  // Construye la lista de recetas junto con el botón de confirmación
  Widget _buildRecetaListWithButton(RecetasProvider recetaProvider) {
    return ListView.builder(
      itemCount: recetaProvider.recetas.length + 1, // Incluye el botón como un elemento adicional
      itemBuilder: (context, index) {
        if (index < recetaProvider.recetas.length) {
          // Construye las tarjetas de recetas
          Receta receta = recetaProvider.recetas[index];
          String estado = _determinarEstadoReceta(receta.costoReceta);
          return Card(
            margin: EdgeInsets.all(8.0),
            color: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              children: [
                _buildListTile(receta, index, estado),
                if (_isExpanded[index]) _buildDetails(receta),
              ],
            ),
          );
        } else {
          // Construye el botón de confirmación al final de la lista
          return _buildConfirmButton();
        }
      },
    );
  }

  // Construye el ListTile para cada receta
  ListTile _buildListTile(Receta receta, int index, String estado) {
    return ListTile(
      leading: Radio<int>(
        value: receta.idReceta!, // El ID de la receta
        groupValue: _selectedRecetaId, // ID de la receta seleccionada
        onChanged: (int? value) {
          setState(() {
            _selectedRecetaId = value; // Actualiza el ID de la receta seleccionada
          });
        },
      ),
      title: Text(
        receta.nombreReceta,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              _isExpanded[index] ? Icons.visibility : Icons.visibility_off,
              color: Colors.blueAccent,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _isExpanded[index] = !_isExpanded[index]; // Alterna la expansión
              });
            },
          ),
          SizedBox(width: 8),
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

  // Construye los detalles de la receta
  Padding _buildDetails(Receta receta) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descripción:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            receta.descripcionReceta ?? 'Sin descripción',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Construye el botón de confirmación
  Widget _buildConfirmButton() {
    return Visibility(
      visible: _selectedRecetaId != null,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _confirmSelection,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.blue,
          ),
          child: Text('Confirmar selección', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  // Confirma la selección de la receta
  // Modificamos _confirmSelection para usar el callback
  void _confirmSelection() {
    if (_selectedRecetaId != null) {
      // Busca la receta seleccionada en el proveedor
      Receta selectedReceta = Provider.of<RecetasProvider>(context, listen: false)
          .recetas
          .firstWhere((receta) => receta.idReceta == _selectedRecetaId);
      widget.onRecetaConfirmada(selectedReceta); // Llama al callback con la receta seleccionada
    } else {
      // Muestra un SnackBar si no hay receta seleccionada
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecciona una receta')),
      );
    }
  }

  // Determina el estado de la receta según su costo
  String _determinarEstadoReceta(String? costoReceta) {
    if (costoReceta == null || costoReceta.isEmpty || double.tryParse(costoReceta) == null) {
      return 'No disponible';
    }
    double? costo = double.tryParse(costoReceta);
    return (costo != null && costo > 0) ? 'Disponible' : 'No disponible';
  }
}
