import 'package:news/models/categories_news_model.dart';
import 'package:news/repository/news_repository.dart';
import '../models/news_channel_headlines_model.dart';


class NewsViewModel{

  final _repo = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName) async{
    final response = await _repo.fetchNewsChannelsHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{
    final response = await _repo.fetchCategoriesNewsApi(category);
    return response;
  }
}