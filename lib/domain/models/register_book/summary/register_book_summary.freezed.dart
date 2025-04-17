// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_book_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterBookSummary {
  String get id;
  String get hourCreatedAt;
  DateTime get createdAt;
  RegisterBookType get type;
  Iterable<StudentSummary> get mentions;
  String get action;

  /// Create a copy of RegisterBookSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RegisterBookSummaryCopyWith<RegisterBookSummary> get copyWith =>
      _$RegisterBookSummaryCopyWithImpl<RegisterBookSummary>(
          this as RegisterBookSummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RegisterBookSummary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hourCreatedAt, hourCreatedAt) ||
                other.hourCreatedAt == hourCreatedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.mentions, mentions) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, hourCreatedAt, createdAt,
      type, const DeepCollectionEquality().hash(mentions), action);

  @override
  String toString() {
    return 'RegisterBookSummary(id: $id, hourCreatedAt: $hourCreatedAt, createdAt: $createdAt, type: $type, mentions: $mentions, action: $action)';
  }
}

/// @nodoc
abstract mixin class $RegisterBookSummaryCopyWith<$Res> {
  factory $RegisterBookSummaryCopyWith(
          RegisterBookSummary value, $Res Function(RegisterBookSummary) _then) =
      _$RegisterBookSummaryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String action,
      String hourCreatedAt,
      DateTime createdAt,
      RegisterBookType type,
      Iterable<StudentSummary> mentions});
}

/// @nodoc
class _$RegisterBookSummaryCopyWithImpl<$Res>
    implements $RegisterBookSummaryCopyWith<$Res> {
  _$RegisterBookSummaryCopyWithImpl(this._self, this._then);

  final RegisterBookSummary _self;
  final $Res Function(RegisterBookSummary) _then;

  /// Create a copy of RegisterBookSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? hourCreatedAt = null,
    Object? createdAt = null,
    Object? type = null,
    Object? mentions = null,
  }) {
    return _then(RegisterBookSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      hourCreatedAt: null == hourCreatedAt
          ? _self.hourCreatedAt
          : hourCreatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RegisterBookType,
      mentions: null == mentions
          ? _self.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as Iterable<StudentSummary>,
    ));
  }
}

// dart format on
