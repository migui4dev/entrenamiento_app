import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelo/ejercicio.dart';

class ListaContadorEjercicios extends StatelessWidget {
  const ListaContadorEjercicios({super.key, required this.ejercicios});

  final List<Ejercicio> ejercicios;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ejercicios.length,
      itemBuilder: (_, i) => _ElementoEjercicio(ejercicio: ejercicios[i]),
    );
  }
}

class _ElementoEjercicio extends StatelessWidget {
  const _ElementoEjercicio({required this.ejercicio});

  final Ejercicio ejercicio;

  @override
  Widget build(BuildContext context) {
    final bool modoOscuro =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: modoOscuro ? Colors.white12 : Colors.black12,
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
      child: Column(
        children: [
          Text(
            ejercicio.nombre.toUpperCase(),
            style: const TextStyle(fontSize: 24),
          ),
          Text('Tren ${ejercicio.tipo}', style: const TextStyle(fontSize: 12)),
          Text(
            '${ejercicio.contador}',
            style: TextStyle(
              fontSize: 48,
              color: modoOscuro ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
