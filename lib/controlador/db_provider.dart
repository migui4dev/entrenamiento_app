import 'package:entrenamiento/modelo/ejercicio.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'datos.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  final String nombreDB = 'entrenamientos.db';
  final int versionDB = 1;

  final List<Map<String, dynamic>> _ejercicios = [
    {'id': 1, 'nombre': 'Abdominales', 'tipo': 'superior'},
    {'id': 2, 'nombre': 'Flexiones', 'tipo': 'superior'},
    {'id': 3, 'nombre': 'Curl de Bíceps', 'tipo': 'superior'},
    {'id': 4, 'nombre': 'Press Francés', 'tipo': 'superior'},
    {'id': 5, 'nombre': 'Press Militar', 'tipo': 'superior'},
    {'id': 6, 'nombre': 'Elevaciones Laterales', 'tipo': 'superior'},
    {'id': 7, 'nombre': 'Sentadillas', 'tipo': 'inferior'},
    {'id': 8, 'nombre': 'Sentadillas Búlgaras', 'tipo': 'inferior'},
    {'id': 9, 'nombre': 'Peso Muerto Rumano', 'tipo': 'inferior'},
  ];

  DBProvider._();

  DateTime _getHoy() {
    final ahora = DateTime.now().toLocal();
    return DateTime(ahora.year, ahora.month, ahora.day);
  }

  DateTime _getAyer() => _getHoy().subtract(const Duration(days: 1));

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), nombreDB),
      version: versionDB,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ejercicios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre VARCHAR(30) NOT NULL UNIQUE,
            tipo TEXT CHECK(tipo IN ('superior', 'inferior'))
          );
        ''');

        await db.execute('''
          CREATE TABLE ejercicios_entrenamiento(
            id_ejercicio INTEGER,
            fecha DATE,
            contador INTEGER DEFAULT 0,
            
            FOREIGN KEY (id_ejercicio)
            REFERENCES ejercicios(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,
            
            PRIMARY KEY (id_ejercicio, fecha)
          );
        ''');

        for (final e in _ejercicios) {
          await db.insert('ejercicios', e);
        }
      },
      onOpen: _crearRegistrosAyerYHoy,
    );
  }

  void _crearRegistrosAyerYHoy(Database db) async {
    for (final e in _ejercicios) {
      try {
        await db.insert('ejercicios_entrenamiento', {
          'id_ejercicio': int.tryParse('${e['id']}'),
          'fecha': _getHoy().toString(),
        });
        await db.insert('ejercicios_entrenamiento', {
          'id_ejercicio': int.tryParse('${e['id']}'),
          'fecha': _getAyer().toString(),
        });
      } catch (e) {
        break;
      }
    }
  }

  Future<Database> get database async {
    _database = _database ?? await initDB();
    return _database!;
  }

  Future<List<Ejercicio>> getEjercicios(int opcion) async {
    final db = await database;
    final datos = await db.query('ejercicios');

    final ejercicios = datos.map((e) => Ejercicio.fromMap(e)).toList();

    for (int i = 0; i < ejercicios.length; i++) {
      final e = ejercicios[i];

      switch (opcion) {
        case Datos.HOY:
        case Datos.AYER:
          {
            final datos2 = await db.query(
              'ejercicios_entrenamiento',
              where: 'id_ejercicio=? and fecha=?',
              whereArgs: [
                e.id,
                (opcion == Datos.HOY ? _getHoy() : _getAyer()).toString(),
              ],
            );

            ejercicios[i].contador =
                int.tryParse('${datos2.first['contador'] ?? 0}')!;
            break;
          }
        case Datos.GLOBAL:
          {
            final datos2 = await db.query(
              'ejercicios_entrenamiento',
              where: 'id_ejercicio=?',
              whereArgs: [e.id],
            );

            int suma = 0;

            for (final e in datos2) {
              suma += int.tryParse('${e['contador'] ?? 0}')!;
            }

            ejercicios[i].contador = suma;
            break;
          }
      }
    }

    return ejercicios;
  }

  Future<int> getContadorAyerPorId(int id) async {
    final db = await database;

    final datos = await db.query(
      'ejercicios_entrenamiento',
      where: 'id_ejercicio=? and fecha=?',
      whereArgs: [id, _getAyer().toString()],
    );

    return Ejercicio.fromMap(datos.first).contador;
  }

  Future<int> addContador(Ejercicio ejercicio) async {
    final db = await database;

    return await db.update(
      'ejercicios_entrenamiento',
      {'contador': ++ejercicio.contador},
      where: 'id_ejercicio=? and fecha=?',
      whereArgs: [ejercicio.id, _getHoy().toString()],
    );
  }

  Future<int> removeContador(Ejercicio ejercicio) async {
    final db = await database;

    return await db.update(
      'ejercicios_entrenamiento',
      {'contador': --ejercicio.contador},
      where: 'id_ejercicio=? and fecha=?',
      whereArgs: [ejercicio.id, _getHoy().toString()],
    );
  }

  Future<int> resetContador(Ejercicio ejercicio) async {
    final db = await database;

    return await db.update(
      'ejercicios_entrenamiento',
      {'contador': 0},
      where: 'id_ejercicio=? and fecha=?',
      whereArgs: [ejercicio.id, _getHoy().toString()],
    );
  }

  Future<void> cerrarDB() async {
    if (_database != null && _database!.isOpen) {
      return await _database!.close();
    }
  }
}
