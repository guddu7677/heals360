import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hells360/core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('bn'),
        Locale('te'),
        Locale('mr'),
        Locale('ta'),
        Locale('ur'),
        Locale('gu'),
        Locale('kn'),
        Locale('or'),
        Locale('ml'),
        Locale('pa'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Heal360 Wellness',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(),
      routerConfig: AppRouter.router,
    );
  }
}

