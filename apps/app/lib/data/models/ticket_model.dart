import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/ticket.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/ticket_status.dart';

/// Persistence representation of a ticket returned by Supabase.
final class TicketModel {
  const TicketModel({
    required this.id,
    required this.reservationId,
    required this.code,
    required this.status,
    required this.createdAt,
  });

  /// Creates a model from a Supabase row without assuming JSON types.
  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: parseStringSafe(json['id']),
    reservationId: parseStringSafe(json['reserva_id']),
    code: parseStringSafe(json['codigo']),
    status: _parseTicketStatus(json['estado']),
    createdAt: parseDateTimeSafe(json['created_at']),
  );

  final String id;
  final String reservationId;
  final String code;
  final TicketStatus status;
  final DateTime createdAt;

  /// Converts the persistence model into the domain entity used by the app.
  Ticket toEntity() => Ticket(
    id: id,
    reservationId: reservationId,
    code: code,
    status: status,
    createdAt: createdAt,
  );
}

TicketStatus _parseTicketStatus(dynamic value) =>
    switch (parseStringSafe(value)) {
      'valido' => TicketStatus.valid,
      'usado' => TicketStatus.used,
      _ => TicketStatus.valid,
    };
