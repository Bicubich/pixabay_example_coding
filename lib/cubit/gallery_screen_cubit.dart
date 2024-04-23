import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay_example_coding/cubit/gallery_screen_state.dart';
import 'package:pixabay_example_coding/data/models/pixabay_image.dart';
import 'package:pixabay_example_coding/data/models/repository.dart';

class GalleryCubit extends Cubit<GalleryState> {
  final GalleryRepository repository;

  GalleryCubit(this.repository) : super(GalleryInitial());

  int _downloadImages = 0;
  PixabayImage? pixabayImages;

  Future loadImages({String query = '', bool isNewSearchPrompt = false}) async {
    try {
      if (isNewSearchPrompt) {
        _downloadImages = 0;
      }
      emit(GalleryLoading());
      _downloadImages += 20;
      pixabayImages =
          await repository.fetchImages(query: query, page: _downloadImages);
      emit(GalleryLoaded(pixabayImages!));
    } catch (_) {
      emit(GalleryError());
    }
  }
}
