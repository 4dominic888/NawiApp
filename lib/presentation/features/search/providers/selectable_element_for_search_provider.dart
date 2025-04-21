import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/domain/models/student/entity/student.dart';

final selectableElementForSearchProvider = StateProvider<Type>((ref) => Student);