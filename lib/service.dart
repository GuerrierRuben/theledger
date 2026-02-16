import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the/models.dart';

class ArticleService {
  static final ArticleService _instance = ArticleService._internal();

  factory ArticleService() {
    return _instance;
  }

  ArticleService._internal();

  String baseUrl = "https://api.spaceflightnewsapi.net/v4/articles";

  final List<Article> _favorites = [];

  List<Article> get favorites => List.unmodifiable(_favorites);

  void toggleFavorite(Article article) {
    if (isFavorite(article)) {
      _favorites.removeWhere((a) => a.id == article.id);
    } else {
      _favorites.add(article);
    }
  }

  bool isFavorite(Article article) {
    return _favorites.any((a) => a.id == article.id);
  }

  void removeFavorite(Article article) {
    _favorites.removeWhere((a) => a.id == article.id);
  }

  Future<List<Article>> getArticles() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((item) => Article.fromJson(item))
          .toList();
    } else {
      throw Exception('Erreur chargement articles');
    }
  }

  List<Article> getHardcodedArticles() {
    return [
      Article(
        1,
        'Donald Trump a la conquete de la Maison Blanche',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vehicula, nunc at sollicitudin ...',
        'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
        'Bing News',
        'https://www.bing.com',
      ),
      Article(
        2,
        'Donald Trump a la conquete de la Maison Blanche',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vehicula, nunc at sollicitudin ...',
        'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
        'Bing News',
        'https://www.bing.com',
      ),
      Article(
        3,
        'Donald Trump a la conquete de la Maison Blanche',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vehicula, nunc at sollicitudin ...',
        'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
        'Bing News',
        'https://www.bing.com',
      ),
    ];
  }
}
