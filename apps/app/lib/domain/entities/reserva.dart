import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';
import 'package:meta/meta.dart';

@immutable
final class Reserva {
  const Reserva({
    required this.id,
    required this.usuarioId,
    required this.eventoId,
    required this.cantidadCupos,
    required this.estado,
    required this.fechaReserva,
  });

  final String id;
  final String usuarioId;
  final String eventoId;
  final int cantidadCupos;
  final ReservaEstado estado;
  final DateTime fechaReserva;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Reserva &&
            other.id == id &&
            other.usuarioId == usuarioId &&
            other.eventoId == eventoId &&
            other.cantidadCupos == cantidadCupos &&
            other.estado == estado &&
            other.fechaReserva == fechaReserva;
  }

  @override
  int get hashCode => Object.hash(
    id,
    usuarioId,
    eventoId,
    cantidadCupos,
    estado,
    fechaReserva,
  );
}
