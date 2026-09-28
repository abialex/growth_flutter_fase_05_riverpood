import 'package:growth_flutter_fase_05_riverpood/core/parsing/json_parsing.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/entities/event.dart';
import 'package:growth_flutter_fase_05_riverpood/domain/enums/event_status.dart';

/// Persistence representation of an event returned by Supabase.
final class EventModel {
  const EventModel({
    required this.id,
    required this.name,
    required this.sport,
    required this.date,
    required this.time,
    required this.city,
    required this.venue,
    required this.totalSlots,
    required this.availableSlots,
    required this.status,
    this.description,
  });

  /// Creates a model from a Supabase row without assuming JSON types.
  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: parseRequiredString(json['id'], field: 'id'),
    name: parseRequiredString(json['nombre'], field: 'nombre'),
    sport: parseRequiredString(json['deporte'], field: 'deporte'),
    date: parseRequiredDateTime(json['fecha'], field: 'fecha'),
    time: parseRequiredString(json['hora'], field: 'hora'),
    city: parseRequiredString(json['ciudad'], field: 'ciudad'),
    venue: parseRequiredString(json['lugar'], field: 'lugar'),
    totalSlots: parseRequiredInt(
      json['cupos_totales'],
      field: 'cupos_totales',
      minimum: 0,
    ),
    availableSlots: parseRequiredInt(
      json['cupos_disponibles'],
      field: 'cupos_disponibles',
      minimum: 0,
    ),
    status: _parseEventStatus(
      parseRequiredString(json['estado'], field: 'estado'),
    ),
    description: parseOptionalString(json['descripcion']),
  );

  final String id;
  final String name;
  final String sport;
  final DateTime date;
  final String time;
  final String city;
  final String venue;
  final int totalSlots;
  final int availableSlots;
  final EventStatus status;
  final String? description;

  /// Converts the persistence model into the domain entity used by the app.
  Event toEntity() => Event(
    id: id,
    name: name,
    sport: sport,
    date: date,
    time: time,
    city: city,
    venue: venue,
    totalSlots: totalSlots,
    availableSlots: availableSlots,
    status: status,
    description: description,
  );
}

EventStatus _parseEventStatus(String value) => switch (value) {
  'abierto' => EventStatus.open,
  'cerrado' => EventStatus.closed,
  'finalizado' => EventStatus.finished,
  _ => EventStatus.unknown,
};
