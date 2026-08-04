// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reserva.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reserva {

 String get id;@JsonKey(name: 'usuario_id') String get usuarioId;@JsonKey(name: 'evento_id') String get eventoId;@JsonKey(name: 'cantidad_cupos') int get cantidadCupos; ReservaEstado get estado;@JsonKey(name: 'fecha_reserva') DateTime get fechaReserva;
/// Create a copy of Reserva
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservaCopyWith<Reserva> get copyWith => _$ReservaCopyWithImpl<Reserva>(this as Reserva, _$identity);

  /// Serializes this Reserva to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reserva&&(identical(other.id, id) || other.id == id)&&(identical(other.usuarioId, usuarioId) || other.usuarioId == usuarioId)&&(identical(other.eventoId, eventoId) || other.eventoId == eventoId)&&(identical(other.cantidadCupos, cantidadCupos) || other.cantidadCupos == cantidadCupos)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.fechaReserva, fechaReserva) || other.fechaReserva == fechaReserva));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,usuarioId,eventoId,cantidadCupos,estado,fechaReserva);

@override
String toString() {
  return 'Reserva(id: $id, usuarioId: $usuarioId, eventoId: $eventoId, cantidadCupos: $cantidadCupos, estado: $estado, fechaReserva: $fechaReserva)';
}


}

/// @nodoc
abstract mixin class $ReservaCopyWith<$Res>  {
  factory $ReservaCopyWith(Reserva value, $Res Function(Reserva) _then) = _$ReservaCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'usuario_id') String usuarioId,@JsonKey(name: 'evento_id') String eventoId,@JsonKey(name: 'cantidad_cupos') int cantidadCupos, ReservaEstado estado,@JsonKey(name: 'fecha_reserva') DateTime fechaReserva
});




}
/// @nodoc
class _$ReservaCopyWithImpl<$Res>
    implements $ReservaCopyWith<$Res> {
  _$ReservaCopyWithImpl(this._self, this._then);

  final Reserva _self;
  final $Res Function(Reserva) _then;

/// Create a copy of Reserva
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? usuarioId = null,Object? eventoId = null,Object? cantidadCupos = null,Object? estado = null,Object? fechaReserva = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,usuarioId: null == usuarioId ? _self.usuarioId : usuarioId // ignore: cast_nullable_to_non_nullable
as String,eventoId: null == eventoId ? _self.eventoId : eventoId // ignore: cast_nullable_to_non_nullable
as String,cantidadCupos: null == cantidadCupos ? _self.cantidadCupos : cantidadCupos // ignore: cast_nullable_to_non_nullable
as int,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as ReservaEstado,fechaReserva: null == fechaReserva ? _self.fechaReserva : fechaReserva // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Reserva].
extension ReservaPatterns on Reserva {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reserva value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reserva() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reserva value)  $default,){
final _that = this;
switch (_that) {
case _Reserva():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reserva value)?  $default,){
final _that = this;
switch (_that) {
case _Reserva() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'usuario_id')  String usuarioId, @JsonKey(name: 'evento_id')  String eventoId, @JsonKey(name: 'cantidad_cupos')  int cantidadCupos,  ReservaEstado estado, @JsonKey(name: 'fecha_reserva')  DateTime fechaReserva)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reserva() when $default != null:
return $default(_that.id,_that.usuarioId,_that.eventoId,_that.cantidadCupos,_that.estado,_that.fechaReserva);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'usuario_id')  String usuarioId, @JsonKey(name: 'evento_id')  String eventoId, @JsonKey(name: 'cantidad_cupos')  int cantidadCupos,  ReservaEstado estado, @JsonKey(name: 'fecha_reserva')  DateTime fechaReserva)  $default,) {final _that = this;
switch (_that) {
case _Reserva():
return $default(_that.id,_that.usuarioId,_that.eventoId,_that.cantidadCupos,_that.estado,_that.fechaReserva);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'usuario_id')  String usuarioId, @JsonKey(name: 'evento_id')  String eventoId, @JsonKey(name: 'cantidad_cupos')  int cantidadCupos,  ReservaEstado estado, @JsonKey(name: 'fecha_reserva')  DateTime fechaReserva)?  $default,) {final _that = this;
switch (_that) {
case _Reserva() when $default != null:
return $default(_that.id,_that.usuarioId,_that.eventoId,_that.cantidadCupos,_that.estado,_that.fechaReserva);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reserva implements Reserva {
  const _Reserva({required this.id, @JsonKey(name: 'usuario_id') required this.usuarioId, @JsonKey(name: 'evento_id') required this.eventoId, @JsonKey(name: 'cantidad_cupos') required this.cantidadCupos, required this.estado, @JsonKey(name: 'fecha_reserva') required this.fechaReserva});
  factory _Reserva.fromJson(Map<String, dynamic> json) => _$ReservaFromJson(json);

@override final  String id;
@override@JsonKey(name: 'usuario_id') final  String usuarioId;
@override@JsonKey(name: 'evento_id') final  String eventoId;
@override@JsonKey(name: 'cantidad_cupos') final  int cantidadCupos;
@override final  ReservaEstado estado;
@override@JsonKey(name: 'fecha_reserva') final  DateTime fechaReserva;

/// Create a copy of Reserva
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservaCopyWith<_Reserva> get copyWith => __$ReservaCopyWithImpl<_Reserva>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reserva&&(identical(other.id, id) || other.id == id)&&(identical(other.usuarioId, usuarioId) || other.usuarioId == usuarioId)&&(identical(other.eventoId, eventoId) || other.eventoId == eventoId)&&(identical(other.cantidadCupos, cantidadCupos) || other.cantidadCupos == cantidadCupos)&&(identical(other.estado, estado) || other.estado == estado)&&(identical(other.fechaReserva, fechaReserva) || other.fechaReserva == fechaReserva));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,usuarioId,eventoId,cantidadCupos,estado,fechaReserva);

@override
String toString() {
  return 'Reserva(id: $id, usuarioId: $usuarioId, eventoId: $eventoId, cantidadCupos: $cantidadCupos, estado: $estado, fechaReserva: $fechaReserva)';
}


}

/// @nodoc
abstract mixin class _$ReservaCopyWith<$Res> implements $ReservaCopyWith<$Res> {
  factory _$ReservaCopyWith(_Reserva value, $Res Function(_Reserva) _then) = __$ReservaCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'usuario_id') String usuarioId,@JsonKey(name: 'evento_id') String eventoId,@JsonKey(name: 'cantidad_cupos') int cantidadCupos, ReservaEstado estado,@JsonKey(name: 'fecha_reserva') DateTime fechaReserva
});




}
/// @nodoc
class __$ReservaCopyWithImpl<$Res>
    implements _$ReservaCopyWith<$Res> {
  __$ReservaCopyWithImpl(this._self, this._then);

  final _Reserva _self;
  final $Res Function(_Reserva) _then;

/// Create a copy of Reserva
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? usuarioId = null,Object? eventoId = null,Object? cantidadCupos = null,Object? estado = null,Object? fechaReserva = null,}) {
  return _then(_Reserva(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,usuarioId: null == usuarioId ? _self.usuarioId : usuarioId // ignore: cast_nullable_to_non_nullable
as String,eventoId: null == eventoId ? _self.eventoId : eventoId // ignore: cast_nullable_to_non_nullable
as String,cantidadCupos: null == cantidadCupos ? _self.cantidadCupos : cantidadCupos // ignore: cast_nullable_to_non_nullable
as int,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as ReservaEstado,fechaReserva: null == fechaReserva ? _self.fechaReserva : fechaReserva // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
