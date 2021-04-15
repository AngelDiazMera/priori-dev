import 'package:priori_dev/src/models/articulo_model.dart';

class SaveArguments {
  final List compras;
  final Function callback;
  final ArticuloModel articulo;

  SaveArguments({this.compras, this.callback, this.articulo});
}

class PrioritizedList {
  final List compras;
  final double monto;

  PrioritizedList({this.compras, this.monto});
}
