import 'dart:io';

class ImageUploadModel {
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.imageFile,
    this.imageUrl,
  });

  File get getImageFile => imageFile;

  String get getImageUrl => imageUrl;
}
