// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Evento _$EventoFromJson(Map<String, dynamic> json) => _Evento(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  deporte: json['deporte'] as String,
  fecha: DateTime.parse(json['fecha'] as String),
  hora: json['hora'] as String,
  ciudad: json['ciudad'] as String,
  lugar: json['lugar'] as String,
  cuposTotales: (json['cupos_totales'] as num).toInt(),
  cuposDisponibles: (json['cupos_disponibles'] as num).toInt(),
  descripcion: json['descripcion'] as String?,
  estado: $enumDecode(_$EventoEstadoEnumMap, json['estado']),
);

Map<String, dynamic> _$EventoToJson(_Evento instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'deporte': instance.deporte,
  'fecha': instance.fecha.toIso8601String(),
  'hora': instance.hora,
  'ciudad': instance.ciudad,
  'lugar': instance.lugar,
  'cupos_totales': instance.cuposTotales,
  'cupos_disponibles': instance.cuposDisponibles,
  'descripcion': instance.descripcion,
  'estado': _$EventoEstadoEnumMap[instance.estado]!,
};

const _$EventoEstadoEnumMap = {
  EventoEstado.abierto: 'abierto',
  EventoEstado.cerrado: 'cerrado',
  EventoEstado.finalizado: 'finalizado',
};
