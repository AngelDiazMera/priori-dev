import 'package:flutter/material.dart';
import 'package:priori_dev/src/pages/compras_page.dart';
import 'package:priori_dev/src/pages/nuevo_articulo.dart';
import 'package:priori_dev/src/pages/priori_page.dart';
import 'package:priori_dev/src/providers/arguments.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => ComprasPage(),
  };
}

MaterialPageRoute getRutaNuevo(settings) {
  final SaveArguments args = settings.arguments;

  return MaterialPageRoute(
      builder: (BuildContext context) => NuevoArticuloPage(
            compras: args.compras,
            callback: args.callback,
            articulo: args.articulo,
          ));
}

MaterialPageRoute getRutaListaPriorizada(settings) {
  final PrioritizedList args = settings.arguments;

  return MaterialPageRoute(
      builder: (BuildContext context) => PrioriPage(
            compras: args.compras,
            monto: args.monto,
          ));
}
