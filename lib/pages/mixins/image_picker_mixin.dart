import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

mixin ImagePickerMixin<T extends StatefulWidget> on State<T> {

  @protected
  String avatarUrl;

  @protected
  String retrieveImageDataError;

  @protected
  Future getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(source: imageSource);

      if (image?.path != null && image.path.isNotEmpty) {
        setState(() {
          avatarUrl = image.path;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @protected
  Future<void> retrieveLostImageData() async {
    final response = await ImagePicker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        setState(() {
          avatarUrl = response.file.path;
        });
      }
    } else {
      retrieveImageDataError = response.exception.code;
    }
  }

  @protected
  Text getRetrieveErrorWidget() {
    if (retrieveImageDataError != null) {
      final result = Text(retrieveImageDataError);
      retrieveImageDataError = null;
      return result;
    }
    return null;
  }
}
