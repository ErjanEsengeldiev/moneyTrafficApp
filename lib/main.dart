import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_traffic_app/bloc/theme_bloc.dart';
import 'package:money_traffic_app/init/lang/codegen_loader.g.dart';
import 'package:money_traffic_app/init/lang/language_manager.dart';
import 'package:money_traffic_app/ui/pages/main_page/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('theme');

  Future<void> _checkHiveTheme() async {
    if (Hive.box('theme').isEmpty) {
      await Hive.box('theme').put('theme', 'dark');
    }
  }

  await _checkHiveTheme();
  runApp(
    EasyLocalization(
        supportedLocales: LanguageManager.instance.supportedLocales,
        saveLocale: true,
        startLocale: LanguageManager.instance.ruLocale,
        fallbackLocale: LanguageManager.instance.supportedLocales.first,
        assetLoader: const CodegenLoader(),
        path: 'assets/translations',
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData themeFromHive;
  final themeBox = Hive.box('theme');
  final ThemeBloc themeBloc = ThemeBloc();

  ThemeData themeFromHiveFunc() {
    if (themeBox.get('theme') == 'dark') {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }

  @override
  void initState() {
    themeFromHive = themeFromHiveFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => themeBloc,
      child: BlocConsumer<ThemeBloc, ThemeState>(
        bloc: themeBloc,
        listener: (context, state) {
          if (state is ThemeChangedState) {
            themeFromHive = state.theme;
          }
        },
        builder: (context, state) => MaterialApp(
          title: 'Flutter Demo',
          theme: themeFromHive,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routes: {
            '/': (context) => const MyHomePage(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
