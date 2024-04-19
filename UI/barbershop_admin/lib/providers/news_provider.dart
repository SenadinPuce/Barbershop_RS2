import '../models/news.dart';
import 'base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super("News");

  @override News fromJson(item) {
    return News.fromJson(item);
  }
}
