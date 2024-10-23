import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  // Colores predeterminados para el tema personalizado
  Color _backgroundColor = const Color.fromRGBO(30, 30, 30, 1); 
  Color  _primaryButtonColor = const Color.fromRGBO(0, 108, 161, 1); 
  Color  _secondaryButtonColor = const Color.fromRGBO(245, 245, 245, 1);
  Color  _primaryTextColor = const Color.fromRGBO(245, 245, 245, 1);
  Color  _secondaryTextColor = const Color.fromRGBO(30, 30, 30, 1); 
  Color  _primaryIconColor = const Color.fromRGBO(30, 30, 30, 1); 
  Color  _secondaryIconColor = const Color.fromRGBO(245, 245, 245, 1);

  // Getters para los colores
  Color get backgroundColor => _backgroundColor;
  Color get primaryButtonColor => _primaryButtonColor;
  Color get secondaryButtonColor => _secondaryButtonColor;
  Color get primaryTextColor => _primaryTextColor;
  Color get secondaryTextColor => _secondaryTextColor;
  Color get primaryIconColor => _primaryIconColor;
  Color get secondaryIconColor => _secondaryIconColor;

  // Setters para cambiar los colores y notifican a los listeners
  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  void setPrimaryButtonColor(Color color) {
    _primaryButtonColor = color;
    notifyListeners();
  }

  void setSecondaryButtonColor(Color color) {
    _secondaryButtonColor = color;
    notifyListeners();
  }

  void setPrimaryTextColor(Color color) {
    _primaryTextColor = color;
    notifyListeners();
  }

  void setSecondaryTextColor(Color color) {
    _secondaryTextColor = color;
    notifyListeners();
  }

  void setPrimaryIconColor(Color color) {
    _primaryIconColor = color;
    notifyListeners();
  }

  void setSecondaryIconColor(Color color) {
    _secondaryIconColor = color;
    notifyListeners();
  }

  // Tema claro
  void setLightTheme() {
    _backgroundColor = const Color.fromRGBO(255, 255, 194, 1); // amarillo pastel claro
    _primaryButtonColor = const Color.fromRGBO(226, 107, 105, 1); // Botón café pastel
    _secondaryButtonColor = const Color.fromRGBO(255, 255, 102, 1); // Botón rojo brillante
    _primaryTextColor = const Color.fromRGBO(255, 255, 194, 1); // Texto pastel claro
    _secondaryTextColor = const Color.fromRGBO(30, 30, 30, 1); // Texto oscuro
    _primaryIconColor = const Color.fromRGBO(255, 255, 194, 1); // Icono pastel claro
    _secondaryIconColor = const Color.fromRGBO(30, 30, 30, 1);  // Icono azul brillante
    notifyListeners();
  }

  // Tema oscuro
  void setDarkTheme() {
    _backgroundColor = const Color.fromRGBO(30, 30, 30, 1); 
    _primaryButtonColor = const Color.fromRGBO(0, 108, 161, 1); 
    _secondaryButtonColor = const Color.fromRGBO(245, 245, 245, 1);
    _primaryTextColor = const Color.fromRGBO(30, 30, 30, 1); 
    _secondaryTextColor = const Color.fromRGBO(245, 245, 245, 1);
    _primaryIconColor = const Color.fromRGBO(30, 30, 30, 1); 
    _secondaryIconColor = const Color.fromRGBO(245, 245, 245, 1);
    notifyListeners();
  }

  // Tema personalizado
  void setCustomTheme() {
    _backgroundColor = const Color.fromRGBO(255, 255, 194, 1); // Fondo pastel claro
    _primaryButtonColor = const Color.fromRGBO(211, 177, 150, 1); // Botón café pastel
    _secondaryButtonColor = const Color.fromRGBO(203, 40, 40, 1); // Botón rojo brillante
    _primaryTextColor = const Color.fromRGBO(255, 255, 194, 1); // Texto pastel claro
    _secondaryTextColor = const Color.fromRGBO(30, 30, 30, 1); // Texto oscuro
    _primaryIconColor = const Color.fromRGBO(255, 255, 194, 1); // Icono pastel claro
    _secondaryIconColor = const Color.fromRGBO(109, 82, 61, 1); // Icono café oscuro
    notifyListeners();
  }
}
