import 'package:priori_dev/src/models/articulo_model.dart';

class Optimizador {
  List xArr;
  List<ArticuloModel> compras;

  Optimizador({this.compras}) {
    xArr = _makeEmptyArr();
  }

  List _makeEmptyArr() {
    List newArr = [];
    this.compras.forEach((item) => newArr.add(0));
    return newArr;
  }
}
