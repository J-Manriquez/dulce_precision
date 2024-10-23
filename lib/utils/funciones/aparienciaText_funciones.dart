String mayuscPrimeraLetra(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

int convertirYRedondear(String text) {
  // Convertir el texto a double
  double value = double.parse(text);
  // Redondear el valor a entero
  int roundedValue = value.round();
  // Retornar el valor redondeado
  return roundedValue;
}