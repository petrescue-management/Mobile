import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/src/api_url.dart';

class PetProvider {
  Future<PetListBaseModel> getPetListByType() async {
    final response = await http.get(
      ApiUrl.getPetListByType,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      return PetListBaseModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post');
    }
    return null;
  }

  // trước là tên thư mục, sau là tên file
  Future<String> uploadRescueImage(File image, String uid) async {
    String result;
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference storageReference = storage.ref().child('petRescueImg/$uid');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    result = url;
    print(result + ' result');
    return result;
  }
}
