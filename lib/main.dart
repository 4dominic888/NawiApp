import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:nawiapp/infrastructure/secure_credential_manager.dart';
import 'package:nawiapp/locator.dart';
import 'package:nawiapp/presentation/features/auth/screens/auth_screen.dart';
import 'package:nawiapp/presentation/features/tutorial/screens/tutorial_screen.dart';
import 'package:nawiapp/utils/nawi_color_utils.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await FlutterLocalization.instance.ensureInitialized();
  await initializeDateFormatting('es', null);
  await GetIt.I.isReady<SecureCredentialManager>();
  await dotenv.load(fileName: ".env");

  //* Originalmente llamado Ñawi, pero para evitar futuros errores con caracteres especiales, se reemplaza la Ñ por N.
  runApp(ProviderScope(child: const NawiApp()));
}

class NawiApp extends StatelessWidget {
  const NawiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        locale: const Locale('es', 'ES'),
        supportedLocales: const [
          Locale('es', 'ES'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Menu principal',
        debugShowCheckedModeBanner: false,
        home: GetIt.I<SecureCredentialManager>().tutorialSeen ?
              const AuthScreen() : 
              const TutorialScreen(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: NawiColorUtils.primaryColor, brightness: Brightness.light,
            secondary: NawiColorUtils.secondaryColor
          ),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: NawiColorUtils.primaryColor,
              shadowColor: Colors.black,
              elevation: 2
            )
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
