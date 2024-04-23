import 'package:http/http.dart' as http;
import 'package:pixabay_example_coding/data/models/pixabay_image.dart';
import 'dart:convert';

class PixabayApi {
  final String _apiKey = '43531993-e60db399ce26ad4f1e5762999';

  Future<PixabayImage> searchImages(String query, int page) async {
    final response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$_apiKey&q=$query&per_page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PixabayImage.fromJson(data);
    } else {
      throw Exception('Failed to load images');
    }
  }
}
