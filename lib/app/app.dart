import 'package:chattingroom/pages/welcome/welcome_page.dart';
import 'package:chattingroom/provider/search_page_provider.dart';
import 'package:chattingroom/provider/user_detail_update_page_provider.dart';
import 'package:chattingroom/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal(); // Named Constructor

  static const MyApp _instance = MyApp._internal(); // Singleton

  factory MyApp() => _instance; // Factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
     Ui.setwh(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDetailUpdateProvider>(
          create: (context) => UserDetailUpdateProvider(),
        ),
        ChangeNotifierProvider<SearchPageProvider>(
          create: (context) => SearchPageProvider(),
        ),
      ],
      child: MaterialApp(
        theme: Ui.getTheme(),
        debugShowCheckedModeBanner: false,
        home: const WelcomePage(),
      ),
    );
  }
}
