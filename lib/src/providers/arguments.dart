class SaveArguments {
  final Map compras;
  final Function callback;
  final Map articulo;

  SaveArguments({this.compras, this.callback, this.articulo});
}

class PrioritizedList {
  final Map compras;
  final double monto;

  PrioritizedList({this.compras, this.monto});
}
