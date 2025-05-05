import 'package:flutter/material.dart';
import 'package:myapp/category.dart';
import 'package:myapp/component/navComponents/nav_admin.dart';
import 'package:myapp/component/navComponents/nav_disconnected.dart';
import 'package:myapp/component/navComponents/nav_user.dart';
import 'package:myapp/themeProvider.dart';
import 'package:myapp/user.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await User.create();
  //user.cookieJar;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => user),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MyApp(),
    ),
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.getCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.theme,
          navigatorObservers: [routeObserver],
          initialRoute: '/disconnected',
          routes: {
            '/disconnected': (context) =>
                NavDisconnected(toggleTheme: themeProvider.toggleTheme),
            '/user': (context) =>
                NavUser(toggleTheme: themeProvider.toggleTheme),
            '/admin': (context) =>
                NavAdmin(toggleTheme: themeProvider.toggleTheme),
          },
        );
      },
    );
  }
}
