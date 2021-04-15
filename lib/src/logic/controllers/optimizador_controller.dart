import 'package:priori_dev/src/logic/models/optimizador.dart';

class OptimizadorController {
  Optimizador optimizador;

  OptimizadorController({this.optimizador});

  getSelected() => optimizador.xArr;

  void optimizar(double dinero) {
    double add = 0, preliminar;
    int elem = 0;
    List<int> seleccionados = [];

    while (add <= dinero && elem < optimizador.compras.length) {
      var i = _voraSelection(seleccionados);
      seleccionados.add(i);
      print(seleccionados);
      preliminar = add + optimizador.compras[i].precio;
      print('calculo: $add + ${optimizador.compras[i].precio}');
      print('total peliminar: $preliminar/$dinero');
      if (preliminar <= dinero) {
        optimizador.xArr[i] = 1;
        add = add + optimizador.compras[i].precio;
      } else {
        optimizador.xArr[i] = 0;
        // add = dinero;
      }
      print('Total agregado: $add');
      elem++;
    }
  }

  int _voraSelection(List<int> seleccionados) {
    int sel = 0, id;
    double per = 0, maxPer = 0;

    for (id = 0; id < optimizador.compras.length; id++) {
      if (optimizador.xArr[id] != 0) continue;
      if (seleccionados.contains(id)) continue;

      per = (1 / optimizador.compras[id].prioridad) /
          optimizador.compras[id].precio;
      print('Porcentaje $id: $per');
      if (per > maxPer) {
        sel = id;
        maxPer = per;
      }
    }
    return sel;
  }
}
