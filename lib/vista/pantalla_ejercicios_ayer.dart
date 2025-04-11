import 'package:entrenamiento/vista/lista_contador_ejercicios.dart';
import 'package:entrenamiento/vista/widget_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controlador/provider_ejercicios_ayer.dart';

class PantallaEjerciciosAyer extends StatelessWidget {
  const PantallaEjerciciosAyer({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderEjerciciosAyer providerAyer = Provider.of(
      context,
      listen: false,
    );

    return FutureBuilder(
      future: providerAyer.getEjercicios(),
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
