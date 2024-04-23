import 'package:pixabay_example_coding/data/models/repository.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_view.dart';

class GalleryPresenter {
  GalleryView? _view; // Ссылка на экран
  final GalleryRepository _repository;

  GalleryPresenter(this._view, this._repository);

  // Метод для прикрепления экрана к презентеру
  void attachView(GalleryView view) {
    _view = view;
  }

  // Метод для открепления экрана от презентера
  void detachView() {
    _view = null;
  }

  Future loadImages({String? query, int? page}) async {
    try {
      final images =
          await _repository.fetchImages(query: query ?? '', page: page ?? 20);
      _view!.showImages(images);
    } catch (e) {
      print('Error loading images: $e');
    }
  }
}
