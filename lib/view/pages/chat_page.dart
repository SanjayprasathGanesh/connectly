import 'package:auto_route/annotations.dart';
import 'package:connectly/model/chats/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../controller/local_login_storage.dart';
import '../../model/posts/posts_model.dart';
import '../../view_model/posts/chats_view_model.dart';
import '../../view_model/posts/post_view_model.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  final String userId;

  const ChatPage({super.key, required this.userId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatListViewModel chatViewModel = Get.find<ChatListViewModel>();
  final PostViewModel postViewModel = Get.find<PostViewModel>();

  final TextEditingController messageController = TextEditingController();

  final LocalLoginStorage credentials = Get.find<LocalLoginStorage>();
  String currentUserId = '';

  getUserId() async{
    currentUserId = (await credentials.getUserName())!;
    chatViewModel.fetchMessages('$currentUserId - ${widget.userId}');
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  void sendMessage() async{
    currentUserId = (await credentials.getUserName())!;
    if (messageController.text.isNotEmpty) {
      final message = Messages(
        fromUserId: currentUserId,
        targetUserId: widget.userId,
        postMap: null,
        message: messageController.text,
        sentTime: DateTime.now().toString(),
      );
      chatViewModel.sendMessage('$currentUserId - ${widget.userId}', message);
      messageController.clear();
      chatViewModel.fetchMessages('$currentUserId - ${widget.userId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId,style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),),
        backgroundColor: const Color(0xFFfb6f92),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatViewModel.messagesList.isEmpty) {
                return Center(
                  child: Text('Start a new conversation with ${widget.userId}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Colors.pink,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                );
              }
              return ListView.builder(
                reverse: true,
                itemCount: chatViewModel.messagesList.length,
                itemBuilder: (context, index) {
                  final message = chatViewModel.messagesList[index];
                  final isCurrentUser = (message.fromUserId == currentUserId) || (message.fromUserId?.trim() == currentUserId);
                  final post = message.postMap != null
                      ? Posts.fromJson(message.postMap!)
                      : null;

                  return Align(
                    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: post != null
                        ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          width: ResponsiveBreakpoints.of(context).isMobile ?
                          ResponsiveBreakpoints.of(context).screenWidth / 1.5 :
                          ResponsiveBreakpoints.of(context).screenWidth / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(width: 2.0),
                            color: isCurrentUser
                                ? Colors.blue[50]
                                : Colors.pinkAccent[100],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userId!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  post.location!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Container(
                                  height: 300,
                                  child: Center(
                                    child: postViewModel.displayPostImages(context, post.imageUrl!),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  post.description!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  message.sentTime!.split(".")[0],
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue[100]
                                  : Colors.purpleAccent[800],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  message.message ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  message.sentTime?.split(".")[0] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.0,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                IconButton(
                  color: const Color(0xFFffc2d1),
                  icon: const Icon(Icons.send, color: Colors.black,),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
