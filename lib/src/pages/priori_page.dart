import 'package:flutter/material.dart';
import 'package:priori_dev/src/colors/colores.dart';

// ignore: must_be_immutable
class PrioriPage extends StatefulWidget {
  Map<int, Map<String, dynamic>> compras;
  double monto;
  PrioriPage({Key key, @required this.compras, @required this.monto})
      : super(key: key);

  @override
  _PrioriPageState createState() => _PrioriPageState();
}

class _PrioriPageState extends State<PrioriPage> {
  final Map<int, Map<String, dynamic>> _listaCompras = {};
  double _total = 00.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: _crearAppbar(),
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: _crearContenido(),
        ),
      ),
    );
  }

  List<Widget> _crearContenido() {
    List<Widget> contenido = [];

    widget.compras.forEach((key, articulo) {
      contenido
        ..add(
          _crearArticulo(key, articulo),
        )
        ..add(SizedBox(height: 10.0));
    });
    return contenido;
  }

  Widget _crearArticulo(int key, Map<String, dynamic> articulo) {
    bool esSeleccionado = _listaCompras.containsKey(key);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!esSeleccionado) {
            _listaCompras[key] = articulo;
            _total += _listaCompras[key]['precio'];
          } else {
            _total -= _listaCompras[key]['precio'];
            _listaCompras.remove(key);
          }
        });
      },
      child: AnimatedContainer(
        // Propiedades de la animación
        duration: Duration(milliseconds: 350),
        curve: Curves.fastOutSlowIn,
        // Propiedades del contenedor
        height: 92.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.0),
          color: esSeleccionado ? getColor('articuloSelec') : Colors.white,
        ),
        // List view para que no exista error respecto al overflow
        child: Row(
          children: <Widget>[
            Flexible(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        articulo['nombre'],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${articulo['descripcion']}',
                        style: TextStyle(
                            fontSize: 14, color: getColor('articuloDesc')),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.monetization_on_rounded,
                            size: 14, color: getColor('articuloDesc')),
                        SizedBox(width: 5),
                        Text('${articulo['precio']}',
                            style: TextStyle(
                                fontSize: 14, color: getColor('articuloDesc'))),
                        Expanded(child: SizedBox()),
                        Icon(Icons.escalator_sharp,
                            size: 14, color: getColor('articuloDesc')),
                        SizedBox(width: 5),
                        Text('${articulo['prioridad']}',
                            style: TextStyle(
                                fontSize: 14, color: getColor('articuloDesc'))),
                        Expanded(child: SizedBox()),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _crearCheckbox(key, articulo, esSeleccionado),
            )
          ],
        ),
      ),
    );
  }

  // Crea un checkbox personalizado
  Widget _crearCheckbox(key, articulo, esSeleccionado) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: getColor('avatar'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        // Cuando la propiedad sea verdadera, dibuja una palomita, sino, un recuadro
        child: esSeleccionado
            ? Icon(
                Icons.check,
                size: 20.0,
                color: Colors.white,
              )
            : Icon(
                Icons.check_box_outline_blank,
                size: 20.0,
                color: Color.fromRGBO(255, 255, 255, 0),
              ),
      ),
    );
  }

  Widget _contenedorHeader(String titulo, String texto) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
          Align(alignment: Alignment.center, child: Text(texto))
        ],
      ),
    );
  }

  Widget _crearAppbar() {
    return AppBar(
      backgroundColor: getColor('fondo'),
      title: Text('Lista de compras'),
      iconTheme: IconThemeData(color: getColor('texto')),
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(child: SizedBox()),
              _contenedorHeader('Presupuesto', '\$${widget.monto}'),
              Container(
                child: VerticalDivider(
                  color: getColor('texto'),
                  width: 20.0,
                  thickness: 1.5,
                ),
                height: 30,
              ),
              _contenedorHeader('Total', '\$$_total'),
            ],
          ),
        ),
      ),
    );
  }
}
