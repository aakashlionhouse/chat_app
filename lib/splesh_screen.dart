import 'package:chat_aap/lohin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});

  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),() {
      if (auth.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatHomePage(uid: auth.currentUser!.uid,),));
      }
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
      }
    },);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
