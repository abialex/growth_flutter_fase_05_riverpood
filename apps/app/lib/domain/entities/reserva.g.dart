// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserva.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reserva _$ReservaFromJson(Map<String, dynamic> json) => _Reserva(
  id: json['id'] as String,
  usuarioId: json['usuario_id'] as String,
  eventoId: json['evento_id'] as String,
  cantidadCupos: (json['cantidad_cupos'] as num).toInt(),
  estado: $enumDecode(_$ReservaEstadoEnumMap, json['estado']),
  fechaReserva: DateTime.parse(json['fecha_reserva'] as String),
);

Map<String, dynamic> _$ReservaToJson(_Reserva instance) => <String, dynamic>{
  'id': instance.id,
  'usuario_id': instance.usuarioId,
  'evento_id': instance.eventoId,
  'cantidad_cupos': instance.cantidadCupos,
  'estado': _$ReservaEstadoEnumMap[instance.estado]!,
  'fecha_reserva': instance.fechaReserva.toIso8601String(),
};

const _$ReservaEstadoEnumMap = {
  ReservaEstado.pendiente: 'pendiente',
  ReservaEstado.confirmada: 'confirmada',
  ReservaEstado.cancelada: 'cancelada',
};
