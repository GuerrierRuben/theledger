import 'package:flutter/material.dart';
import 'package:the/details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the/main.dart';
import 'package:the/favorites.dart';
import 'package:the/service.dart';

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecteur Actu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const CategoriesPage(),
    );
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int currentPageIndex = 2;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catégories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: FutureBuilder(
          future: ArticleService().getArticles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement des catégories'));
            } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return Center(child: Text('Aucune catégorie trouvée.'));
            }
            final articles = snapshot.data as List;
            final newsSites = articles.map((a) => a.newsSite).toSet().toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: newsSites.length,
              itemBuilder: (context, index) {
                final site = newsSites[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticlesPage(
                          nomCategorie: site,
                          articles: articles.where((a) => a.newsSite == site).toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category, size: 45, color: Colors.blue),
                        const SizedBox(height: 8),
                        Text(site, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('${articles.where((a) => a.newsSite == site).length} articles'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'The Ledger'))
            );
          } else if (index == 1) {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const FavoritesPage())
            );
          }
        },
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined), 
            selectedIcon: Icon(Icons.home),
            label: 'Home'
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border), 
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites'
          ),
          NavigationDestination(
            icon: Icon(Icons.menu), 
            label: 'Categories'
          ),
        ],
      ),
    );
  }
}

class ArticlesPage extends StatelessWidget {
  final String nomCategorie;
  final List articles;

  ArticlesPage({
    super.key,
    required this.nomCategorie,
    required this.articles,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomCategorie),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: articles.length,
          itemBuilder: (context, i) {
            final article = articles[i];
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(article: article)));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (ctx, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.blueGrey),
                        ),
                        errorWidget: (ctx, url, err) => Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(article.summary, style: TextStyle(fontSize: 11, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
