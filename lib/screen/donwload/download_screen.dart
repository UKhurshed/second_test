import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:second_test/app.dart';
import 'package:second_test/screen/news/news.dart';
import 'package:second_test/screen/webView/webView_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  void initState() {
    super.initState();
    fetchLinkData();
  }

  Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  Map event;
  String fireStoreLink;

  void fetchLinkData() async {
    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    SharedPreferences prefs = await preferences;
    if (prefs.getString("dynamic") != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewScreen(link: prefs.getString("dynamic"))));
    } else {
      // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
      handleLinkData(link, prefs);
      print('else expression');
      // This will handle incoming links if the application is already opened
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
        handleLinkData(dynamicLink, prefs);
      });
      print('content started');
      print('link: $link');
      if (link == null) {
        try {
          DocumentSnapshot ds = await FirebaseFirestore.instance
              .collection("user")
              .doc("R0PYJ0EypHWtlzmJ24ab")
              .get();
          event = ds.data();
          print("Link: ${event['link']}");
          fireStoreLink = event['link'];
          if (fireStoreLink.isEmpty || fireStoreLink == null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => News()));
          } else {
            String decodeLink = utf8.decode(base64.decode(event['link']));
            print("DecodeLink: $decodeLink");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(link: decodeLink)));
          }
        } catch (error) {
          print('Error:$error');
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => News()));
        }
      }
    }
  }

  void handleLinkData(
      PendingDynamicLinkData data, SharedPreferences pref) async {
    final Uri uri = data?.link;
    if (pref.getString("dynamic") == null) {
      if (uri != null) {
        pref.setString("dynamic", uri.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewScreen(link: uri.toString())));
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewScreen(link: pref.getString("dynamic"))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
