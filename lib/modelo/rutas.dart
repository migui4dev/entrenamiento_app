import 'package:flutter/material.dart';
import '../vista/pantalla_ejercicios_global.dart';
import '../vista/pantalla_ejercicios_ayer.dart';
import '../vista/pantalla_ejercicios_hoy.dart';

Map<String, WidgetBuilder> getRutas() => {
  'pantalla_ejercicios_hoy': (_) => PantallaEjerciciosHoy(),
  'pantalla_ejercicios_ayer': (_) => PantallaEjerciciosAyer(),
  'pantalla_ejercicios_global': (_) => PantallaEjerciciosGlobal(),
};
