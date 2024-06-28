class FileException implements Exception {
  final String message;

  FileException(this.message);

  @override
  String toString() {
    return message;
  }
}
