import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/app_routes.gr.dart';
import 'package:connectly/view_model/posts/chats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@RoutePage()
class MyChats extends StatefulWidget {
  const MyChats({super.key});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  ChatListViewModel chatListViewModel = Get.find<ChatListViewModel>();

  Future<void> _refreshChats() async {
    await chatListViewModel.fetchUsers();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _refreshChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshChats,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            return ListView.builder(
              itemCount: chatListViewModel.usersList.length,
              itemBuilder: (context, index) {
                final user = chatListViewModel.usersList[index];
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.purple),
                      title: Text(user.userId!),
                      onTap: () {
                        context.router.push(ChatRoute(userId: user.userId!));
                      },
                    ),
                    const Divider(thickness: 2.0, color: Colors.black,),
                  ],
                );
              },
            );
          }),
        ),
    );
  }
}
