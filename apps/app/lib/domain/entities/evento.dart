import 'package:growth_flutter_fase_05_riverpood/domain/enums/evento_estado.dart';
import 'package:meta/meta.dart';

@immutable
final class Evento {
  const Evento({
    required this.id,
    required this.nombre,
    required this.deporte,
    required this.fecha,
    required this.hora,
    required this.ciudad,
    required this.lugar,
    required this.cuposTotales,
    required this.cuposDisponibles,
    required this.estado,
    this.descripcion,
  });

  final String id;
  final String nombre;
  final String deporte;
  final DateTime fecha;
  final String hora;
  final String ciudad;
  final String lugar;
  final int cuposTotales;
  final int cuposDisponibles;
  final EventoEstado estado;
  final String? descripcion;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Evento &&
            other.id == id &&
            other.nombre == nombre &&
            other.deporte == deporte &&
            other.fecha == fecha &&
            other.hora == hora &&
            other.ciudad == ciudad &&
            other.lugar == lugar &&
            other.cuposTotales == cuposTotales &&
            other.cuposDisponibles == cuposDisponibles &&
            other.estado == estado &&
            other.descripcion == descripcion;
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    deporte,
    fecha,
    hora,
    ciudad,
    lugar,
    cuposTotales,
    cuposDisponibles,
    estado,
    descripcion,
  );
}
