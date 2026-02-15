import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CategoriesPage(),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

 
  final List<Map<String, dynamic>> categories = const [
    {
      'id': 1,
      'name': 'Sci-Fi',
      'icon': Icons.rocket_launch,
      'color': Colors.purple,
      'articleCount': 15,
    },
    {
      'id': 2,
      'name': 'Cuisine',
      'icon': Icons.restaurant,
      'color': Colors.orange,
      'articleCount': 23,
    },
    {
      'id': 3,
      'name': 'Politique',
      'icon': Icons.gavel,
      'color': Colors.red,
      'articleCount': 42,
    },
    {
      'id': 4,
      'name': 'Histoire',
      'icon': Icons.history_edu,
      'color': Colors.brown,
      'articleCount': 31,
    },
    {
      'id': 5,
      'name': 'Philosophie',
      'icon': Icons.psychology,
      'color': Colors.teal,
      'articleCount': 18,
    },
    {
      'id': 6,
      'name': 'Technologie',
      'icon': Icons.computer,
      'color': Colors.blue,
      'articleCount': 57,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    tooltip: 'Retour',
    onPressed: () => Navigator.pop(context),
  ),
  title: const Text("Catégories"),
  actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.logout),
      tooltip: 'Quitter',
      onSelected: (String value) {
        if (value == 'logout') {
          _showLogoutDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text('Déconnexion'),
              ],
            ),
          ),
          
        ];
      },
    ),
 
  ],
),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryItem(category);
          },
        ),
      ),
    );
  }
  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: () {
          print('Catégorie sélectionnée: ${category['name']}');
          
          // sa se pou nou lye paj sa ak paj atik yo :
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ArticlesPage(categoryId: category['id']),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: (category['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            
           
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'],
                size: 70,
                color: category['color'],
              ),
              
              const SizedBox(height: 4),
              
         
              Text(
                category['name'],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 4), 
              
              Text(
                '${category['articleCount']} articles',
                style: TextStyle(
                  fontSize: 12, 
                  color: Colors.grey[600],
                ),
              ),
              

               Container(
                margin: const EdgeInsets.only(top: 6),
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                color: category['color'],
               borderRadius: BorderRadius.circular(2),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Déconnecter'),
            ),
          ],
        );
      },
    );
  }
}
