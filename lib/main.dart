import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/main_navigation.dart';
import 'services/binary_manager.dart';
import 'services/cookies_manager.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize embedded binaries
  await BinaryManager.initialize();
  
  // Initialize cookies
  await CookiesManager.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MediaGrabApp(),
    ),
  );
}

class MediaGrabApp extends StatelessWidget {
  const MediaGrabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {
        return MaterialApp(
          title: 'MediaGrab',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeProvider.lightTheme.copyWith(
            textTheme: GoogleFonts.interTextTheme(ThemeProvider.lightTheme.textTheme),
          ),
          darkTheme: ThemeProvider.darkTheme.copyWith(
            textTheme: GoogleFonts.interTextTheme(ThemeProvider.darkTheme.textTheme),
          ),
          locale: localeProvider.locale,
          supportedLocales: LocaleProvider.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const MainNavigation(),
        );
      },
    );
  }
}
