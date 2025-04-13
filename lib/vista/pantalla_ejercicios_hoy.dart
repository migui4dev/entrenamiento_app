import 'package:carousel_slider/carousel_slider.dart';
import 'package:entrenamiento/vista/widget_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controlador/datos.dart';
import '../controlador/provider_ejercicios_ayer.dart';
import '../controlador/provider_ejercicios_hoy.dart';
import '../modelo/ejercicio.dart';

class PantallaEjerciciosHoy extends StatelessWidget {
  const PantallaEjerciciosHoy({super.key});

  @override
  Widget build(BuildContext context) {
    return _ListaEjercicios();
  }
}

class _ListaEjercicios extends StatelessWidget {
  const _ListaEjercicios();

  @override
  Widget build(BuildContext context) {
    final ProviderEjerciciosHoy providerHoy = Provider.of(
      context,
      listen: false,
    );
    final mediaQuery = MediaQuery.of(context);

    return FutureBuilder(
      future: providerHoy.getEjercicios(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WidgetError();
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final ejercicios = snapshot.data!;

        return CarouselSlider.builder(
          itemCount: ejercicios.length,
          options: CarouselOptions(height: mediaQuery.size.height),
          itemBuilder: (_, i, __) {
            return _ElementoEjercicio(ejercicio: ejercicios[i]);
          },

          carouselController: CarouselSliderController(),
        );
      },
    );
  }
}

class _ElementoEjercicio extends StatelessWidget {
  const _ElementoEjercicio({required this.ejercicio});

  final Ejercicio ejercicio;

  @override
  Widget build(BuildContext context) {
    final ProviderEjerciciosHoy providerHoy = Provider.of(
      context,
      listen: true,
    );
    final ProviderEjerciciosAyer providerAyer = Provider.of(context);
    final mediaQuery = MediaQuery.of(context);
    final modoOscuro = mediaQuery.platformBrightness == Brightness.dark;

    return FutureBuilder(
      future: providerAyer.getContadorPorId(ejercicio.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WidgetError();
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final contadorAyer = snapshot.data ?? 0;

        return Container(
          width: mediaQuery.size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: modoOscuro ? Colors.white12 : Colors.black12,
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 25,
                child: _crearInfoEjercicio(
                  modoOscuro,
                  contadorAyer,
                  providerHoy,
                ),
              ),

              Expanded(
                flex: 55,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: _gifEjercicio(),
                ),
              ),

              Expanded(
                flex: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _crearBotones(providerHoy, false, modoOscuro),
                    ),
                    Expanded(
                      flex: 5,
                      child: _crearBotones(providerHoy, true, modoOscuro),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _crearInfoEjercicio(
    bool modoOscuro,
    int contadorAyer,
    ProviderEjerciciosHoy providerHoy,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            ejercicio.nombre.toUpperCase(),
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: Datos.FUENTE_MEDIANA,
              color: modoOscuro ? Colors.white : Colors.black,
            ),
          ),
          Text(
            'Tren ${ejercicio.tipo}',
            style: const TextStyle(fontSize: Datos.FUENTE_PEQUE),
          ),
          Text(
            '${ejercicio.contador}',
            style: TextStyle(
              fontSize: Datos.FUENTE_GRANDE,
              color:
                  contadorAyer > ejercicio.contador
                      ? Datos.COLOR_NEGATIVO
                      : Datos.COLOR_POSITIVO,
            ),
          ),

          Text(
            _getTextConRespectoAAyer(contadorAyer - ejercicio.contador),
            style: TextStyle(
              fontSize: Datos.FUENTE_PEQUE,
              color:
                  contadorAyer > ejercicio.contador
                      ? Datos.COLOR_NEGATIVO
                      : Datos.COLOR_POSITIVO,
            ),
          ),
        ],
      ),
    );
  }

  Widget _gifEjercicio() {
    final String ruta =
        'assets/${ejercicio.nombre.toLowerCase().replaceAll(' ', '_')}.gif';

    return FutureBuilder(
      future: _existeArchivo(ruta),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const WidgetError();
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final existe = snapshot.data!;

        if (existe) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(ruta, fit: BoxFit.fill),
          );
        } else {
          return Placeholder();
        }
      },
    );
  }

  Future<bool> _existeArchivo(String ruta) async {
    try {
      await rootBundle.load(ruta);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _getTextConRespectoAAyer(int diff) {
    return diff > 0 ? '$diff menos que ayer' : '${diff * -1} más que ayer';
  }

  Widget _crearBotones(
    ProviderEjerciciosHoy providerHoy,
    bool sumar,
    bool modoOscuro,
  ) {
    final Icon icon = sumar ? Icon(Icons.add) : Icon(Icons.remove);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: IconButton(
        iconSize: Datos.FUENTE_GRANDE,
        onPressed: () async {
          if (sumar) {
            await providerHoy.addContador(ejercicio);
          } else {
            await providerHoy.removeContador(ejercicio);
          }
        },
        icon: icon,
        color: modoOscuro ? Colors.white : Colors.black,
      ),
    );
  }
}
