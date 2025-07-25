import 'package:flutter/material.dart';
import 'package:flutter_common/constants/juny_constants.dart';
import 'package:flutter_common/flutter_common.dart';
import 'package:flutter_common/state/user/user_bloc.dart';
import 'package:flutter_common/state/user/user_event.dart';
import 'package:flutter_common/state/user/user_selector.dart';
import 'package:flutter_common/widgets/layout/notice_screen_layout.dart';
import 'package:flutter_common/widgets/layout/setting_screen_layout.dart';
import 'package:money_tree/widgets/screens/home_screen.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _currentIndex = 0;
  UserBloc get userBloc => context.read<UserBloc>();

  @override
  void initState() {
    super.initState();
    userBloc.add(const UserEvent.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            HomeScreen(),
            Text('Search'),
            Text('Profile'),
            UserInfoSelector((user) {
              if (user == null) {
                return const SizedBox.shrink();
              }
              return NoticeScreenLayout(
                groupName: 'parking-zone-code-02782',
                user: user,
              );
            }),
            SettingScreenLayout(appKey: AppKeys.moneyTree),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notice',
            backgroundColor: Colors.grey[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
            backgroundColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
