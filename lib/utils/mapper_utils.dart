import 'package:nawiapp/utils/nawi_general_utils.dart';
import 'package:recase/recase.dart';

class MapperUtils {
  static String mentionLabel(String name) => name.replaceAll(' ', '_').toLowerCase();

  static String toSlug(String action) {
    final buffer = StringBuffer();
    for (String word in action.split(' ')) {
      if(word.startsWith('@')) word = word.replaceFirst('@', '').replaceAll('_', ' ').titleCase;
      buffer.write(word);
      buffer.write(' ');
    }
    return NawiGeneralUtils.clearSpaces(buffer.toString());
  }

  static String initialName(String name) {
    if(name.isEmpty) return '0';
    final separatedBySpaces = name.split(' ');
    return "${separatedBySpaces[0][0].toUpperCase()}${separatedBySpaces.elementAtOrNull(1)?[0].toUpperCase() ?? ''}";
  }
}
