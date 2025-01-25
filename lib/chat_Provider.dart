import 'dart:math';
import 'package:chat_aap/device_token_service.dart';
import 'package:chat_aap/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'chat_model.dart';
import 'notification_service.dart';

class ChatViewModel with ChangeNotifier {
  final TextEditingController chatController = TextEditingController();
  final String chatHint = "Enter message";
  var chatList = <ChatModel>[];
  var userList = <UserModel>[];
  var uid = FirebaseAuth.instance.currentUser?.uid ?? "";
  String otherUId = "";
  NotificationService notificationService = NotificationService();
  DeviceTokenService deviceTokenService=DeviceTokenService();
  final _auth =FirebaseAuth.instance.currentUser!;

  getChatList({required String cid, required String otherId}) {
    var chatId = getChatId(cid: cid, otherId: otherId);

    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('messages/$chatId');

    starCountRef.orderByChild("dateTime").onValue.listen((DatabaseEvent event) {
      chatList.clear();
      var data = event.snapshot.children;
      data.forEach(
            (element) {
          var chat = ChatModel(
              senderId: element.child("sender_id").value.toString(),
              receiverId: element.child("receiver_id").value.toString(),
              message: element.child("message").value.toString(),
              status: element.child("status").value.toString());
          chatList.add(chat);
        },
      );
      notifyListeners();
    });
  }
  sendChat({required String otherUid})async {
    var cid = uid.toString();
    var chatId = getChatId(otherId: otherUid,cid: cid);
    var randomId = generateRandomString(40);
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('messages/$chatId');

    //sent, seen, unseen
    await starCountRef.child(randomId).set(ChatModel(message: chatController.text.toString(), senderId: "$uid",receiverId:  otherUid, status: "sent").toJson());
    String? deviceToken = await deviceTokenService.getDeviceTokenFromFirebase(otherUid);
    if (deviceToken!= null && deviceToken.isNotEmpty) {
      await notificationService.sendOrderNotification(
          message: chatController.text,
          token: deviceToken,
          senderName: _auth.displayName.toString());
    }
    chatController.clear();

    notifyListeners();
  }
  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  getUserList() {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('users');
    starCountRef.onValue.listen((DatabaseEvent event) {
      var data = event.snapshot.children;
      userList.clear();
      data.forEach(
            (element) {
          var user = UserModel(
              name: element.child("name").value.toString(),
              email: element.child("email").value.toString(),
              id: element.child("id").value.toString(),

          );
          userList.add(user);
        },
      );
      notifyListeners();
    });
  }


  String getChatId({required String cid, required String otherId}) {
    var id = "";
    if (cid.compareTo(otherId) > 0) {
      id = "${cid}_$otherId";
    } else {
      id = "${otherId}_$cid";
    }

    FirebaseDatabase.instance.ref('messages').child(id).get().then((value) {
      if (value.exists) {
      } else {
        var chatId =
        FirebaseDatabase.instance.ref().child("messages").child(id).set(id);
        print(chatId);
      }
    });
    return id;
    }
}
