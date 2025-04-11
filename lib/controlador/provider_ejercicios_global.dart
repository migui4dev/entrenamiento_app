import 'dart:math';

import 'package:flutter/material.dart';

import '../modelo/ejercicio.dart';
import 'datos.dart';
import 'db_provider.dart';

class ProviderEjerciciosGlobal with ChangeNotifier {
  Future<List<Ejercicio>> getEjercicios() async {
    return await DBProvider.db.getEjercicios(Datos.GLOBAL);
  }
}
