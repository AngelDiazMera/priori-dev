import 'package:flutter/material.dart';
import 'package:priori_dev/src/colors/colores.dart';

Widget crearInput(
    {String tipo,
    TextEditingController control,
    String nombre,
    Function callback}) {
  TextInputType _tipo =
      tipo == 'numero' ? TextInputType.number : TextInputType.text;

  return TextField(
    controller:
        control, // carga los datos definidos por el controlador. Recuerde que si es un artículo nuevo, se cargará una cadena vacía, pero si es un artículo para editar, cargará el dato correspondiente.

    keyboardType: _tipo, // Define el tipo de caja de texto que se va a dibujar
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 10.0),
      // Propiedades del borde
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17.0),
        borderSide: BorderSide(color: getColor('inputBorder'), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17.0),
        borderSide: BorderSide(color: Colors.white, width: 0),
      ),
      labelText: nombre,
      labelStyle: TextStyle(color: getColor('inputLabel')),
      // Para el fondo
      isDense: true,
      filled: true,
      fillColor: Colors.white,
    ),

    onChanged: (valor) => callback(valor),
  );
}
