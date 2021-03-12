import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:pet_rescue_mobile/src/data.dart';

class Assistant {
  static Future<dynamic> getRequest(String url) async {
    final response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return 'Failed';
      }
    } catch (e) {
      return 'Failed. Exception';
    }
  }

  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = '';
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=' + mapKey;
    
    var response = await getRequest(url);

    if (response != 'Failed') {
      placeAddress = response['results'][0]['formatted_address'];
    }

    return placeAddress;
  }
}
