class Article {
  int id;
  String title;
  String summary;
  String imageUrl;
  String newsSite;
  String url;

  Article (
    this.id,
    this.title,
    this.summary,
    this.imageUrl,
    this.newsSite,
    this.url
  );

  Article.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        summary = json['summary'],
        imageUrl = json['image_url'],
        newsSite = json['news_site'],
        url = json['url'];
}