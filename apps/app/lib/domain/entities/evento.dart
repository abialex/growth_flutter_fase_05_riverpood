import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/evento_estado.dart';

part 'evento.freezed.dart';
part 'evento.g.dart';

@freezed
abstract class Evento with _$Evento {
  const factory Evento({
    required String id,
    required String nombre,
    required String deporte,
    required DateTime fecha,
    required String hora,
    required String ciudad,
    required String lugar,
    @JsonKey(name: 'cupos_totales') required int cuposTotales,
    @JsonKey(name: 'cupos_disponibles') required int cuposDisponibles,
    String? descripcion,
    required EventoEstado estado,
  }) = _Evento;

  factory Evento.fromJson(Map<String, dynamic> json) => _$EventoFromJson(json);
}
