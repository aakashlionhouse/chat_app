
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String? senderId;
  String? receiverId;
  String? message;
  String? status;
  String? dateTime;


  // DateTime? time;

  ChatModel({
    this.senderId,
    this.receiverId,
    this.message,
    this.status,
    this.dateTime

    // this.time,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    message: json["message"],
    status: json["status"],
    dateTime: json["dateTime"]

  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
    "status": status,
    "dateTime":DateTime.timestamp().toIso8601String()

  };
}
