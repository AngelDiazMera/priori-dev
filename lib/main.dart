import 'package:flutter/material.dart';

import 'package:priori_dev/src/pages/compras_page.dart';

import 'package:priori_dev/src/colors/tema.dart';
import 'package:priori_dev/src/pages/nuevo_articulo.dart';
import 'package:priori_dev/src/providers/arguments.dart';
import 'package:priori_dev/src/routes/rutas.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Priori-Dev', // Título de la app
      debugShowCheckedModeBanner: false, // Elimina bandera de debug
      theme: getApplicationTheme(),
      // Pagina principal
      // home: ComprasPage(),
      //Definición de rutas
      initialRoute: '/',
      routes: getApplicationRoutes(), // Rutas de función externa
      onGenerateRoute: (RouteSettings settings) {
        // Pasar argumentos a la ruta /nuevo
        if (settings.name == '/nuevo') {
          final SaveArguments args = settings.arguments;

          return MaterialPageRoute(
              builder: (BuildContext context) => NuevoArticuloPage(
                    compras: args.compras,
                    callback: args.callback,
                    articulo: args.articulo,
                  ));
        }
        // Si la ruta no es encontrada
        return MaterialPageRoute(
            builder: (BuildContext context) => ComprasPage());
      },
    );
  }
}
