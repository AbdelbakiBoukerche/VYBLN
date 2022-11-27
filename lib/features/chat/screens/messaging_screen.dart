import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../common/models/user.dart';
import '../../../common/services/user_cache.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../auth/blocs/auth/auth_bloc.dart';
import '../blocs/messaging/messaging_bloc.dart';
import '../models/message.dart';

class MessagingScreen extends HookWidget {
  static const String sPath = '/messaging';
  const MessagingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;
    final peer = sl<UserCache>().user!;

    final controller = useTextEditingController();

    return BlocProvider(
      create: (context) => MessagingBloc(
        peer: user,
        user: peer,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(peer.fullname!),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kScaffoldPaddingHoriz),
            child: Column(
              children: [
                const _MessagesSection(),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: _MessageInput(controller: controller),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      _SendButton(controller: controller)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MessagingBloc>();

    return Ink(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        onPressed: () {
          final value = controller.text;
          bloc.add(MessagingSendMessage(value));
          controller.clear();
        },
        icon: const Icon(Icons.send_rounded),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MessagingBloc>();

    return TextField(
      controller: controller,
      onSubmitted: (value) {
        bloc.add(MessagingSendMessage(value));
        controller.clear();
      },
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: 'Write something...',
      ),
    );
  }
}

class _MessagesSection extends StatelessWidget {
  const _MessagesSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bloc = context.read<MessagingBloc>();

    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(bloc.chatID())
            .collection('messages')
            .orderBy('sentAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                if (doc.data()['sentAt'] == null) {
                  return const SizedBox();
                }

                final msg = Message.fromMap(
                  doc.data(),
                  userID: bloc.state.user.uid,
                  peerID: bloc.state.peer.uid,
                );

                if (msg.type == 'system') {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        msg.content,
                        style: textTheme.caption,
                      ),
                    ),
                  );
                }
                if (msg.type == 'text') {
                  if (msg.senderID == bloc.state.peer.uid) {
                    // Message From peer
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: LayoutBuilder(
                        builder: (contextn, constraints) {
                          return Container(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: decrypt(msg.contentPeer, bloc.state.peer),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    snapshot.data ?? '',
                                    style: textTheme.bodyText2?.copyWith(
                                      fontSize: 16.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  );
                                }
                                return Text(
                                  'N/A',
                                  style: textTheme.bodyText2?.copyWith(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Message From Me
                    return Align(
                      alignment: Alignment.centerRight,
                      child: LayoutBuilder(
                        builder: (contextn, constraints) {
                          return Container(
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: decrypt(msg.contentPeer, bloc.state.peer),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    snapshot.data ?? '',
                                    style: textTheme.bodyText2?.copyWith(
                                      fontSize: 16.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  );
                                }
                                return Text(
                                  'N/A',
                                  style: textTheme.bodyText2?.copyWith(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
                return const SizedBox();
              },
            );
          }
          return const Text('no data');
        },
      ),
    );
  }

  Future<String> decrypt(String cipher, User user) async {
    final encrypter = en.Encrypter(
      en.RSA(
        publicKey: await user.getPublicKey(),
        privateKey: await user.getPrivateKey(),
      ),
    );

    final result = encrypter.decrypt64(cipher);
    return result;
  }
}
