import 'package:chattingroom/models/user_model.dart';
import 'package:chattingroom/pages/home/home_page.dart';
import 'package:chattingroom/provider/search_page_provider.dart';
import 'package:chattingroom/provider/user_detail_update_page_provider.dart';
import 'package:chattingroom/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  final UserModel? userModel;
  const MainPage({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    Ui.setwh(context);
    UserModel.mainUserModel = userModel;
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
        home: HomePage(
          userModel: userModel,
        ),
      ),
    );
  }
}
