import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DynemicLink extends StatefulWidget {
  const DynemicLink({super.key});

  @override
  State<DynemicLink> createState() => _DynemicLinkState();
}

class _DynemicLinkState extends State<DynemicLink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: 20),
            child: ElevatedButton(onPressed: ()async{
              var text=await getDynemicLink();
              Share.share(text.toString());
            }, child: Text('Generate Link')),
          )
        ],
      ),
    );
  }
  Future<Uri>getDynemicLink()async{
    var  shortLink =await FirebaseDynamicLinks.instance.buildShortLink(DynamicLinkParameters(
        link: Uri.parse("https://phoneauthfirbase.page.link"),
        uriPrefix: "https://phoneauthfirbase.page.link",
      androidParameters: AndroidParameters(packageName: 'com.example.chat_aap')
    )
    );
    return shortLink.shortUrl;
  }
}
