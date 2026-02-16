import 'package:flutter/material.dart';
import 'package:the/details_page.dart'; 
import 'package:the/main.dart';      
import 'package:the/favorites.dart'; 

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

  final List<Map<String, dynamic>> categories = const [
    {'id': 1, 'name': 'Sci-Fi', 'icon': Icons.rocket_launch, 'color': Colors.purple, 'articleCount': 3},
    {'id': 2, 'name': 'Cuisine', 'icon': Icons.restaurant, 'color': Colors.orange, 'articleCount': 3},
    {'id': 3, 'name': 'Politique', 'icon': Icons.gavel, 'color': Colors.red, 'articleCount': 3},
    {'id': 4, 'name': 'Histoire', 'icon': Icons.history_edu, 'color': Colors.brown, 'articleCount': 3},
    {'id': 5, 'name': 'Philosophie', 'icon': Icons.psychology, 'color': Colors.teal, 'articleCount': 3},
    {'id': 6, 'name': 'Technologie', 'icon': Icons.computer, 'color': Colors.blue, 'articleCount': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Catégories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticlesPage(
                      nomCategorie: cat['name'],
                      couleurCategorie: cat['color'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (cat['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat['icon'], size: 45, color: cat['color']),
                    const SizedBox(height: 8),
                    Text(cat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${cat['articleCount']} articles'),
                  ],
                ),
              ),
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
          } else if (index == 2) {
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
  final Color couleurCategorie;

  ArticlesPage({
    super.key,
    required this.nomCategorie,
    required this.couleurCategorie,
  });

  final List<Map<String, String>> articles = [
    {
      'titre': 'Les dernières découvertes',
      'desc': 'Des scientifiques ont fait une grande avancée dans le domaine de la recherche fondamentale...',
      'image': 'https://picsum.photos/200/300?random=101',
    },
    {
      'titre': 'Interview exclusive',
      'desc': 'Rencontre avec un expert du domaine qui nous explique les enjeux de demain...',
      'image': 'https://picsum.photos/200/300?random=102',
    },
    {
      'titre': 'Guide pratique',
      'desc': 'Tout ce qu\'il faut savoir pour débuter sereinement et éviter les erreurs classiques...',
      'image': 'https://picsum.photos/200/300?random=103',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomCategorie),
        backgroundColor: couleurCategorie.withOpacity(0.2),
        foregroundColor: couleurCategorie,
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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(
                      title: articles[i]['titre']!,
                      imageUrl: articles[i]['image']!,
                      content: articles[i]['desc']!,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.network(
                        articles[i]['image']!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stack) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articles[i]['titre']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              articles[i]['desc']!,
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}