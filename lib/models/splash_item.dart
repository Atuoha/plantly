class SplashItem {
  final int id;
  final String title;
  final String imgUrl;
  final bool showImage;

  SplashItem({
    required this.id,
    required this.title,
    this.imgUrl = '',
    this.showImage = true,
  });
}
