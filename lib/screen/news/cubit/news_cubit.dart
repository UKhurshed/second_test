import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:second_test/model/news_model.dart';
import 'package:second_test/repository/news_repository.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;

  NewsCubit(this.newsRepository) : super(NewsInitial());

  Future<void> getNews(String query) async{
    try{
      // emit(SearchNewsLoading());
      final news = await newsRepository.getNews(query);
      emit(NewsLoaded(news));
    }catch(error){
      print('Error: $error');
      emit(NewsError(error));
    }
  }
}
