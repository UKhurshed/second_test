import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second_test/model/news_model.dart';
import 'package:second_test/repository/news_repository.dart';
import 'package:second_test/screen/details/details_screen.dart';
import 'package:second_test/screen/news/cubit/news_cubit.dart';

class NewsInit extends StatelessWidget {
  final NewsRepository newsRepository;

  const NewsInit(this.newsRepository);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => NewsCubit(newsRepository), child: NewsScreen(),);
  }
}


class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsError) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Error'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
        if (state is NewsInitial) {
          return loadingIndicator();
        }
        if (state is NewsLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: state.news.articles.length,
            itemBuilder: (context, index) {
              Article item = state.news.articles[index];
              return Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _onNewsTap(item),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          item.urlToImage ?? 'https://www.pngitem.com/pimgs/m/254-2549834_404-page-not-found-404-not-found-png.png',
                          height: 200,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      item.title,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(item.description,
                        maxLines: 2,
                        style: TextStyle(color: Colors.black54, fontSize: 14))
                  ],
                ),
              );
            },
          );
        } else {
          return Center(
            child: Text('Nop'),
          );
        }
      },
    ));
  }

  _onNewsTap(Article article) {
    // Navigator.pushNamed(context, DetailsScreen.routeName);
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(), settings: RouteSettings(arguments: DetailsArgument(article))));
  }

  Widget loadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  void initState() {
    final news = context.read<NewsCubit>();
    super.initState();
    news.getNews('tech');
  }
}