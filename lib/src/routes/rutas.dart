import 'package:flutter/material.dart';
import 'package:priori_dev/src/pages/compras_page.dart';
import 'package:priori_dev/src/pages/nuevo_articulo.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => ComprasPage(),
  };
}
