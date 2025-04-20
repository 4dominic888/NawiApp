// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterBook {
  String get id;
  DateTime get createdAt;
  RegisterBookType get type;
  String? get notes;
  Iterable<StudentSummary> get mentions;
  String get action;

  /// Create a copy of RegisterBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterBookCopyWith<RegisterBook> get copyWith =>
      _$RegisterBookCopyWithImpl<RegisterBook>(
          this as RegisterBook, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterBook &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other.mentions, mentions) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, type, notes,
      const DeepCollectionEquality().hash(mentions), action);

  @override
  String toString() {
    return 'RegisterBook(id: $id, createdAt: $createdAt, type: $type, notes: $notes, mentions: $mentions, action: $action)';
  }
}

/// @nodoc
abstract mixin class $RegisterBookCopyWith<$Res> {
  factory $RegisterBookCopyWith(
          RegisterBook value, $Res Function(RegisterBook) _then) =
      _$RegisterBookCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String action,
      Iterable<StudentSummary> mentions,
      RegisterBookType type,
      String? notes});
}

/// @nodoc
class _$RegisterBookCopyWithImpl<$Res> implements $RegisterBookCopyWith<$Res> {
  _$RegisterBookCopyWithImpl(this._self, this._then);

  final RegisterBook _self;
  final $Res Function(RegisterBook) _then;

  /// Create a copy of RegisterBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? mentions = null,
    Object? type = null,
    Object? notes = freezed,
  }) {
    return _then(RegisterBook(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _self.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as Iterable<StudentSummary>,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RegisterBookType,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
