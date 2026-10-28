// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmailEntity {

 String? get value;
/// Create a copy of EmailEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailEntityCopyWith<EmailEntity> get copyWith => _$EmailEntityCopyWithImpl<EmailEntity>(this as EmailEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EmailEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailEntity&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as EmailEntity;
  return Object.hash(runtimeType,_this.value);
}

@override
String toString() {
  final _this = this as EmailEntity;
  return 'EmailEntity(value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $EmailEntityCopyWith<$Res>  {
  factory $EmailEntityCopyWith(EmailEntity value, $Res Function(EmailEntity) _then) = _$EmailEntityCopyWithImpl;
@useResult
$Res call({
 String? value
});




}
/// @nodoc
class _$EmailEntityCopyWithImpl<$Res>
    implements $EmailEntityCopyWith<$Res> {
  _$EmailEntityCopyWithImpl(this._self, this._then);

  final EmailEntity _self;
  final $Res Function(EmailEntity) _then;

/// Create a copy of EmailEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,}) {
  return _then(EmailEntity(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailEntity].
extension EmailEntityPatterns on EmailEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailEntity value)  $default,){
final _that = this;
switch (_that) {
case _EmailEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailEntity value)?  $default,){
final _that = this;
switch (_that) {
case _EmailEntity() when $default != null:
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
case _EmailEntity() when $default != null:
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
case _EmailEntity():
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
case _EmailEntity() when $default != null:
return $default(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _EmailEntity extends EmailEntity {
  const _EmailEntity(this.value): super._();
  

@override final  String? value;

/// Create a copy of EmailEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailEntityCopyWith<_EmailEntity> get copyWith => __$EmailEntityCopyWithImpl<_EmailEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailEntity&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,value);
}

@override
String toString() {
    return 'EmailEntity(value: $value)';
}


}

/// @nodoc
abstract mixin class _$EmailEntityCopyWith<$Res> implements $EmailEntityCopyWith<$Res> {
  factory _$EmailEntityCopyWith(_EmailEntity value, $Res Function(_EmailEntity) _then) = __$EmailEntityCopyWithImpl;
@override @useResult
$Res call({
 String? value
});




}
/// @nodoc
class __$EmailEntityCopyWithImpl<$Res>
    implements _$EmailEntityCopyWith<$Res> {
  __$EmailEntityCopyWithImpl(this._self, this._then);

  final _EmailEntity _self;
  final $Res Function(_EmailEntity) _then;

/// Create a copy of EmailEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(_EmailEntity(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
