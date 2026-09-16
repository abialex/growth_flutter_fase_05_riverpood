import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_estado.dart';
import 'package:meta/meta.dart';

@immutable
final class Ticket {
  const Ticket({
    required this.id,
    required this.reservaId,
    required this.codigo,
    required this.estado,
    required this.createdAt,
  });

  final String id;
  final String reservaId;
  final String codigo;
  final TicketEstado estado;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Ticket &&
            other.id == id &&
            other.reservaId == reservaId &&
            other.codigo == codigo &&
            other.estado == estado &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    reservaId,
    codigo,
    estado,
    createdAt,
  );
}
