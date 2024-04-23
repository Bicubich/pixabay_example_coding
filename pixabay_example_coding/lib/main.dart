import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay_example_coding/cubit/gallery_screen_cubit.dart';
import 'package:pixabay_example_coding/data/models/repository.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_presenter.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_screen.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_view.dart';
import 'package:pixabay_example_coding/utils/pizabay_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GalleryRepository galleryRepository = GalleryRepository(PixabayApi());
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => GalleryCubit(galleryRepository),
        child: GalleryScreen(
          presenter: GalleryPresenter(
            GalleryScreenView(),
            galleryRepository,
          ),
        ),
      ),
    );
  }
}
