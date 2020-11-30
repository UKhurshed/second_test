import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  final String link;

  const WebViewScreen({this.link});

  @override
  _WebViewScreen createState() => _WebViewScreen(link);
}

class _WebViewScreen extends State<WebViewScreen> {
  _WebViewScreen(this._link);

  final String _link;

  Future<bool> _onBack() async {
    bool goBack;
    var value = await webView.canGoBack();
    if (value) {
      webView.goBack(); // perform webview back operation
      return false;
    } else {
      await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: Text('Confirmation', style: TextStyle(color: Colors.purple)),
          // Are you sure?
          content: Text('Do you want exit app ? '),
          // Do you want to go back?
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  goBack = false;
                });
              },
              child: Text("No"), // No
            ),
            FlatButton(
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
                setState(() {
                  goBack = true;
                });
              },
              child: Text('Yes'), // Yes
            ),
          ],
        ),
      );
      if (goBack) Navigator.pop(context);
      return goBack;
    }
  }

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: InAppWebView(
            initialUrl: _link,
            onWebViewCreated: (InAppWebViewController controller){
              webView = controller;
            },
          )
        ),
        onWillPop: _onBack);
  }

  @override
  void initState() {
    super.initState();
  }
}
