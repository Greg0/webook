class CreateRequest {
  final String title;
  final String description;
  final String author;
  final String genre;
  final String coverPath;
  final List<String> urls;

  CreateRequest(
      {required this.title,
      required this.urls,
      required this.author,
      this.description = '',
      this.genre = 'ebook',
      this.coverPath = ''});

  Map toJson() => {
    'title': title,
    'description': description,
    'author': author,
    'genre': genre,
    'coverPath': coverPath,
    'urls': urls
  };
}
