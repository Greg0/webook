import 'package:hive/hive.dart';

part 'ebook.g.dart';

@HiveType(typeId: 2)
class Book {
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  String author;
  @HiveField(3)
  String genre;
  @HiveField(4)
  String? coverPath;
  @HiveField(5)
  String url;

  Book(
      this.title,
      this.description,
      this.author,
      this.genre,
      this.coverPath,
      this.url
  );
}
