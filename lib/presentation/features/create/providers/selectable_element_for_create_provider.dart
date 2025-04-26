import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';

final selectableElementForCreateProvider = StateProvider<Type>((ref) => Student);