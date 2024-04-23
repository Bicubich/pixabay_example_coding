import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay_example_coding/cubit/gallery_screen_cubit.dart';
import 'package:pixabay_example_coding/cubit/gallery_screen_state.dart';
import 'package:pixabay_example_coding/data/models/pixabay_image.dart';
import 'package:pixabay_example_coding/screens/gallery/full_image_screen%20.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_presenter.dart';
import 'package:pixabay_example_coding/screens/gallery/gallery_view.dart';

class GalleryScreen extends StatefulWidget {
  final GalleryPresenter presenter;

  GalleryScreen({required this.presenter});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> implements GalleryView {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchImages);
    widget.presenter.attachView(this);
    context.read<GalleryCubit>().loadImages(query: _searchController.text);
    _scrollController
        .addListener(_scrollListener); // 1.1. Добавляем обработчик прокрутки
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchImages);
    _searchController.dispose();
    widget.presenter.detachView();
    _scrollController
        .removeListener(_scrollListener); // 1.2. Убираем обработчик прокрутки
    _scrollController.dispose();
    super.dispose();
  }

  // Метод обработки событий прокрутки
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Достигнут конец списка
      _loadMoreImages();
    }
  }

  // Метод для загрузки дополнительных изображений
  void _loadMoreImages() async {
    if (context.read<GalleryCubit>().state is! GalleryLoading) {
      await context
          .read<GalleryCubit>()
          .loadImages(query: _searchController.text);
    }
  }

  Future _searchImages() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      await context
          .read<GalleryCubit>()
          .loadImages(query: _searchController.text, isNewSearchPrompt: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GalleryCubit, GalleryState>(
      builder: (context, state) {
        if (state is GalleryError) {
          return const Center(child: Text('Error loading images'));
        } else {
          return _buildGridView(context);
        }
      },
    );
  }

  Scaffold _buildGridView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search images...',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 250,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              controller: _scrollController,
              itemCount:
                  context.read<GalleryCubit>().pixabayImages?.hits?.length ?? 0,
              itemBuilder: (context, index) {
                final image =
                    context.read<GalleryCubit>().pixabayImages!.hits![index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    double width = constraints.maxWidth;
                    double height = constraints.maxHeight;
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            // Navigate to the SecondScreen
                            return FullImageScreen(
                              imageUrl: image.largeImageUrl!,
                            );
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              // Apply slide transition
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      ),
                      child: Hero(
                        tag: 'gallery screen',
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CachedNetworkImage(
                              imageUrl: image.previewUrl!,
                              height: height,
                              width: width,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Likes: ${image.likes}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Views: ${image.views}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (context.read<GalleryCubit>().state is GalleryLoading)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }

  @override
  void showImages(PixabayImage images) {}
}
