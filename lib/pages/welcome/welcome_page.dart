import 'package:chattingroom/pages/auth/sign_in_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/theme.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/network.jpg',
                    width: double.infinity,
                    height: Ui.height! / 3,
                  ),
                  Wrap(
                    children: [
                      Text(
                        'Welcome to ',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'chattingroom!',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: Ui.mainColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Where conversations come to life! Seamlessly connect with friends, family, and new acquaintances in private, real-time chats.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const SignInUpPage()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.phone),
                          Text(
                            'Continue with Phone Number',
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //keytool -list -v -alias androiddebugkey -keystore C:\Users\YN\.android\debug.keystore
                  
                  // SizedBox(
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     style: Theme.of(context)
                  //         .elevatedButtonTheme
                  //         .style!
                  //         .copyWith(
                  //             backgroundColor:
                  //                 MaterialStatePropertyAll(Colors.black)),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           CupertinoPageRoute(
                  //               builder: (_) => const AnonymousSignIn()));
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         const Icon(Icons.visibility_off),
                  //         const SizedBox(
                  //           width: 20,
                  //         ),
                  //         Text(
                  //           'Anonymous Chat Room',
                  //           style: Theme.of(context).textTheme.displayMedium,
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
