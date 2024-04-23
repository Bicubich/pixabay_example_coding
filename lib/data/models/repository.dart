import 'package:pixabay_example_coding/data/models/pixabay_image.dart';
import 'package:pixabay_example_coding/utils/pizabay_api.dart';

class GalleryRepository {
  final PixabayApi _api;

  GalleryRepository(this._api);

  Future<PixabayImage> fetchImages({String query = '', int page = 20}) async {
    try {
      final response = await _api.searchImages(query, page);
      return response;
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }
}
