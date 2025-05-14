import 'package:flutter/material.dart';
import 'package:myapp/dataClass/category.dart';
import 'package:myapp/component/navComponents/nav_admin.dart';
import 'package:myapp/component/navComponents/nav_disconnected.dart';
import 'package:myapp/component/navComponents/nav_user.dart';
import 'package:myapp/dataClass/themeProvider.dart';
import 'package:myapp/dataClass/user.dart';
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
      child: ReSourcesRelationelles(),
    ),
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class ReSourcesRelationelles extends StatefulWidget {
  ReSourcesRelationelles({super.key});

  @override
  _ReSourcesRelationellesState createState() => _ReSourcesRelationellesState();
}

class _ReSourcesRelationellesState extends State<ReSourcesRelationelles> {
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
