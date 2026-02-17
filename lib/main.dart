import 'package:flutter/material.dart';
import 'package:the/splash_screen.dart';
import 'package:the/service.dart';
import 'package:the/details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the/models.dart';
import 'package:the/category.dart';
import 'package:the/favorites.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("The Ledger", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() => currentPageIndex = index);
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage()));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Categories'),
        ],
      ),
      // Utilisation de CustomScrollView pour la performance
      body: CustomScrollView(
        slivers: [
          // Section Titre et Bouton supprimée — espace réservé
          SliverToBoxAdapter(child: SizedBox(height: 8)),
          
          // Grille d'articles avec FutureBuilder
          FutureBuilder<List<Article>>(
            future: ArticleService().getArticles(limit: 200),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildPlaceholderCard(),
                      childCount: 6,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const SliverFillRemaining(child: Center(child: Text('Erreur de chargement')));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverFillRemaining(child: Center(child: Text('Aucun article trouvé.')));
              }

              final articles = snapshot.data!;

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72, // Ajusté pour éviter les débordements de texte
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildArticleCard(articles[index]),
                    childCount: articles.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // Placeholder card shown while articles are loading
  Widget _buildPlaceholderCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(0)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 12, width: double.infinity, color: Colors.grey[300]),
                  const SizedBox(height: 6),
                  Container(height: 10, width: double.infinity, color: Colors.grey[200]),
                  const SizedBox(height: 6),
                  Container(height: 10, width: 80, color: Colors.grey[200]),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey[500]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget de la carte d'article (Design préservé)
  Widget _buildArticleCard(Article article) {
    return StatefulBuilder(
      builder: (context, setStateCard) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPage(article: article))),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: article.imageUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (ctx, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.grey[500]),
                          ),
                          errorWidget: (ctx, url, err) => Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            icon: Icon(
                              ArticleService().isFavorite(article) ? Icons.favorite : Icons.favorite_border,
                              color: Colors.pink,
                            ),
                            onPressed: () {
                              ArticleService().toggleFavorite(article);
                              setStateCard(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          article.summary,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.2),
                        ),
                        const Spacer(),
                        const Text(
                          "Lire l'article >",
                          style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("Favoris"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage())),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text("Catégories"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())),
          ),
        ],
      ),
    );
  }
}