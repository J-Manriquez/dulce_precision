import 'package:dulce_precision/models/font_size_model.dart';
import 'package:dulce_precision/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  final bool readOnly;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final String? labelText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final TextStyle? style;

  CustomTextField({
    this.readOnly = false,
    this.controller,
    this.decoration,
    this.labelText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.style,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false; // Variable para manejar el enfoque

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final fontSizeModel = Provider.of<FontSizeModel>(context);
    

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus; // Actualiza el estado de enfoque
        });
      },
      child: TextField(
        readOnly: widget.readOnly,
        controller: widget.controller,
        decoration: (widget.decoration ?? InputDecoration()).copyWith(
              labelText: widget.labelText,
              suffixIcon: widget.suffixIcon,
              labelStyle: TextStyle(
                fontSize: fontSizeModel.textSize,
                color: _isFocused 
                    ? themeModel.primaryButtonColor // Color cuando está enfocado
                    : themeModel.secondaryTextColor, // Color cuando no está enfocado
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeModel.secondaryTextColor, // Borde cuando no está enfocado
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: themeModel.primaryButtonColor, // Borde al enfocar
                  width: 2.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.8), // Borde en caso de error
                  width: 2.0,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple, // Borde cuando está deshabilitado
                  width: 2.0,
                ),
              ),
            ),
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        style: widget.style,
      ),
    );
  }
}
