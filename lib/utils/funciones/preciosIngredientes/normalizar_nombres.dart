import 'dart:core';

// Función para normalizar un texto dado.
// Esta función convierte el texto a minúsculas, quita los espacios adicionales
// y reemplaza las tildes con letras equivalentes sin tilde.
String normalizar(String texto) {
  // Convertimos el texto a minúsculas para evitar problemas de coincidencia por mayúsculas/minúsculas.
  String textoNormalizado = texto.toLowerCase();

  // Removemos los espacios adicionales al principio y al final del texto.
  textoNormalizado = textoNormalizado.trim();

  // Reemplazamos todas las tildes con sus equivalentes sin tilde.
  textoNormalizado = textoNormalizado
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ñ', 'n'); // También reemplazamos la letra ñ con n para evitar problemas.

  // Retornamos el texto normalizado.
  return textoNormalizado;
}
