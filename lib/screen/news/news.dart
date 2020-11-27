import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_test/repository/news_repository.dart';
import 'package:second_test/screen/news/cubit/news_cubit.dart';
import 'package:second_test/screen/news/news_screen.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NewsInit(NewsRepository()),
    );
  }
}
