import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_test/repository/news_repository.dart';
import 'package:second_test/screen/donwload/download_screen.dart';
import 'package:second_test/screen/news/cubit/news_cubit.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LuckyCash',
      home: BlocProvider(
        create: (context) => NewsCubit(NewsRepository()),
        child: DownloadScreen(),
      ),
    );
  }
}
