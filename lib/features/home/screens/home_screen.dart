import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/repositories/user_repository.dart';
import '../../../core/injection_container.dart';
import '../../profile/blocs/profile/profile_bloc.dart';
import '../../profile/screens/profile_screen.dart';
import '../../search/screens/search_screen.dart';
import 'home_view.dart';

class HomeScreen extends HookWidget {
  static const String sPath = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 5);
    final index = useState<int>(0);

    return Scaffold(
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeView(),
          const SearchScreen(),
          Container(),
          Container(),
          BlocProvider(
            create: (context) => ProfileBloc(
              userRepository: sl<UserRepository>(),
            )..add(ProfileFetchStats()),
            child: const ProfileScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: index.value,
        onTap: (value) {
          index.value = value;
          controller.animateTo(index.value);
        },
        iconSize: 18.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.plus),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.heart),
            label: 'Heart',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
