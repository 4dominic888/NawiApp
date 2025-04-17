import 'package:nawiapp/infrastructure/nawi_utils.dart';
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
    return NawiTools.clearSpaces(buffer.toString());
  }
}
