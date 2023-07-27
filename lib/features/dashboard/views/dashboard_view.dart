import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/views/chats_view.dart';
import 'package:flutterwrite_chat_jul23/features/phone_contacts/views/phone_contacts_view.dart';
import 'package:flutterwrite_chat_jul23/features/settings/views/settings_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _currentIndex = 0;
  void _changePage(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  final _views = const [
    ChatsView(),
    PhoneContactsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    // final currentUserModel = ref.watch(authControllerProvider);
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => _changePage(i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
              ),
              label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Friends'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
              ),
              label: 'Settings'),
        ],
      ),
    );
  }
}
