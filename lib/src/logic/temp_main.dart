import 'package:priori_dev/src/models/articulo_model.dart';
import 'package:priori_dev/src/providers/db_providers.dart';

import 'controllers/optimizador_controller.dart';
import 'models/optimizador.dart';

void imprimirEntradas(List<ArticuloModel> compras) {
  int id = 0;
  compras.forEach((item) {
    print('$id Prioridad: ${item.prioridad} ;  Precio: ${item.precio}');
    id++;
  });
}

List<ArticuloModel> agregaPriorizados(
    List<ArticuloModel> compras, Optimizador opt) {
  List<ArticuloModel> listaPriori = [];
  double total = 0, precio = 0;
  int id = 0;
  //aqui tendo duda en el ciclo for
  opt.xArr.forEach((value) {
    precio += value * compras[id].precio;
    total += value * compras[id].prioridad;
    print('\t$value veces el articulo ${id + 1}');

    if (value == 1) listaPriori.add(compras[id]);

    id++;
  });
  print('Total ganado: $total');
  print('\tPrecio total:  $precio');
  return listaPriori;
}

List<ArticuloModel> pruebaOptimizacion(
    List<ArticuloModel> compras, double monto) {
  imprimirEntradas(compras);
  print('---------------------------');
  Optimizador opt = Optimizador(compras: compras);
  OptimizadorController optCtrl = OptimizadorController(optimizador: opt);
  optCtrl.optimizar(monto);
  compras = agregaPriorizados(compras, opt);
  return compras;
}
