part of 'news_cubit.dart';

@immutable
abstract class NewsState {
  const NewsState();
}

class NewsInitial extends NewsState {
  const NewsInitial();
}

class NewsLoaded extends NewsState{
  final News news;
  const NewsLoaded(this.news);
}

class NewsError extends NewsState{
  final String message;
  const NewsError(this.message);
}

