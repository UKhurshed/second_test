import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:second_test/model/news_model.dart';

class NewsRepository {
  static const BASE_URL = 'https://newsapi.org/v2/top-headlines?';
  static const API_KEY = '40263c7dfce94e56b07bf112da413229';

  Future<News> getNews(String query) async {
    News news;
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    var FROM = formatter.format(now);
    try {
      print('Date: $FROM');
      final http.Response response = await http.get(
          '${BASE_URL}q=$query&apiKey=$API_KEY');
      if (response.statusCode == 200) {
        print('Response Data: ${response.body}');
        news = News.fromJson(jsonDecode(response.body));
      }
      return news;
    } catch (error) {
      print('Error: $error');
      throw Exception(error);
    }
  }
}
