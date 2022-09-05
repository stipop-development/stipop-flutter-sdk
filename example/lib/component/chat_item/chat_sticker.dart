import 'package:flutter/material.dart';

Widget ChatSticker(String imagePath) {
  return Padding(
      padding: const EdgeInsets.all(16),
      child: Image.network(
        imagePath,
        width: 85,
        height: 85,
      ));
}