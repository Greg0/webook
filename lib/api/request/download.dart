import 'filetype.dart';

class DownloadRequest {
  final String bookId;
  final Filetype filetype;

  DownloadRequest(this.bookId, this.filetype);
}