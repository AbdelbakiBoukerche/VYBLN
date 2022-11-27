import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vybln/core/routing/app_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          elevation: 2.0,
          actions: [
            IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRouter.sChatsPath);
              },
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
