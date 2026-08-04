// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ticket _$TicketFromJson(Map<String, dynamic> json) => _Ticket(
  id: json['id'] as String,
  reservaId: json['reserva_id'] as String,
  codigo: json['codigo'] as String,
  estado: $enumDecode(_$TicketEstadoEnumMap, json['estado']),
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$TicketToJson(_Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'reserva_id': instance.reservaId,
  'codigo': instance.codigo,
  'estado': _$TicketEstadoEnumMap[instance.estado]!,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$TicketEstadoEnumMap = {
  TicketEstado.valido: 'valido',
  TicketEstado.usado: 'usado',
};
