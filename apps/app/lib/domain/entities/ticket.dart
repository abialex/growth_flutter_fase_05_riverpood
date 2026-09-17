import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';
import 'package:meta/meta.dart';

@immutable
final class Ticket {
  const Ticket({
    required this.id,
    required this.reservationId,
    required this.code,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String reservationId;
  final String code;
  final TicketStatus status;
  final DateTime createdAt;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Ticket &&
            other.id == id &&
            other.reservationId == reservationId &&
            other.code == code &&
            other.status == status &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    reservationId,
    code,
    status,
    createdAt,
  );
}
