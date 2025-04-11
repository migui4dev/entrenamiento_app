import '../controlador/datos.dart';

class Ejercicio {
  Ejercicio({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.contador = Datos.VALOR_POR_DEFECTO,
  });

  int id;
  String nombre;
  String tipo;
  int contador;

  factory Ejercicio.fromMap(Map<String, dynamic> mapa) => Ejercicio(
    id: int.tryParse('${mapa['id']}') ?? 0,
    nombre: '${mapa['nombre']}',
    tipo: '${mapa['tipo']}',
    contador: int.tryParse('${mapa['contador']}') ?? 0,
  );

  @override
  String toString() => '$id, $nombre, $tipo, $contador';
}
