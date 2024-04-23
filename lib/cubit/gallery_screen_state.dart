import 'package:pixabay_example_coding/data/models/pixabay_image.dart';

abstract class GalleryState {}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final PixabayImage images;

  GalleryLoaded(this.images);
}

class GalleryError extends GalleryState {}
