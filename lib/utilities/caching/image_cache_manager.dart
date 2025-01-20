import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext)? placeholder;
  final Widget Function(BuildContext, Object)? errorWidget;

  const CachedImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  Future<String> _getCachedImage(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCachedImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder != null
              ? placeholder!(context)
              : Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return errorWidget != null
              ? errorWidget!(context, snapshot.error ?? "Error")
              : Icon(Icons.error);
        }

        return Image.file(
          File(snapshot.data!),
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }

// TODO at some point. Show images while they are not loaded. Look into caching generally. A lot of things can be cached.
//  void preloadStaticImages() async {
//   await preloadImages(['https://example.com/logo1.png', 'https://example.com/logo2.png']);
// }
// Widget getDynamicImage(String url) {
//   return CachedImageWidget(imageUrl: url);
// }
}
