import 'package:entrenamiento/controlador/db_provider.dart';
import 'package:flutter/material.dart';

import '../modelo/ejercicio.dart';
import 'datos.dart';

class ProviderEjerciciosAyer with ChangeNotifier {
  Future<List<Ejercicio>> getEjercicios() async {
    return await DBProvider.db.getEjercicios(Datos.AYER);
  }

  Future<int> getContadorPorId(int id) async {
    return await DBProvider.db.getContadorAyerPorId(id);
  }
}
