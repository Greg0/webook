import 'dart:typed_data';

class DownloadResponse {
  final Uint8List bookContent;

  const DownloadResponse({required this.bookContent});
}
