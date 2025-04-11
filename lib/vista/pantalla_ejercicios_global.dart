import 'package:entrenamiento/vista/lista_contador_ejercicios.dart';
import 'package:entrenamiento/vista/widget_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controlador/provider_ejercicios_global.dart';

class PantallaEjerciciosGlobal extends StatelessWidget {
  const PantallaEjerciciosGlobal({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderEjerciciosGlobal providerGlobal = Provider.of(
      context,
      listen: false,
    );

    return FutureBuilder(
      future: providerGlobal.getEjercicios(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WidgetError();
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ejercicios = snapshot.data!;

        return ListaContadorEjercicios(ejercicios: ejercicios);
      },
    );
  }
}
