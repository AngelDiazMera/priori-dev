import 'package:flutter/material.dart';

import 'package:priori_dev/src/colors/Colores.dart';
import 'package:priori_dev/src/widgets/articulo_animado.dart';
import 'package:priori_dev/src/widgets/input_field.dart';
import 'package:priori_dev/src/logic/optimizador_main.dart';
import 'package:priori_dev/src/models/articulo_model.dart';
import 'package:priori_dev/src/providers/arguments.dart';
// import 'package:priori_dev/src/providers/arguments.dart';
import 'package:priori_dev/src/providers/db_providers.dart';
import 'package:regexed_validator/regexed_validator.dart';
// import 'package:priori_dev/src/temp/compras.dart';

class ComprasPage extends StatefulWidget {
  // Constructor
  ComprasPage({Key key}) : super(key: key);

  // Creación de estado
  @override
  _ComprasPageState createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  // Controladores para la carga automática de valores en caso que
  // se deseé editar un artículo
  final TextEditingController _montoCtrl = TextEditingController();
  // String _busqueda = '';
  // Lista de compras
  List<ArticuloModel> _compras;
  // Datos del artículo seleccionado por el usuario
  ArticuloModel _artActivo;

  void initState() {
    //Esta funcioon es para ahorrar memoria, solo lanza este elemento cuando la aplicacion se abre y no la mantiene en uso en tiempo de inactividad
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DBProvider.db.getAllArticulos().then((arts) {
      if (_compras == null) {
        _actualizaCompras(arts);
      }
    });
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
              callback: (ArticuloModel articulo) {
                DBProvider.db.nuevoArticulo(articulo);
                DBProvider.db
                    .getAllArticulos()
                    .then((arts) => _actualizaCompras(arts));
              },
              articulo: null,
            ),
          );
        },
      ),
    );
  }

  // void _actualizarBusqueda(valor) {
  //   setState(() => _busqueda = valor);
  // }

  void _actualizaCompras(articulos) {
    setState(() {
      _compras = articulos;
    });
  }

  // Crea la fila de input del monto y el botón priorizar
  Widget _crearFilaInputBtn() {
    return Row(
      children: <Widget>[
        Expanded(
          child:
              crearInput(tipo: 'numero', nombre: 'Monto', control: _montoCtrl),
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
              onPressed: _redirigirPriorizado // Acción del botón
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
      // TODO: Descomentar para agregar barra de búsqueda
      // crearInput(
      //     tipo: 'text', nombre: 'Busqueda', callback: _actualizarBusqueda),
      // SizedBox(height: 20.0),
    ];
    //Recorre los elementos en _compras
    if (_compras != null)
      _compras.forEach((ArticuloModel articulo) {
        contenido
          ..add(
            SizedBox(height: 10.0),
          )
          ..add(
            Dismissible(
              // Widget que permite eliminar los elementos cuando los pasas de lado
              key: ValueKey(articulo.id.toString()), // Identificador
              child:
                  _crearArticulo(articulo.id, articulo), // Lo que se deslizará
              // Una confirmación para la eliminación como alerta
              confirmDismiss: (DismissDirection direction) async {
                return await mostrarAlert(
                    context,
                    articulo.id,
                    '¿Está seguro que desea eliminar este artículo?',
                    Icons.info_outline,
                    ['Cancelar', 'Eliminar']);
              },
              // Acción que procede al ser deslizado.
              onDismissed: (direction) {
                setState(() {
                  _compras.removeWhere((element) => element.id == articulo.id);
                  DBProvider.db.deleteArticulo(articulo.id);
                  // DBProvider.db
                  //     .getAllArticulos()
                  //     .then((arts) => _actualizaCompras(arts));
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

  // Crea el contenedor animado de un artículo
  Widget _crearArticulo(int key, ArticuloModel articulo) {
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
        height: activo ? 136.0 : 92.0,
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
                            articulo.nombre,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${articulo.descripcion}',
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
                            Text('${articulo.precio}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: getColor('articuloDesc'))),
                            Expanded(child: SizedBox()),
                            Icon(Icons.escalator_sharp,
                                size: 14, color: getColor('articuloDesc')),
                            SizedBox(width: 5),
                            Text('${articulo.prioridad}',
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
            if (activo) _dibujaBotonesArticulo(key, articulo)
          ],
        ),
      ),
    );
  }

  Widget _dibujaBotonesArticulo(int key, ArticuloModel articulo) {
    return Row(
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
                callback: (ArticuloModel articulo) {
                  DBProvider.db.updateArticulo(articulo);
                  DBProvider.db
                      .getAllArticulos()
                      .then((arts) => _actualizaCompras(arts));
                },
                articulo: articulo,
              ),
            );
          },
        ),
      ],
    );
  }

  // Crea un checkbox personalizado
  Widget _crearCheckbox(int key, ArticuloModel articulo) {
    // bool esSeleccionado = _artSelec.contains(articulo);
    return InkWell(
      onTap: () {
        setState(() {
          articulo.seleccionado = !articulo.seleccionado;
        });
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: getColor('avatar')),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            // Cuando la propiedad sea verdadera, dibuja una palomita, sino, un recuadro
            child: articulo.seleccionado
                ? Icon(
                    Icons.check,
                    size: 20.0,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.circle,
                    size: 20.0,
                    color: Color.fromRGBO(255, 255, 255, 0),
                  ),
          )),
    );
  }

  void _redirigirPriorizado() {
    RegExp _dineroRegEx =
        RegExp("^\$|^(0|([1-9][0-9]{0,3}))(\\.[0-9]{0,2})?\$");
    double _monto;

    if (_montoCtrl.text.isEmpty) {
      mostrarAlert(context, UniqueKey(), 'Debe ingresar un monto',
          Icons.warning_amber_rounded, ['Ok!']);
      return;
    }

    if (_montoCtrl.text.startsWith('.')) {
      _montoCtrl.text = '0' + _montoCtrl.text;
    }

    if (!_dineroRegEx.hasMatch('${_montoCtrl.text}')) {
      mostrarAlert(
          context,
          UniqueKey(),
          'La cantidad: ${_montoCtrl.text} no es válida.',
          Icons.warning_amber_rounded,
          ['Ok!']);
      return;
    }

    _monto = double.tryParse(_montoCtrl.text);

    List comprasSelec =
        _compras.where((element) => element.seleccionado == true).toList();

    comprasSelec =
        comprasSelec.where((element) => element.precio <= _monto).toList();

    comprasSelec = pruebaOptimizacion(comprasSelec, _monto);

    Navigator.pushNamed(context, '/compras_priorizada',
        arguments: PrioritizedList(compras: comprasSelec, monto: _monto));
  }
}
