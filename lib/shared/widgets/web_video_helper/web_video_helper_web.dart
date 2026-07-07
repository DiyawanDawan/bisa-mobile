import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

Widget buildWebVideoPlayer(String videoUrl, double height) {
  final viewId = 'video-${videoUrl.hashCode}';
  
  // Register view factory
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
    final videoElement = html.VideoElement()
      ..src = videoUrl
      ..autoplay = true
      ..muted = true
      ..controls = true
      ..loop = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.backgroundColor = 'black'
      ..style.objectFit = 'contain';
    return videoElement;
  });

  return SizedBox(
    height: height,
    width: double.infinity,
    child: HtmlElementView(viewType: viewId),
  );
}
