import 'package:flutter/material.dart';
import 'package:priori_dev/src/colors/colores.dart';

// Alerta de confirmación para la eliminación
Future<bool> mostrarAlert(BuildContext context, key, String mensaje,
    IconData icono, List<String> botones) {
  return showDialog(
    context: context, // Contexto de la aplicación (ES NECESARIO)
    barrierDismissible: true, //Para el clikc afuera y salir
    builder: (context) {
      return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          // configuración del diálogo
          content: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  icono,
                  color: getColor('texto'),
                  size: 40.0,
                ),
              ),
              Expanded(child: Text(mensaje)),
            ],
          ),
          actions: _crearBotones(context, botones));
    },
  );
}

List<Widget> _crearBotones(context, List<String> botones) {
  List<Widget> widgets = [];
  botones.forEach((texto) {
    bool primero = botones.indexWhere((element) => element == texto) == 0;
    widgets.add(
      FlatButton(
        onPressed: () => Navigator.of(context).pop(!primero),
        child: Text(
          texto,
          style: TextStyle(color: getColor('texto')),
        ),
      ),
    );
    if (primero) widgets.add(Expanded(child: SizedBox()));
  });
  return widgets;
}
