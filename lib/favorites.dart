import 'package:flutter/material.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FavoritesPage(),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> favoriteArticles = [
    {
      'id': '1',
      'title': 'Donald Trump à la conquête de la Maison Blanche',
      'category': 'Politique',
      'imageUrl': 'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
      'date': '15 Fév 2025',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    },
    {
      'id': '2',
      'title': 'Les mystères de l\'univers dévoilés',
      'category': 'Science',
      'imageUrl': 'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
      'date': '14 Fév 2025',
      'description': 'Sed do eiusmod tempor incididunt ut labore et dolore...',
    },
    {
      'id': '3',
      'title': 'Recette du jour : pasta carbonara',
      'category': 'Cuisine',
      'imageUrl': 'https://th.bing.com/th/id/OIF.WSXDhD5jCwPnvthV79KV4w?w=248&h=180&c=7&r=0&o=7&cb=defcache2&pid=1.7&rm=3&defcache=1',
      'date': '13 Fév 2025',
      'description': 'Ut enim ad minim veniam, quis nostrud exercitation...',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Mes Favoris${favoriteArticles.isNotEmpty ? ' (${favoriteArticles.length})' : ''}',
      ),
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
    if (favoriteArticles.isEmpty) {
      return _buildEmptyState();
    }
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
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Aucun favori pour le moment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Les articles que vous aimerez apparaîtront ici.\nAppuyez sur le cœur pour les ajouter à vos favoris.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.explore),
              label: const Text('Découvrir des articles'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
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
        return _buildFavoriteCard(article, index);
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> article, int index) {
    return Dismissible(
      key: Key(article['id']),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(article['title']);
      },
      onDismissed: (direction) {
        _removeFavorite(index, article['title']);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            print('Article sélectionné: ${article['title']}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    article['imageUrl'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              article['category'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article['date'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
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
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Supprimer',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _removeFavorite(int index, String title) {
    setState(() {
      favoriteArticles.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title retiré des favoris'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            print('Annuler la suppression');
          },
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(String title) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer des favoris ?'),
        content: Text('Voulez-vous retirer "$title" de vos favoris ?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider les favoris ?'),
        content: Text(
          'Cette action supprimera tous vos articles favoris (${favoriteArticles.length} articles).',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                favoriteArticles.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tous les favoris ont été supprimés'),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Tout supprimer'),
          ),
        ],
      ),
    );
  }
}
