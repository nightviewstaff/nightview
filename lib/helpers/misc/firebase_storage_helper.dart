class FirebaseStorageHelper {
  static String fetchStorageUrl(String path) {
    final resolvedPath = path.replaceAll('/', '%2F');
    return 'https://firebasestorage.googleapis.com/v0/b/nightview-d5406.appspot.com/o/$resolvedPath?alt=media';
  }
}
