import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';

class OpenSansFont {
  final Font regular;
  final Font bold;
  final Font italic;

  OpenSansFont._(this.regular, this.bold, this.italic);

  static Future<OpenSansFont> load() async {
    final regular = Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Regular.ttf'));
    final bold = Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Bold.ttf'));
    final italic = Font.ttf(await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'));
    return OpenSansFont._(regular, bold, italic);
  }
}