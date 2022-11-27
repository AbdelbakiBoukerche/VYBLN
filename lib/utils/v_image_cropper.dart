import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

class VAspectRatio {
  const VAspectRatio({required this.xRatio, required this.yRatio});

  factory VAspectRatio.oneToOne() {
    return const VAspectRatio(xRatio: 1, yRatio: 1);
  }

  factory VAspectRatio.landscape() {
    return const VAspectRatio(xRatio: 1.91, yRatio: 1);
  }
  factory VAspectRatio.vertical() {
    return const VAspectRatio(xRatio: 4, yRatio: 5);
  }

  final double xRatio;
  final double yRatio;
}

class VImageCropper {
  const VImageCropper({required ImageCropper imageCropper})
      : _imageCropper = imageCropper;

  Future<File?> cropImage(
    String path, {
    int? maxWidth,
    int? maxHeight,
    VAspectRatio? aspectRatio,
  }) async {
    final result = await _imageCropper.cropImage(
      sourcePath: path,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      aspectRatio: aspectRatio != null
          ? CropAspectRatio(
              ratioX: aspectRatio.xRatio,
              ratioY: aspectRatio.yRatio,
            )
          : null,
      uiSettings: [
        AndroidUiSettings(
          activeControlsWidgetColor: const Color(0xFF27A9FF),
        ),
      ],
    );

    if (result == null) {
      return null;
    }
    return File(result.path);
  }

  final ImageCropper _imageCropper;
}
