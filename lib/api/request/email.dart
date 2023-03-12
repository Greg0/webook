import 'filetype.dart';

class EmailRequest {
  final String bookId;
  final String email;
  final Filetype filetype;

  EmailRequest(this.bookId, this.email, this.filetype);
}