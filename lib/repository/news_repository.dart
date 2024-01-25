import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news/models/categories_news_model.dart';
import 'package:news/models/news_channel_headlines_model.dart';

class NewsRepository{

  // My Personal Api Key Given to me by newsapi.org site
  final clientId = dotenv.env['NewsApiKey_Url'];
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String channelName) async{

    String baseUrl = 'https://newsapi.org/';
    String topHeadlinesUrl = 'v2/top-headlines?sources=$channelName&apiKey=';

    final url = baseUrl+topHeadlinesUrl+clientId! ;
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }

    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{

    String baseUrl = 'https://newsapi.org/';
    String topHeadlinesUrl = 'v2/everything?q=$category&apiKey=';

    final url = baseUrl+topHeadlinesUrl+clientId! ;
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }

    throw Exception('Error');
  }
}