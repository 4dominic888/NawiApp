// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentSummary {
  String get id;
  String get name;
  StudentAge get age;

  /// Create a copy of StudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StudentSummaryCopyWith<StudentSummary> get copyWith =>
      _$StudentSummaryCopyWithImpl<StudentSummary>(
          this as StudentSummary, _$identity);

  @override
  String toString() {
    return 'StudentSummary(id: $id, name: $name, age: $age)';
  }
}

/// @nodoc
abstract mixin class $StudentSummaryCopyWith<$Res> {
  factory $StudentSummaryCopyWith(
          StudentSummary value, $Res Function(StudentSummary) _then) =
      _$StudentSummaryCopyWithImpl;
  @useResult
  $Res call({String id, String name, StudentAge age});
}

/// @nodoc
class _$StudentSummaryCopyWithImpl<$Res>
    implements $StudentSummaryCopyWith<$Res> {
  _$StudentSummaryCopyWithImpl(this._self, this._then);

  final StudentSummary _self;
  final $Res Function(StudentSummary) _then;

  /// Create a copy of StudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
  }) {
    return _then(StudentSummary(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as StudentAge,
    ));
  }
}

// dart format on
