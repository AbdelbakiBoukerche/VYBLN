import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vybln/common/services/user_cache.dart';
import 'package:vybln/core/routing/app_router.dart';

import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../blocs/chats/chats_bloc.dart';
import '../repositories/chat_repository.dart';

class ChatsScreen extends StatelessWidget {
  static const String sPath = '/chat';
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsBloc(
        chatRepository: sl<ChatRepository>(),
      )..add(ChatsFetchChats()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          title: const Text('Chats'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(kScaffoldPaddingHoriz),
          child: _ChatsList(),
        ),
      ),
    );
  }
}

class _ChatsList extends StatelessWidget {
  const _ChatsList({
    Key? key,
  }) : super(key: key);

  ImageProvider _getImage(String? photoURL) {
    if (photoURL != null) {
      return CachedNetworkImageProvider(photoURL);
    }
    return const AssetImage('assets/images/blank-profile-picture.png');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (context, index) {
            final chat = state.chats[index];

            return Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: () {
                  sl<UserCache>().user = chat.peer;
                  GoRouter.of(context).push(AppRouter.sMessagingPath);
                },
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28.0,
                        backgroundImage: _getImage(chat.peer.photoURL),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.peer.fullname!,
                            style:
                                textTheme.bodyText1?.copyWith(fontSize: 15.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            chat.lastMessage.isEmpty ? 'N/A' : chat.lastMessage,
                            style: textTheme.caption,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            // return Text(chat.peer.uid);
          },
        );
      },
    );
  }
}
