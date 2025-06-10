import 'package:nawiapp/utils/nawi_general_utils.dart';

class MapperUtils {
  static String mentionLabel(String name) => name.replaceAll(' ', '_').toLowerCase();

  static String initialName(String name) {
    name = NawiGeneralUtils.clearSpaces(name);
    if(name.isEmpty) return '0';
    final separatedBySpaces = name.split(' ');
    return "${separatedBySpaces[0][0].toUpperCase()}${separatedBySpaces.elementAtOrNull(1)?[0].toUpperCase() ?? ''}";
  }
}
