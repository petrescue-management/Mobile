class ConfigModel {
  int imageForFinder;

  ConfigModel({this.imageForFinder});

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      imageForFinder: json['imageForFinder'],
    );
  }
}
