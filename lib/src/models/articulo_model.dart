import 'package:flutter/cupertino.dart';

class ArticuloModel {
  int id;
  String nombre;
  double precio;
  int prioridad;
  String descripcion;
  bool seleccionado;

  ArticuloModel(
      {this.id,
      @required this.nombre,
      @required this.precio,
      @required this.prioridad,
      @required this.descripcion,
      this.seleccionado = true});

  Map<String, dynamic> toJson() => {
        'idArticulo': id,
        'nombre': nombre,
        'precio': precio,
        'prioridad': prioridad,
        'descripcion': descripcion,
      };

  factory ArticuloModel.fromJson(Map<String, dynamic> json) => ArticuloModel(
        id: json['idArticulo'],
        nombre: json['nombre'],
        precio: json['precio'].toDouble(),
        prioridad: json['prioridad'],
        descripcion: json['descripcion'],
      );

  @override
  String toString() {
    return {
      'idArticulo': id,
      'nombre': nombre,
      'precio': precio,
      'prioridad': prioridad,
      'descripcion': descripcion,
      'seleccionado': seleccionado,
    }.toString();
  }
}
