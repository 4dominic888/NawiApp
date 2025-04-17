import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/locator.dart';
import 'package:nawiapp/presentation/home/screen/home_screen.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();

  //* Originalmente llamado Ñawi, pero para evitar futuros errores con caracteres especiales, se reemplaza la Ñ por N.
  runApp(ProviderScope(child: const NawiApp()));
}

class NawiApp extends StatelessWidget {
  const NawiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Menu principal',
        debugShowCheckedModeBanner: false,
        home: const MenuApp(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: NawiColorUtils.primaryColor, brightness: Brightness.light,
            secondary: NawiColorUtils.secondaryColor
          ),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: NawiColorUtils.buttonColor)
          ),
          textTheme: TextTheme(
            bodyLarge: const TextStyle(color: NawiColorUtils.textColor),
            bodyMedium: const TextStyle(color: NawiColorUtils.textColor),
            headlineMedium: const TextStyle(color: NawiColorUtils.titlesColor)
          ),
          hoverColor: NawiColorUtils.hoverColor,
          scrollbarTheme: ScrollbarThemeData(
            thumbVisibility: WidgetStateProperty.all<bool>(true)
          ),
        ),
      ),
    );
  }
}

class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  State<MenuApp> createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ñawi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          centerTitle: true,
        ),
        body: HomeScreen()
      ),
    );
  }
}