import 'package:nawiapp/domain/classes/count_ratio.dart';

class StudentStat {
  final CountRatio threeAgeCount;
  final CountRatio fourAgeCount;
  final CountRatio fiveAgeCount;
  final int total;
  //* CountRatio studentIncidents
  //* CountRatio ratedstudent
  //* CountRatio mentionedStudents

  StudentStat({
    required this.threeAgeCount,
    required this.fourAgeCount,
    required this.fiveAgeCount,
    required this.total
  });
}