import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/models/map/address.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';

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
      return 'Failed ${e.toString()}';
    }
  }

  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = '';
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    print('Address coordinate url: ' + url);

    var response = await getRequest(url);

    if (response != 'Failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickUpAddress = new Address();
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updateCurrentLocation(pickUpAddress);
    }

    return placeAddress;
  }
}
