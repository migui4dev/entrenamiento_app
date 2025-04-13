import 'package:entrenamiento/controlador/db_provider.dart';
import 'package:flutter/cupertino.dart';
import '../modelo/ejercicio.dart';
import 'datos.dart';

class ProviderEjerciciosHoy with ChangeNotifier {
  final List<Ejercicio> _ejercicios = [];

  Future<List<Ejercicio>> getEjercicios() async {
    final resultado = await DBProvider.db.getEjercicios(Datos.HOY);
    _ejercicios.clear();
    _ejercicios.addAll(resultado);
    return _ejercicios;
  }

  Future<int> addContador(Ejercicio ejercicio) async {
    final num = await DBProvider.db.addContador(ejercicio);

    notifyListeners();
    return num;
  }

  Future<int> removeContador(Ejercicio ejercicio) async {
    if (ejercicio.contador == 0) {
      return 0;
    }

    final num = await DBProvider.db.removeContador(ejercicio);

    notifyListeners();
    return num;
  }
}
