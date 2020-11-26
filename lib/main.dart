
import 'package:flutter/material.dart';

import 'file:///C:/Users/User/Documents/Flutter%20Projects/second_test/second_test/lib/screen/webView/webView_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'Dynamic Links Example',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => Download(),
    },
  ));
}

class Download extends StatefulWidget {
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  @override
  void initState() {
    super.initState();
    fetchLinkData();
  }

  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

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
    }
    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    handleLinkData(link, prefs);

    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink, prefs);
    });
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
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
