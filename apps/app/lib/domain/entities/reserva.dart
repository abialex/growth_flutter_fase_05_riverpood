import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:growth_flutter_fase_05_riverpood/domain/enums/reserva_estado.dart';

part 'reserva.freezed.dart';
part 'reserva.g.dart';

@freezed
abstract class Reserva with _$Reserva {
  const factory Reserva({
    required String id,
    @JsonKey(name: 'usuario_id') required String usuarioId,
    @JsonKey(name: 'evento_id') required String eventoId,
    @JsonKey(name: 'cantidad_cupos') required int cantidadCupos,
    required ReservaEstado estado,
    @JsonKey(name: 'fecha_reserva') required DateTime fechaReserva,
  }) = _Reserva;

  factory Reserva.fromJson(Map<String, dynamic> json) =>
      _$ReservaFromJson(json);
}
