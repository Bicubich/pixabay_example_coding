import 'package:pixabay_example_coding/data/models/pixabay_image.dart';

abstract class GalleryView {
  void showImages(PixabayImage images);
}

class GalleryScreenView implements GalleryView {
  @override
  void showImages(PixabayImage images) {}
}
