import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/domain/classes/filter/register_book_filter.dart';
import 'package:nawiapp/domain/services/register_book_service_base.dart';

final countRegisterBookProvider = FutureProvider.family<int, RegisterBookFilter>((ref, filter) async {
  final service = GetIt.I<RegisterBookServiceBase>();
  final result = await service.getAllCount(filter);
  return result.getValue ?? 0;
});