import 'package:flutter/material.dart';

final _colores = <String, Color>{
  'principal': Color.fromRGBO(91, 149, 209, 1),
  'texto': Color.fromRGBO(33, 103, 154, 1),
  'articuloDesc': Color.fromRGBO(33, 103, 154, 0.75),
  'fondo': Color.fromRGBO(249, 251, 252, 1),
  'avatar': Color.fromRGBO(91, 149, 209, 0.4),
  'inputBorder': Color.fromRGBO(220, 220, 220, 1),
  'inputLabel': Color.fromRGBO(112, 112, 112, 1),
};

Color getColor(String nombreColor) {
  return _colores[nombreColor];
}
