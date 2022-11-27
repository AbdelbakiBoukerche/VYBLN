import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection_container.dart';
import 'core/routing/app_router.dart';
import 'features/auth/blocs/auth/auth_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        routerConfig: AppRouter.sRouter,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          // textTheme: kTextTheme,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF27A9FF),
            onPrimary: Colors.white,
            error: Color(0xFFba1a1a),
            onError: Color(0xFFffffff),
            errorContainer: Color(0xFFffdad6),
            onErrorContainer: Color(0xFF410002),
            background: Color(0xFFfdfcff),
            onBackground: Color(0xFF1a1c1e),
            surface: Color(0xFFfdfcff),
            onSurface: Color(0xFF1a1c1e),
            surfaceVariant: Color(0xFFE8E8E8),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0xFFFAFAFA),
            selectedIconTheme: const IconThemeData(
              color: Color(0xFF0097FF),
            ),
            unselectedIconTheme: IconThemeData(
              color: const Color(0xFF1a1c1e).withOpacity(0.54),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFFAFAFA),
            titleTextStyle: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF1a1c1e),
            ),
            iconTheme: IconThemeData(
              color: Color(0xFF1a1c1e),
            ),
            actionsIconTheme: IconThemeData(
              color: Color(0xFF27A9FF),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF0097FF),
            onPrimary: Colors.white,
            error: Color(0xFFffb4ab),
            onError: Color(0xFF690005),
            errorContainer: Color(0xFF93000a),
            onErrorContainer: Color(0xFFffdad6),
            background: Color(0xFF1a1c1e),
            onBackground: Color(0xFFe2e2e5),
            surface: Color(0xFF1a1c1e),
            onSurface: Color(0xFFe2e2e5),
            surfaceVariant: Color(0xFF1F1F1F),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFF0097FF),
            ),
            unselectedIconTheme: IconThemeData(
              color: const Color(0xFFe2e2e5).withOpacity(0.54),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(
              fontSize: 16.0,
              color: Color(0xFFe2e2e5),
            ),
            iconTheme: IconThemeData(
              color: Color(0xFFe2e2e5),
            ),
            actionsIconTheme: IconThemeData(
              color: Color(0xFF0097FF),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        title: 'VYBLN',
      ),
    );
  }
}
