import 'package:flutter/material.dart';

class FontSizeModel with ChangeNotifier {
  // Tamaños predeterminados
  double _titleSize = 26.0;
  double _subtitleSize = 20.0;
  double _textSize = 18.0;
  double _iconSize = 26.0;

  // Getters para obtener los tamaños
  double get titleSize => _titleSize;
  double get subtitleSize => _subtitleSize;
  double get textSize => _textSize;
  double get iconSize => _iconSize;

  // Métodos para actualizar los tamaños
  void setTitleSize(double size) {
    _titleSize = size;
    notifyListeners(); // Notificamos a los widgets para que se actualicen
  }

  void setSubtitleSize(double size) {
    _subtitleSize = size;
    notifyListeners();
  }

  void setTextSize(double size) {
    _textSize = size;
    notifyListeners();
  }

  void setIconSize(double size) {
    _iconSize = size;
    notifyListeners();
  }

  // Método para restablecer los tamaños a los valores predeterminados
  void resetFontSizes() {
    _titleSize = 24.0;
    _subtitleSize = 18.0;
    _textSize = 14.0;
    _iconSize = 14.0;
    notifyListeners();
  }
}
