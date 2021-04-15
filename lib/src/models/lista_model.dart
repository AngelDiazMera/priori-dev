//MODELO PENSADO PARA MODELO DE DATOS 2.0
// AÚN NO ESTÁ IMPLEMENTADO

import 'package:flutter/cupertino.dart';

class ListaModel {
  int id;
  String nombre;
  String color;
  String tipo;

  ListaModel(
      {this.id,
      @required this.nombre,
      @required this.color,
      @required this.tipo});

  Map<String, dynamic> toJson() => {
        'idLista': id,
        'nombre': nombre,
        'color': color,
        'tipo': tipo,
      };
}
