import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the/models.dart';
import 'package:the/service.dart';

class DetailsPage extends StatefulWidget {
  final Article article;

  const DetailsPage({super.key, required this.article});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = ArticleService().isFavorite(widget.article);
  }

  void _toggle() {
    setState(() {
      ArticleService().toggleFavorite(widget.article);
      _isFav = ArticleService().isFavorite(widget.article);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isFav ? 'Ajouté aux favoris' : 'Retiré des favoris')));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.article.title;
    final imageUrl = widget.article.imageUrl;
    final content = widget.article.summary;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 250,
                placeholder: (ctx, url) => Container(height: 250, color: Colors.grey[200]),
                errorWidget: (ctx, url, err) => Container(height: 250, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 100)),
              ),
            ),
            const SizedBox(height: 20),

            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(content, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
