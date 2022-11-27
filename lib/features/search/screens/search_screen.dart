import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../../common/services/user_cache.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../../core/routing/app_router.dart';
import '../blocs/search/search_bloc.dart';
import '../repositories/search_repository.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(searchRepository: sl<SearchRepository>()),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kScaffoldPaddingHoriz),
          child: Column(
            children: const [
              _SearchInput(),
              SizedBox(height: 24.0),
              Expanded(child: _SearchResults()),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends HookWidget {
  const _SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    final controller = useTextEditingController();

    return TextField(
      onChanged: (value) {
        bloc.add(SearchValueChanged(value));
      },
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            width: 0.0,
            style: BorderStyle.none,
          ),
        ),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          onPressed: () {
            controller.clear();
            bloc.add(const SearchValueChanged(''));
          },
          splashRadius: 20.0,
          icon: const Icon(Icons.close_rounded),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({Key? key}) : super(key: key);

  ImageProvider _getImage(String? photoURL) {
    if (photoURL != null) {
      return CachedNetworkImageProvider(photoURL);
    }
    return const AssetImage('assets/images/blank-profile-picture.png');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchFetchingInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchFetchingFailed) {
          return const Center(child: Text('Fetching Failed'));
        }
        if (state is SearchFetchingSuccess) {
          return ListView.separated(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];

              return Ink(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    sl<UserCache>().user = user;

                    GoRouter.of(context).push(AppRouter.sPeerProfilePath);
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
                          backgroundImage: _getImage(user.photoURL),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullname!,
                              style:
                                  textTheme.bodyText1?.copyWith(fontSize: 15.0),
                            ),
                            // const SizedBox(height: 4.0),
                            Text(
                              '@${user.username!}',
                              style: textTheme.caption,
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          child: const Text('Follow'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12.0);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
