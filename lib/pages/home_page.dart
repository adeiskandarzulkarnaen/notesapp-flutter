

import 'package:flutter/material.dart';
import 'package:notesapp_flutter/pages/auth/login_page.dart';
import 'package:notesapp_flutter/pages/note/notes_page.dart';
import 'package:notesapp_flutter/pages/user/users_page.dart';
import 'package:notesapp_flutter/services/storage/shared_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() => _currentTabIndex = page);
        },
        children: const [
          NotesPage(),
          UsersPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: _onBottomNavbarTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.amber,
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: "notes",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            activeIcon: Icon(Icons.people_alt),
            icon: Icon(Icons.people_alt_outlined),
            label: "users"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            activeIcon: Icon(Icons.logout),
            label: "logout"
          ),
        ],
      ),
    );
  }

  void _onBottomNavbarTapped(int index) async {
    setState(() => _currentTabIndex = index );

    // jika di tekan tombol logout [bottom item index ke-2]
    if(index == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () async {
                  // menghapus alert dari stack
                  Navigator.of(context).pop();

                  // menghapus accessToken
                  await SharedStorageService.delAccessToken();  

                  // pindah ke halaman login
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }
}