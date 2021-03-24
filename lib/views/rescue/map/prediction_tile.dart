import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_rescue_mobile/models/map/place_predictions.dart';
import 'package:pet_rescue_mobile/models/map/address.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/data.dart';

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(message: 'Đang xử lý...'));

    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';

    var res = await Assistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);

    if (res == 'failed') {
      return;
    }

    if (res['status'] == 'OK') {
      Address address = Address();
      address.placeName = res['result']['name'];
      address.placeId = placeId;
      address.latitude = res['result']['geometry']['location']['lat'];
      address.longitude = res['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false).updateUserLocation(address);

      print('result: ' + address.placeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.add_location, size: 30, color: primaryGreen),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePredictions.mainText,
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        placePredictions.secondaryText,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
