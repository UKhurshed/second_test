import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:second_test/model/news_model.dart';

class DetailsArgument {
  final Article article;

  const DetailsArgument(this.article);
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DetailsArgument args = ModalRoute.of(context).settings.arguments;
    return Scaffold(body: DetailsScreen(article: args.article));
  }
}

class DetailsScreen extends StatefulWidget {
  final Article article;
  static final routeName = 'Details';

  const DetailsScreen({this.article});

  @override
  _DetailsScreenState createState() => _DetailsScreenState(article);
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Article article;
  String content = 'content';
  String title = 'title';
  final focusNode = FocusNode();

  _DetailsScreenState(this.article);

  @override
  void initState() {
    super.initState();
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      setState(() {
        title = notification.payload.title;
        content = notification.payload.body;
      });
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Notification');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(article.author ?? ''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    article.urlToImage ??
                        'https://www.pngitem.com/pimgs/m/254-2549834_404-page-not-found-404-not-found-png.png',
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(article.title ?? '',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 10,
              ),
              Text(article.description ?? '',
                  style: TextStyle(color: Colors.black54, fontSize: 18)),
              SizedBox(
                height: 25,
              ),
              Text(title ?? ''),
              SizedBox(
                height: 10,
              ),
              Text(content ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
