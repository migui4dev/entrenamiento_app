import 'package:entrenamiento/controlador/db_provider.dart';
import 'package:entrenamiento/modelo/rutas.dart';
import 'package:entrenamiento/vista/pantalla_ejercicios_ayer.dart';
import 'package:entrenamiento/vista/pantalla_ejercicios_global.dart';
import 'package:entrenamiento/vista/pantalla_ejercicios_hoy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controlador/datos.dart';
import 'controlador/provider_ejercicios_ayer.dart';
import 'controlador/provider_ejercicios_global.dart';
import 'controlador/provider_ejercicios_hoy.dart';

void main() {
  runApp(_MiApp());
}

class _MiApp extends StatefulWidget {
  @override
  State<_MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<_MiApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderEjerciciosHoy()),
        ChangeNotifierProvider(create: (_) => ProviderEjerciciosAyer()),
        ChangeNotifierProvider(create: (_) => ProviderEjerciciosGlobal()),
      ],
      child: _MiMaterial(),
    );
  }

  @override
  void dispose() async {
    await DBProvider.db.cerrarDB();
    super.dispose();
  }
}

class _MiMaterial extends StatefulWidget {
  _MiMaterial();

  final List<Map<String, dynamic>> widgets = [
    {
      'nombre': 'Ayer',
      'icono': Icons.history,
      'widget': PantallaEjerciciosAyer(),
    },
    {
      'nombre': 'Hoy',
      'icono': Icons.access_time,
      'widget': PantallaEjerciciosHoy(),
    },
    {
      'nombre': 'Global',
      'icono': Icons.public,
      'widget': PantallaEjerciciosGlobal(),
    },
  ];

  @override
  State<_MiMaterial> createState() => _MiMaterialState();
}

class _MiMaterialState extends State<_MiMaterial> {
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final seleccionado = widget.widgets[index];
    final String nombre = widget.widgets[index]['nombre'];

    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData.light(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      routes: getRutas(),
      home: Scaffold(
        appBar: AppBar(title: Text('Entrenamiento ${nombre.toLowerCase()}')),
        body: seleccionado['widget'],
        bottomNavigationBar: BottomNavigationBar(
          items: _crearItems(),
          selectedItemColor: Datos.COLOR_POR_DEFECTO,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _crearItems() {
    return widget.widgets
        .map(
          (e) => BottomNavigationBarItem(
            icon: Icon(e['icono']),
            label: '${e['nombre']}',
          ),
        )
        .toList();
  }
}
