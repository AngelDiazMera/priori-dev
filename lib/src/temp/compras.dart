import 'dart:math';

Random _rnd = new Random();

final _compras = <int, Map<String, dynamic>>{
  1: {
    'id': 1,
    'nombre': 'Articulo 1',
    'prioridad': _rnd.nextInt(9) + 1,
    'precio': _rnd.nextInt(300).toDouble(),
    'descripcion':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'seleccionado': true // propiedad interna para uso
  },
  2: {
    'id': 2,
    'nombre': 'Articulo 2',
    'prioridad': _rnd.nextInt(9) + 1,
    'precio': _rnd.nextInt(300).toDouble(),
    'descripcion':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'seleccionado': true
  },
  3: {
    'id': 3,
    'nombre': 'Articulo 3',
    'prioridad': _rnd.nextInt(9) + 1,
    'precio': _rnd.nextInt(300).toDouble(),
    'descripcion':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    'seleccionado': true
  },
};

Map getArticulo(String nombreArticulo) {
  return _compras[nombreArticulo];
}

Map getCompras() {
  return _compras;
}
