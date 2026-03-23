class BookInfo {
  final int id;
  final String title;
  final int pageCount;
  int currentPage;

  BookInfo({
    required this.id,
    required this.title,
    required this.pageCount,
  }) : currentPage = 1;
}

class LinkInfo {
  final String title;
  final String url;

  LinkInfo({required this.title, required this.url});
}
