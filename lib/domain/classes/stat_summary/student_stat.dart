import 'package:nawiapp/domain/classes/count_ratio.dart';

class StudentStat {
  final CountRatio threeAgeCount;
  final CountRatio fourAgeCount;
  final CountRatio fiveAgeCount;
  final int total;
  // final CountRatio studentIncidents;
  // final CountRatio ratedstudent;
  // final CountRatio mentionedStudents;

  const StudentStat({
    required this.threeAgeCount,
    required this.fourAgeCount,
    required this.fiveAgeCount,
    required this.total,
    // required this.studentIncidents,
    // required this.ratedstudent,
    // required this.mentionedStudents,    
  });
}