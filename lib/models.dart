class Article {
  final int id;
  final String title;
  final String summary;
  final String imageUrl;
  final String newsSite;
  final String url;

  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.newsSite,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      newsSite: json['news_site']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'image_url': imageUrl,
      'news_site': newsSite,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title)';
  }
}
