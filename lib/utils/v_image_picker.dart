import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum VImageSource { camera, gallery }

class VImagePicker {
  const VImagePicker({required ImagePicker imagePicker})
      : _imagePicker = imagePicker;

  Future<File?> pickImage([VImageSource source = VImageSource.gallery]) async {
    var result = await _imagePicker.pickImage(
      source: ImageSource.values[source.index],
    );

    if (result == null) {
      return null;
    }

    return File(result.path);
  }

  final ImagePicker _imagePicker;
}
