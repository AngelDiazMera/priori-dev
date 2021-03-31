import 'package:flutter/material.dart';

import 'package:priori_dev/src/colors/Colores.dart';
import 'package:priori_dev/src/providers/arguments.dart';
import 'package:priori_dev/src/temp/compras.dart';

class ComprasPage extends StatefulWidget {
  // Constructor
  ComprasPage({Key key}) : super(key: key);

  // Creación de estado
  @override
  _ComprasPageState createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  Map<int, Map<String, dynamic>> _artSelec;
  // Valores utilizados para el texto de los input
  double _monto = 0;
  String _busqueda = '';
  // Mapa de la "lista" de compras
  Map<int, Map<String, dynamic>> _compras;
  // Datos del artículo seleccionado por el usuario
  Map<String, dynamic> _artActivo;

  void initState() {
    //Esta funcioon es para ahorrar memoria, solo lanza este elemento cuando la aplicacion se abre y no la mantiene en uso en tiempo de inactividad
    super.initState();
    // carga los datos de una función externa llamada getCompras
    _compras = getCompras();
    _artSelec = getCompras();
    print(_artSelec);
  }

  /*Nota: Una appbar personalizada puede ser de la siguiente forma
  PreferredSize(
    preferredSize: Size.fromHeight(100),
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(color: getColor('fondo')),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  'Lista de compras',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: getColor('avatar'),
              ),
            ),
          ),
        )
      ],
    ),
  ),
),*/

  @override
  Widget build(BuildContext context) {
    // Construcción del Scaffold
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor('fondo'),
        title: Text('Compras'),
        elevation: 0.0,
        // backgroundColor: Color.fromRGBO(249, 251, 252, 1),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              // child: Text('MR'),
              backgroundColor: getColor('avatar'),
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: _crearContenido(), // Contenido del listview
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/nuevo',
            // De la clase SaveArguments, crea los argumentos para la página
            arguments: SaveArguments(
              compras: _compras,
              // Almacena un nuevo valor en el mapa
              callback: (map) {
                int last;
                _compras.forEach((key, value) => last = key);
                map['id'] = last + 1;
                map['seleccionado'] = true;
                setState(() => _compras[last + 1] = map);
              },
              articulo: null,
            ),
          );
        },
      ),
    );
  }

  // Crea un input de texto
  Widget _crearInput(tipo) {
    return TextField(
      // Si es un monto, entonces será numérico
      keyboardType: tipo == 'monto' ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        // Padding
        contentPadding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 10.0),
        // Propiedades de los bordes
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: BorderSide(color: getColor('inputBorder'), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17.0),
          borderSide: BorderSide(color: Colors.white, width: 0),
        ),
        // Label
        labelText: tipo == 'monto'
            ? 'Monto'
            : tipo == 'busqueda'
                ? 'Buscar'
                : 'ND',
        labelStyle: TextStyle(color: getColor('inputLabel')),
        // Para el relleno
        isDense: true,
        filled: true,
        fillColor: Colors.white,
      ),
      // Actualización de estado
      onChanged: (valor) {
        setState(() {
          if (tipo == 'monto') _monto = double.parse(valor);
          if (tipo == 'busqueda') _busqueda = valor;
        });
      },
    );
  }

  // Crea la fila de input del monto y el botón priorizar
  Widget _crearFilaInputBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child: _crearInput('monto'),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: RaisedButton(
            child: Text('Priorizar'),
            color: getColor('principal'),
            textColor: Colors.white,
            elevation: 0,
            shape: StadiumBorder(),
            padding: EdgeInsets.symmetric(vertical: 11),
            onPressed: () {}, // Acción del botón
          ),
        )
      ],
    );
  }

  // Crea el contenido del scaffold
  List<Widget> _crearContenido() {
    // Input del monto y la barra de búsqueda
    List<Widget> contenido = <Widget>[
      _crearFilaInputBtn(),
      SizedBox(height: 20.0),
      _crearInput('busqueda'),
      SizedBox(height: 20.0),
    ];
    //Recorre los elementos en _compras
    _compras.forEach((key, articulo) {
      contenido
        ..add(
          SizedBox(height: 10.0),
        )
        ..add(
          Dismissible(
            // Widget que permite eliminar los elementos cuando los pasas de lado
            key: Key(articulo['id'].toString()), // Identificador
            child: _crearArticulo(key, articulo), // Lo que se deslizará
            // Una confirmación para la eliminación como alerta
            confirmDismiss: (DismissDirection direction) async {
              return await _mostrarAlert(context, key);
            },
            // Acción que procede al ser deslizado.
            onDismissed: (direction) {
              setState(() {
                _compras.remove(key);
              });
            },
            // Color detrás del elemento a deslizar
            background: new Container(
              color: getColor('avatar'),
            ),
          ),
        );
    });

    return contenido;
  }

  // Alerta de confirmación para la eliminación
  Future<bool> _mostrarAlert(BuildContext context, key) {
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
                  Icons.info_outline,
                  color: getColor('texto'),
                  size: 40.0,
                ),
              ),
              Expanded(
                  child:
                      Text('¿Está seguro que desea eliminar este artículo?')),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: getColor('texto')),
              ),
            ),
            Expanded(child: SizedBox()),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Eliminar',
                style: TextStyle(color: getColor('texto')),
              ),
            ),
          ],
        );
      },
    );
  }

  // Crea el contenedor animado de un artículo
  Widget _crearArticulo(key, articulo) {
    // Almacena el valor boleano de la comparación entre el artículo activo y el artículo dibujado, es decir, si el artículo coincide con el que se haya seleccionado, activo será verdadero
    bool activo = _artActivo == articulo;
    // detector de gestos para el tap
    return GestureDetector(
      onTap: () {
        setState(() {
          if (activo) {
            activo = false;
            _artActivo = null;
          } else
            _artActivo = articulo;
        });
      },
      // Contenedor animado
      child: AnimatedContainer(
        // Propiedades de la animación
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        // Propiedades del contenedor
        height: activo ? 136.0 : 88.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.0),
          color: Colors.white,
        ),
        // List view para que no exista error respecto al overflow
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            // Nombre del artículo y checkbox
            Row(
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
                                    fontSize: 14,
                                    color: getColor('articuloDesc'))),
                            Expanded(child: SizedBox()),
                            Icon(Icons.escalator_sharp,
                                size: 14, color: getColor('articuloDesc')),
                            SizedBox(width: 5),
                            Text('${articulo['prioridad']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: getColor('articuloDesc'))),
                            Expanded(child: SizedBox()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _crearCheckbox(key, articulo),
                )
              ],
            ),
            // Precio del artículo y prioridad
            Row(
              children: <Widget>[],
            ),
            // Cuando haya sido seleccionado, dibujará los botones
            if (activo)
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: getColor('texto')),
                    ),
                    shape: StadiumBorder(),
                    onPressed: () {
                      setState(() => _artActivo = null);
                    },
                  ),
                  Expanded(child: SizedBox()),
                  RaisedButton(
                    child: Text('Editar'),
                    color: getColor('principal'),
                    textColor: Colors.white,
                    elevation: 0,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/nuevo',
                        // Actualización del elemento de la lista
                        arguments: SaveArguments(
                          compras: _compras,
                          callback: (map) {
                            map['seleccionado'] = true;
                            setState(() {
                              _compras[key] = map;
                            });
                          },
                          articulo: articulo,
                        ),
                      );
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  // Crea un checkbox personalizado
  Widget _crearCheckbox(key, articulo) {
    return InkWell(
      onTap: () {
        setState(() {
          // alterna el estado de selección del artículo
          _artSelec[key]['seleccionado'] = !_artSelec[key]['seleccionado'];
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: getColor('avatar')),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          // Cuando la propiedad sea verdadera, dibuja una palomita, sino, un recuadro
          child: _artSelec[key]['seleccionado']
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
      ),
    );
  }
}
