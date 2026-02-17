import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  static final ArticleService _instance = ArticleService._internal();

  factory ArticleService() {
    return _instance;
  }

  

  String baseEndpoint = "https://api.spaceflightnewsapi.net/v4/articles";
  final List<Article> _favorites = [];
  static const String _prefsKey = 'favorites';
  // bool _favoritesLoaded = false;

  List<Article> get favorites => List.unmodifiable(_favorites);

  // Cache mémoire des articles pour éviter de recharger à chaque navigation
  final List<Article> _articleCache = [];

  List<Article> get cachedArticles => List.unmodifiable(_articleCache);

  ArticleService._internal() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_prefsKey) ?? [];
      _favorites.clear();
      for (final s in list) {
        try {
          final map = json.decode(s) as Map<String, dynamic>;
          _favorites.add(Article.fromJson(map));
        } catch (_) {}
      }
    } catch (_) {}
        // _favoritesLoaded = true;
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _favorites.map((a) => json.encode(a.toJson())).toList();
      await prefs.setStringList(_prefsKey, list);
    } catch (_) {}
  }

  void toggleFavorite(Article article) {
    if (isFavorite(article)) {
      _favorites.removeWhere((a) => a.id == article.id);
    } else {
      _favorites.add(article);
    }
    _saveFavorites();
  }

  bool isFavorite(Article article) {
    return _favorites.any((a) => a.id == article.id);
  }

  void removeFavorite(Article article) {
    _favorites.removeWhere((a) => a.id == article.id);
    _saveFavorites();
  }

  Future<List<Article>> getArticles({int limit = 200, bool forceRefresh = false}) async {
    // Retourne le cache si disponible et si on ne force pas le rafraîchissement
    if (!forceRefresh && _articleCache.isNotEmpty && _articleCache.length >= limit) {
      return _articleCache.sublist(0, limit);
    }

    final List<Article> collected = [];
    final int pageSize = limit > 100 ? 100 : limit;
    String? nextUrl = '$baseEndpoint?page_size=$pageSize';

    while (nextUrl != null && collected.length < limit) {
      final response = await http.get(Uri.parse(nextUrl));
      if (response.statusCode != 200) {
        throw Exception('Erreur chargement articles');
      }
      final data = json.decode(response.body);
      List items = [];
      if (data is List) {
        items = data;
        nextUrl = null;
      } else if (data is Map) {
        if (data['results'] is List) {
          items = data['results'];
        }
        if (data['next'] != null && data['next'] is String && (data['next'] as String).isNotEmpty) {
          nextUrl = data['next'];
        } else {
          nextUrl = null;
        }
      } else {
        nextUrl = null;
      }

      collected.addAll(items.map((item) => Article.fromJson(item)));
      if (collected.length >= limit) break;
    }

    if (collected.length > limit) {
      final result = collected.sublist(0, limit);
      // Mettre à jour le cache
      _articleCache
        ..clear()
        ..addAll(result);
      return result;
    }
    // Mettre à jour le cache
    _articleCache
      ..clear()
      ..addAll(collected);
    return collected;
  }

  /// Vide le cache des articles (utile pour forcer un rechargement complet)
  void clearArticleCache() {
    _articleCache.clear();
  }
}
