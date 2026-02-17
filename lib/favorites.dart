import 'package:flutter/material.dart';
import 'package:the/details_page.dart';
import 'package:the/category.dart';
import 'package:the/main.dart';
import 'package:the/service.dart';
import 'package:the/models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int currentPageIndex = 1;

  List<Article> get favoriteArticles => ArticleService().favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'The Ledger')),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesPage()),
            );
          }
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Categories'),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Mes Favoris${favoriteArticles.isNotEmpty ? ' (${favoriteArticles.length})' : ''}'),
      centerTitle: true,
      actions: [
        if (favoriteArticles.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Tout supprimer',
            onPressed: _showClearAllDialog,
          ),
      ],
    );
  }

  Widget _buildBody() {
    if (favoriteArticles.isEmpty) return _buildEmptyState();
    return _buildFavoritesList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: Colors.pink.withAlpha((0.1 * 255).round()), shape: BoxShape.circle),
              child: const Icon(Icons.favorite_border, size: 60, color: Colors.pink),
            ),
            const SizedBox(height: 24),
            const Text('Aucun favori pour le moment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Les articles que vous aimerez apparaîtront ici.\nAppuyez sur le cœur pour les ajouter à vos favoris.', style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'The Ledger')));
              },
              icon: const Icon(Icons.explore),
              label: const Text('Découvrir des articles'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: favoriteArticles.length,
      itemBuilder: (context, index) {
        final article = favoriteArticles[index];
        return _buildFavoriteCard(article);
      },
    );
  }

  Widget _buildFavoriteCard(Article article) {
    return Dismissible(
      key: Key(article.id.toString()),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(article.title);
      },
      onDismissed: (direction) {
        _removeFavorite(article);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(article: article)));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: article.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(width: 80, height: 80, color: Colors.grey[200]),
                    errorWidget: (ctx, url, err) => Container(width: 80, height: 80, color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(article.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.blue.withAlpha((0.1 * 255).round()), borderRadius: BorderRadius.circular(12)),
                            child: Text(article.newsSite, style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(article.summary, style: TextStyle(fontSize: 13, color: Colors.grey[700]), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      ArticleService().toggleFavorite(article);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${article.title} ${ArticleService().isFavorite(article) ? 'ajouté aux favoris' : 'retiré des favoris'}')));
                  },
                  icon: Icon(ArticleService().isFavorite(article) ? Icons.favorite : Icons.favorite_border, color: Colors.pink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
      child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.delete, color: Colors.white), SizedBox(width: 8), Text('Supprimer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
    );
  }

  void _removeFavorite(Article article) {
    setState(() {
      ArticleService().removeFavorite(article);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${article.title} retiré des favoris'), duration: const Duration(seconds: 2)));
  }

  Future<bool?> _showDeleteConfirmationDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer des favoris ?'),
        content: Text('Voulez-vous retirer "$title" de vos favoris ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Retirer')),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider les favoris ?'),
        content: Text('Cette action supprimera tous vos articles favoris (${favoriteArticles.length} articles).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(onPressed: () {
            setState(() {
              final copy = List<Article>.from(favoriteArticles);
              for (final a in copy) {
                ArticleService().removeFavorite(a);
              }
            });
            Navigator.pop(context);
          }, style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Tout supprimer')),
        ],
      ),
    );
  }
}
