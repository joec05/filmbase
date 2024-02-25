import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

Widget generateCachedImage(String? url){
  if(url == null){
    return itemNoImage;
  }

  return CachedNetworkImage(
    imageUrl: '$imageAccessUrl$url', 
    fit: BoxFit.cover,
    errorWidget: (context, error, stackTrace) => itemNoImage,
    fadeInDuration: const Duration(milliseconds: 250)
  );
}

Widget generateCachedImageCarousel(String? url){
  if(url == null){
    return Image.asset(
      'assets/images/unknown-item.png',
      height: getScreenHeight() * 0.25, 
      fit: BoxFit.fitWidth,
    );
  }

  return CachedNetworkImage(
    imageUrl: '$imageAccessUrl$url', 
    fit: BoxFit.fitWidth,
    height: getScreenHeight() * 0.25, 
    errorWidget: (context, error, stackTrace){
      return Image.asset(
        'assets/images/unknown-item.png',
        height: getScreenHeight() * 0.25, 
        fit: BoxFit.fitWidth,
      );
    },
    fadeInDuration: const Duration(milliseconds: 250)
  );
}