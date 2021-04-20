import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:priori_dev/src/models/articulo_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:priori_dev/src/models/lista_model.dart';
export 'package:priori_dev/src/models/lista_model.dart';

// USO DE SINGLETON PARA QUE LA INSTANCIA SIEMPRE SEA LA MISMA
class DBProvider {
  static Database _database;
  //Mire la sentencia DBProvider._Private() <- constructor privado(en singleton)
  static final DBProvider db =
      DBProvider._(); //Instancia de la clase personalizada
  // Constructor privado para que siempre sea el mismo
  DBProvider._();

  Future<Database> get database async {
    // Por si no lo ha instanciado
    print('verificando existencia de bd');
    if (_database != null) return _database;

    print('Creando nueva base de datos');
    // Accede a la base de datos ya creada
    _database = await initDb();

    return _database;
  }

  // HASTA AQUÍ TERMINA LA ESTRUCTURA DE UN SINGLETON

  Future<Database> initDb() async {
    // Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path,
        'PrioriDevDB.db'); // Para unir pedazos del path
    print(path);
    // Crear nase de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Articulo(
            idArticulo  INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre      TEXT,
            precio      DECIMAL(8,2),
            prioridad   INTEGER,
            descripcion TEXT
          );
      ''');
        print('base de datos creada');
      },
    );
  }

  // INSERT  nuevo artículo
  Future<int> nuevoArticulo(ArticuloModel articuloModel) async {
    final db = await database;
    final res = await db.insert('Articulo', articuloModel.toJson());
    // print(res);
    return res;
  }

  // SELECT
  Future<ArticuloModel> getArticuloById(int id) async {
    final db = await database;
    // El símbolo '?' es para determinar los argumentos posicionales de la búsqueda
    final res =
        await db.query('Articulo', where: 'idArticulo = ?', whereArgs: [id]);
    return res.isNotEmpty
        ? ArticuloModel.fromJson(res.first) // Obtiene el primer elemento
        : null;
  }

  Future<List<ArticuloModel>> getAllArticulos() async {
    final db = await database;
    // El símbolo '?' es para determinar los argumentos posicionales de la búsqueda
    final res = await db.query('Articulo');
    // print(res);
    return res.isNotEmpty
        ? res.map((articulo) => ArticuloModel.fromJson(articulo)).toList()
        : null;
  }

  // UPDATE
  Future<int> updateArticulo(ArticuloModel nuevoArticulo) async {
    final db = await database;
    final res = await db.update('Articulo', nuevoArticulo.toJson(),
        where: 'idArticulo = ?', whereArgs: [nuevoArticulo.id]);
    return res;
  }

  //DELETE
  Future<int> deleteArticulo(int id) async {
    final db = await database;
    final res =
        await db.delete('Articulo', where: 'idArticulo = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllArticulos() async {
    final db = await database;
    final res = await db.delete('Articulo');
    return res;
  }
}
