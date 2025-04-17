import 'package:flutter/material.dart';
import 'package:myapp/component/navComponents/nav_admin.dart';
import 'package:myapp/component/navComponents/nav_disconnected.dart';
import 'package:myapp/component/navComponents/nav_user.dart';
import 'package:myapp/user.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await User.create();
  //user.cookieJar;
  runApp(
    ChangeNotifierProvider(
      create: (_) => user,
      child: MyApp(),
    ),
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      initialRoute: '/disconnected',
      routes: {
        '/disconnected': (context) => const NavDisconnected(),
        '/user': (context) => const NavUser(),
        '/admin': (context) => const NavAdmin(),
      },
    );
  }
}
