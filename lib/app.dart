import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/index.dart';
import 'resources/generated/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<LocaleCubit, Locale>(
    bloc: getIt<LocaleCubit>(),
    builder: (context, locale) => BlocBuilder<ThemeCubit, Brightness>(
      bloc: getIt<ThemeCubit>(),
      builder: (context, brightness) => MaterialApp.router(
        routerConfig: getIt<GoRouter>(),
        locale: locale,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: SupportLocale.support,
        theme: ThemeData(brightness: brightness),
      ),
    ),
  );
}
