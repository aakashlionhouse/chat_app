import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationService{
  FirebaseMessaging messaging=FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
  Future<void>requestPermission ()async{
    NotificationSettings  settings = await messaging.requestPermission(
       alert: true,
      badge: true,
      sound: true,
      provisional: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print('user granrted permission');
    }else if (settings.authorizationStatus==AuthorizationStatus.provisional){
      print('user granted provisional permission');
    }else{
      AppSettings.openAppSettings();
      print('user denied permission');
    }
  }

  Future<String>generateSecretKey()async{

    var scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client= await clientViaServiceAccount(
    ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "flutterfirebase-e11ae",
      "private_key_id": "96f71322ff37fe124bc83f1d6389ea8b75f3b964",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCmhy8Vy5090IvY\nmBIhTlCmYQGDowIn2PEqPT/qc3UYG4J2o4THfSk0NI4u02GFnCJx6x3QXMTqnDFq\nfSZUkel3r8BQEeXAN/Bdr6HNTDgApy6LSw2ou1F2c7fENi17/nvxAXevTf7O8nhe\nUIm6zlWcBY8TiptMcayza4lz26NwQBpGFFgMSoFEGmSdAVkMO3khWJ6Q2wCc0xVy\njeuUuKJgyxJcqMjLGNBW9YfuZDesZKTC2kZ7FVgqLCAOCqT455TZOdwcEvHChhkT\n9OsE+GqVeQTuYDr9dRHVgToneUa2H24GeZXVKSlSNaWOC46WhTPNIbCHGb2j9dKh\nm6PoiR85AgMBAAECggEAA2iYvD3OXgfgMyRsYM0IyyDQEsnRC5cW20lBcOL5qu79\nN6Q6wTPna6wGYss0Lex+jqonrtkjtV9uMUmzKl/CptXzxTbokYuo6KPJHp1r/rL7\njwU6mAMB+79DSHRQU5SgefCCTk7ZY5LLpCjKhyMd1iUqGDmGaOi2v3a/652CvQVP\nwEVCEkapfR0sUbBCUD3psmyvrUQryqx4uZihopGQoaRT5jRtnE3MEBL7K6xidWTT\nrKjhM0ErOUzsKRqdw6ik17qD/rQ49NxhVlkHDQTGXvWCbEhxyMw4Hzh4/qlaewVq\nLon1sNoFBoDyzHFdf6ff1PEfDluA/JwNttamPxq2pQKBgQDXmXNavCpce363mFEE\nGMU4r0mO+2Ll/PsK261lftmDIiKyckVvHDzh8WOIxVUwrTNHG7plMGQF87JZij9P\nuTGduNfGUlEMqtiQditaxrcEbaYr2mH8GpzZMk88PjNvgCLXlKLw1IBbrTZGuT/v\nzEPRiFHj2dbNdhL0yn+KSr32EwKBgQDFu7mABUhe7R92h0LExZ4K8jrDzwEdia1z\nWNmWli7rEFWCx6gRANeT9q82RdVDQmtz413H8rrxAeHX2twGVmKZpnmBS2xAcjLU\nJ90vq3hJTgkUUfo/ErksFdxkJ3ZZrF6IwWmcQo3a1vstipH0pHYyFc+GNU7EpXMk\niPHdso9vAwKBgA+BKIuI5p75/pXjbUgXI++8o1SV/Xm+pKsWOzUGV0wX41jj4Nxp\nsnMpMdg/IK48dmiRtOjb/wVyjgvkZkMsdUX7agEIIG4Bx0s0RE/l5Hl8DSwwK0W/\nADKabJpPetF07IyGUuVw0r5FCZcycUekb+gcno79NnZWHGzgNyXR1DFjAoGAPt7v\nnnsPhc9Tn7ZmTnafR8+5S6U4L5IlKnXnyW+7P1aUOd8N20ovQYbAMzuFEbu+urxi\nhz7wnc0BaEbYitNQypYaMDgxFVS6QKbkN1IIDxbW4DUoooFri07wIpBBm0WpUUZe\nNCcdP6X3e4WB3w2j30z8DSpJ/1C0CbvZW6p43M0CgYEAjB2x9+EMqOittribyuXU\nbNrb6JrNrKyldYJX8tX3PRt/50z/RgDHboa/WLQ/uLvmZbYvAt/d9ESaEi60SnuQ\nrojTUIv/Vf/PnpKlbHtugjE0Nsl/1BlZzBbnaK22BpiAWOs7s7MhkTWThOjgcoHl\nAtrAYP0ptUZYGZvpBG14Ve0=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-ybfv3@flutterfirebase-e11ae.iam.gserviceaccount.com",
      "client_id": "115395890400977696221",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ybfv3%40flutterfirebase-e11ae.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
    ),scopes
    );
    final serverKey=client.credentials.accessToken.data;
    print("serverKey=$serverKey");
    return serverKey;
    }

    Future<void>initApp()async{
    AndroidInitializationSettings androidInitializationSettings=AndroidInitializationSettings('@mipmap/ic_launcher');
    InitializationSettings initializationSettings=InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

  Future<void>showNotification(RemoteMessage message)async  {
    AndroidNotificationDetails androidNotificationDetails=const AndroidNotificationDetails(
        'chatschannel',
        'chats_channel',
        importance: Importance.max,
        priority: Priority.high
    );
    int notificationId=1;
    NotificationDetails notificationDetails=NotificationDetails(android:androidNotificationDetails );
    await flutterLocalNotificationsPlugin.show(
        notificationId,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: 'Not Present'
        );
    }

  Future<void> sendOrderNotification({required String message,required String token,required String senderName})async{
    print('token id :$token');
    final serverKey=await generateSecretKey();
    try{
      final response=await http.post(Uri.parse('https://fcm.googleapis.com/v1/projects/flutterfirebase-e11ae/messages:send'),
          headers: <String,String>{
            'Content-Type':'application/json',
            'Authorization':'Bearer $serverKey  '
          },
          body: jsonEncode(<String, dynamic>{
            "message":{
              "token":token,
              "notification":{
                "title":senderName,
                "body":message
              }
            }
          })
      );
      if(response.statusCode==200){
      }else{
        print('failed to send notification,Status code:${response.statusCode}');
        Fluttertoast.showToast(msg: 'Failed to send notification');
      }
    }catch(ex){
      print('error sending notification: $ex');
      Fluttertoast.showToast(msg: 'error sending notification');
    }
    }
}


