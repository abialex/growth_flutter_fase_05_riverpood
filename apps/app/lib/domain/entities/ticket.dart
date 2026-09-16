import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_estado.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

@freezed
abstract class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    @JsonKey(name: 'reserva_id') required String reservaId,
    required String codigo,
    required TicketEstado estado,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}
