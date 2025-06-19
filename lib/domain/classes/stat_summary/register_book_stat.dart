import 'package:nawiapp/domain/classes/count_ratio.dart';

class RegisterBookStat {
  final CountRatio incidentCount;
  final CountRatio anecdoteCount;
  final CountRatio registerCount;
  final int total;

  const RegisterBookStat({
    required this.incidentCount,
    required this.anecdoteCount,
    required this.registerCount,
    required this.total
  });
}