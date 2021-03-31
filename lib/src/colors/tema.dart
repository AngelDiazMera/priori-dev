import 'package:flutter/material.dart';

import 'colores.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primaryColor:
        getColor('principal'), // Color principal (se muestra en el appbar)
    accentColor: getColor('principal'), // Color de acento (como para botones)
    // primarySwatch: Colors.blue[50],
    primaryTextTheme: TextTheme(
        headline6:
            TextStyle(color: getColor('texto'))), // Color del título del appbar
    textTheme: TextTheme(
      bodyText2:
          TextStyle(color: getColor('texto')), // Color del texto de la app
    ),
    scaffoldBackgroundColor: getColor('fondo'),
  );
}
