// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evento.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Evento {

 String get id; String get nombre; String get deporte; DateTime get fecha; String get hora; String get ciudad; String get lugar;@JsonKey(name: 'cupos_totales') int get cuposTotales;@JsonKey(name: 'cupos_disponibles') int get cuposDisponibles; String? get descripcion; EventoEstado get estado;
/// Create a copy of Evento
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventoCopyWith<Evento> get copyWith => _$EventoCopyWithImpl<Evento>(this as Evento, _$identity);

  /// Serializes this Evento to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Evento&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.deporte, deporte) || other.deporte == deporte)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.hora, hora) || other.hora == hora)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.lugar, lugar) || other.lugar == lugar)&&(identical(other.cuposTotales, cuposTotales) || other.cuposTotales == cuposTotales)&&(identical(other.cuposDisponibles, cuposDisponibles) || other.cuposDisponibles == cuposDisponibles)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,deporte,fecha,hora,ciudad,lugar,cuposTotales,cuposDisponibles,descripcion,estado);

@override
String toString() {
  return 'Evento(id: $id, nombre: $nombre, deporte: $deporte, fecha: $fecha, hora: $hora, ciudad: $ciudad, lugar: $lugar, cuposTotales: $cuposTotales, cuposDisponibles: $cuposDisponibles, descripcion: $descripcion, estado: $estado)';
}


}

/// @nodoc
abstract mixin class $EventoCopyWith<$Res>  {
  factory $EventoCopyWith(Evento value, $Res Function(Evento) _then) = _$EventoCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, String deporte, DateTime fecha, String hora, String ciudad, String lugar,@JsonKey(name: 'cupos_totales') int cuposTotales,@JsonKey(name: 'cupos_disponibles') int cuposDisponibles, String? descripcion, EventoEstado estado
});




}
/// @nodoc
class _$EventoCopyWithImpl<$Res>
    implements $EventoCopyWith<$Res> {
  _$EventoCopyWithImpl(this._self, this._then);

  final Evento _self;
  final $Res Function(Evento) _then;

/// Create a copy of Evento
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? deporte = null,Object? fecha = null,Object? hora = null,Object? ciudad = null,Object? lugar = null,Object? cuposTotales = null,Object? cuposDisponibles = null,Object? descripcion = freezed,Object? estado = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,deporte: null == deporte ? _self.deporte : deporte // ignore: cast_nullable_to_non_nullable
as String,fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as DateTime,hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as String,ciudad: null == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String,lugar: null == lugar ? _self.lugar : lugar // ignore: cast_nullable_to_non_nullable
as String,cuposTotales: null == cuposTotales ? _self.cuposTotales : cuposTotales // ignore: cast_nullable_to_non_nullable
as int,cuposDisponibles: null == cuposDisponibles ? _self.cuposDisponibles : cuposDisponibles // ignore: cast_nullable_to_non_nullable
as int,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as EventoEstado,
  ));
}

}


/// Adds pattern-matching-related methods to [Evento].
extension EventoPatterns on Evento {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Evento value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Evento() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Evento value)  $default,){
final _that = this;
switch (_that) {
case _Evento():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Evento value)?  $default,){
final _that = this;
switch (_that) {
case _Evento() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  String deporte,  DateTime fecha,  String hora,  String ciudad,  String lugar, @JsonKey(name: 'cupos_totales')  int cuposTotales, @JsonKey(name: 'cupos_disponibles')  int cuposDisponibles,  String? descripcion,  EventoEstado estado)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Evento() when $default != null:
return $default(_that.id,_that.nombre,_that.deporte,_that.fecha,_that.hora,_that.ciudad,_that.lugar,_that.cuposTotales,_that.cuposDisponibles,_that.descripcion,_that.estado);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  String deporte,  DateTime fecha,  String hora,  String ciudad,  String lugar, @JsonKey(name: 'cupos_totales')  int cuposTotales, @JsonKey(name: 'cupos_disponibles')  int cuposDisponibles,  String? descripcion,  EventoEstado estado)  $default,) {final _that = this;
switch (_that) {
case _Evento():
return $default(_that.id,_that.nombre,_that.deporte,_that.fecha,_that.hora,_that.ciudad,_that.lugar,_that.cuposTotales,_that.cuposDisponibles,_that.descripcion,_that.estado);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  String deporte,  DateTime fecha,  String hora,  String ciudad,  String lugar, @JsonKey(name: 'cupos_totales')  int cuposTotales, @JsonKey(name: 'cupos_disponibles')  int cuposDisponibles,  String? descripcion,  EventoEstado estado)?  $default,) {final _that = this;
switch (_that) {
case _Evento() when $default != null:
return $default(_that.id,_that.nombre,_that.deporte,_that.fecha,_that.hora,_that.ciudad,_that.lugar,_that.cuposTotales,_that.cuposDisponibles,_that.descripcion,_that.estado);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Evento implements Evento {
  const _Evento({required this.id, required this.nombre, required this.deporte, required this.fecha, required this.hora, required this.ciudad, required this.lugar, @JsonKey(name: 'cupos_totales') required this.cuposTotales, @JsonKey(name: 'cupos_disponibles') required this.cuposDisponibles, this.descripcion, required this.estado});
  factory _Evento.fromJson(Map<String, dynamic> json) => _$EventoFromJson(json);

@override final  String id;
@override final  String nombre;
@override final  String deporte;
@override final  DateTime fecha;
@override final  String hora;
@override final  String ciudad;
@override final  String lugar;
@override@JsonKey(name: 'cupos_totales') final  int cuposTotales;
@override@JsonKey(name: 'cupos_disponibles') final  int cuposDisponibles;
@override final  String? descripcion;
@override final  EventoEstado estado;

/// Create a copy of Evento
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventoCopyWith<_Evento> get copyWith => __$EventoCopyWithImpl<_Evento>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Evento&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.deporte, deporte) || other.deporte == deporte)&&(identical(other.fecha, fecha) || other.fecha == fecha)&&(identical(other.hora, hora) || other.hora == hora)&&(identical(other.ciudad, ciudad) || other.ciudad == ciudad)&&(identical(other.lugar, lugar) || other.lugar == lugar)&&(identical(other.cuposTotales, cuposTotales) || other.cuposTotales == cuposTotales)&&(identical(other.cuposDisponibles, cuposDisponibles) || other.cuposDisponibles == cuposDisponibles)&&(identical(other.descripcion, descripcion) || other.descripcion == descripcion)&&(identical(other.estado, estado) || other.estado == estado));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,deporte,fecha,hora,ciudad,lugar,cuposTotales,cuposDisponibles,descripcion,estado);

@override
String toString() {
  return 'Evento(id: $id, nombre: $nombre, deporte: $deporte, fecha: $fecha, hora: $hora, ciudad: $ciudad, lugar: $lugar, cuposTotales: $cuposTotales, cuposDisponibles: $cuposDisponibles, descripcion: $descripcion, estado: $estado)';
}


}

/// @nodoc
abstract mixin class _$EventoCopyWith<$Res> implements $EventoCopyWith<$Res> {
  factory _$EventoCopyWith(_Evento value, $Res Function(_Evento) _then) = __$EventoCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, String deporte, DateTime fecha, String hora, String ciudad, String lugar,@JsonKey(name: 'cupos_totales') int cuposTotales,@JsonKey(name: 'cupos_disponibles') int cuposDisponibles, String? descripcion, EventoEstado estado
});




}
/// @nodoc
class __$EventoCopyWithImpl<$Res>
    implements _$EventoCopyWith<$Res> {
  __$EventoCopyWithImpl(this._self, this._then);

  final _Evento _self;
  final $Res Function(_Evento) _then;

/// Create a copy of Evento
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? deporte = null,Object? fecha = null,Object? hora = null,Object? ciudad = null,Object? lugar = null,Object? cuposTotales = null,Object? cuposDisponibles = null,Object? descripcion = freezed,Object? estado = null,}) {
  return _then(_Evento(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,deporte: null == deporte ? _self.deporte : deporte // ignore: cast_nullable_to_non_nullable
as String,fecha: null == fecha ? _self.fecha : fecha // ignore: cast_nullable_to_non_nullable
as DateTime,hora: null == hora ? _self.hora : hora // ignore: cast_nullable_to_non_nullable
as String,ciudad: null == ciudad ? _self.ciudad : ciudad // ignore: cast_nullable_to_non_nullable
as String,lugar: null == lugar ? _self.lugar : lugar // ignore: cast_nullable_to_non_nullable
as String,cuposTotales: null == cuposTotales ? _self.cuposTotales : cuposTotales // ignore: cast_nullable_to_non_nullable
as int,cuposDisponibles: null == cuposDisponibles ? _self.cuposDisponibles : cuposDisponibles // ignore: cast_nullable_to_non_nullable
as int,descripcion: freezed == descripcion ? _self.descripcion : descripcion // ignore: cast_nullable_to_non_nullable
as String?,estado: null == estado ? _self.estado : estado // ignore: cast_nullable_to_non_nullable
as EventoEstado,
  ));
}


}

// dart format on
