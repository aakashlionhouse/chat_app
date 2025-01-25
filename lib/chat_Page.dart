import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_Provider.dart';
import 'home_page.dart';

class MassagePage extends StatefulWidget {
  final String otherUid;
  final String? email;
  final String? otherName;
  final String? otherProfilePic;

  MassagePage(
      {super.key,
        required this.otherName,
        this.otherProfilePic,
        required this.email,
        required this.otherUid});

  @override
  State<MassagePage> createState() => _MassagePageState();
}

class _MassagePageState extends State<MassagePage> {
  final uId = FirebaseAuth.instance.currentUser?.uid;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    Future.delayed(
      Duration(seconds: 2),
          () async {
        var viewModel = Provider.of<ChatViewModel>(context, listen: false);
        var chatRoomId = await viewModel.getChatList(
          cid: uid,
          otherId: widget.otherUid,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHomePage(uid: ""),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherProfilePic != null
                  ? NetworkImage(widget.otherProfilePic!)
                  : null,
              child: widget.otherProfilePic == null
                  ? Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherName ?? "Unknown User",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email??'',
                  style: TextStyle(
                    fontSize: 14,
                   fontWeight: FontWeight.normal
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height -
                210 -
                MediaQuery.of(context).viewInsets.bottom,
            child: Consumer<ChatViewModel>(
              builder: (context, value, child) {
                if (value.chatList.isEmpty) {
                  return const Text("No chat available");
                }
                return ListView.builder(
                  controller: controller,
                  itemCount: value.chatList.length,
                  itemBuilder: (context, index) {
                    var user = value.chatList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: user.senderId == uId
                          ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.sizeOf(context).width / 1.2),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            '${user.message}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ),
                      )
                          : Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                              maxWidth:
                              MediaQuery.sizeOf(context).width / 1.2),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text('${user.message}'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 110,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: TextField(
                      controller: viewModel.chatController,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      viewModel.sendChat(otherUid: widget.otherUid);
                      Future.delayed(Duration(milliseconds: 300), () {
                        controller.jumpTo(controller.position.maxScrollExtent);
                      });
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 26,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
