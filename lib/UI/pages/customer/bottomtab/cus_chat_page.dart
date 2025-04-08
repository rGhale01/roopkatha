import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roopkatha/UI/pages/customer/bottomtab/bottomtab.dart';

class CusChatPage extends StatefulWidget {
  const CusChatPage({super.key});

  @override
  State<CusChatPage> createState() => _CusChatPageState();
}

class _CusChatPageState extends State<CusChatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> chatUsers = [];
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchChatUsers();
    fetchNotifications();
  }

  Future<void> fetchChatUsers() async {
    final response = await http.get(Uri.parse('https://yourapi.com/chat'));

    if (response.statusCode == 200) {
      setState(() {
        chatUsers = jsonDecode(response.body);
      });
    } else {
      debugPrint('Failed to load chat users');
    }
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(Uri.parse('https://yourapi.com/notifications'));

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body);
      });
    } else {
      debugPrint('Failed to load notifications');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.pink,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Message'),
            Tab(text: 'Notification'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Messages Tab
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.pink),
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: chatUsers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                  itemCount: chatUsers.length,
                  separatorBuilder: (_, __) => const Divider(indent: 85),
                  itemBuilder: (context, index) {
                    final user = chatUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['avatar']),
                        radius: 25,
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(user['message']),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user['time'],
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                          if (user.containsKey('unreadCount'))
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${user['unreadCount']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Notifications Tab
          notifications.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification['title']),
                subtitle: Text(notification['time']),
                leading: const Icon(Icons.notifications_none_rounded,
                    color: Colors.pink),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CusBottomTabs(currentIndex: 3),
    );
  }
}
