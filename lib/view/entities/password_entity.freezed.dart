// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasswordEntity {

 String? get value;
/// Create a copy of PasswordEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordEntityCopyWith<PasswordEntity> get copyWith => _$PasswordEntityCopyWithImpl<PasswordEntity>(this as PasswordEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PasswordEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordEntity&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as PasswordEntity;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as PasswordEntity;
  return 'PasswordEntity(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $PasswordEntityCopyWith<$Res>  {
  factory $PasswordEntityCopyWith(PasswordEntity value, $Res Function(PasswordEntity) _then) = _$PasswordEntityCopyWithImpl;
@useResult
$Res call({
 String? value
});




}
/// @nodoc
class _$PasswordEntityCopyWithImpl<$Res>
    implements $PasswordEntityCopyWith<$Res> {
  _$PasswordEntityCopyWithImpl(this._self, this._then);

  final PasswordEntity _self;
  final $Res Function(PasswordEntity) _then;

/// Create a copy of PasswordEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,}) {
  return _then(PasswordEntity(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PasswordEntity].
extension PasswordEntityPatterns on PasswordEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasswordEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasswordEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasswordEntity value)  $default,){
final _that = this;
switch (_that) {
case _PasswordEntity():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasswordEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PasswordEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasswordEntity() when $default != null:
return $default(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? value)  $default,) {final _that = this;
switch (_that) {
case _PasswordEntity():
return $default(_that.value);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? value)?  $default,) {final _that = this;
switch (_that) {
case _PasswordEntity() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _PasswordEntity extends PasswordEntity {
  const _PasswordEntity(this.value): super._();
  

@override final  String? value;

/// Create a copy of PasswordEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordEntityCopyWith<_PasswordEntity> get copyWith => __$PasswordEntityCopyWithImpl<_PasswordEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordEntity&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'PasswordEntity(value: $value)';
}


}

/// @nodoc
abstract mixin class _$PasswordEntityCopyWith<$Res> implements $PasswordEntityCopyWith<$Res> {
  factory _$PasswordEntityCopyWith(_PasswordEntity value, $Res Function(_PasswordEntity) _then) = __$PasswordEntityCopyWithImpl;
@override @useResult
$Res call({
 String? value
});




}
/// @nodoc
class __$PasswordEntityCopyWithImpl<$Res>
    implements _$PasswordEntityCopyWith<$Res> {
  __$PasswordEntityCopyWithImpl(this._self, this._then);

  final _PasswordEntity _self;
  final $Res Function(_PasswordEntity) _then;

/// Create a copy of PasswordEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(_PasswordEntity(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
