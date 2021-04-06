import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/views/rescue/map/rescue_location.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';

import 'package:pet_rescue_mobile/models/map/address.dart';
import 'package:pet_rescue_mobile/models/map/place_predictions.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  TextEditingController addressTextController = TextEditingController();

  List<PlacePredictions> placePredictionList = [];

  findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:vn';

      var response = await Assistant.getRequest(autoCompleteUrl);

      if (response == 'failed') {
        return;
      }

      if (response['status'] == 'OK') {
        var predictions = response['predictions'];

        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // search panel
            Container(
              padding: EdgeInsets.only(bottom: 10),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.5, 0.5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 20.0,
                  right: 20.0,
                  bottom: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // title
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.chevron_left,
                            size: 28.0,
                          ),
                        ),
                        Center(
                          child: Text(
                            'CHỌN ĐỊA ĐIỂM',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // search component
                    Row(
                      children: [
                        Icon(
                          Icons.room,
                          size: 30.0,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 8.0),
                        // search text field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 3.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.5, 0.5),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: TextField(
                                onChanged: (value) {
                                  findPlace(value);
                                },
                                controller: addressTextController,
                                decoration: InputDecoration(
                                  hintText: 'Địa chỉ của bạn',
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    left: 3.0,
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        // confirm address
                        Container(
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 3.0,
                                spreadRadius: 0.3,
                                offset: Offset(0.5, 0.5),
                              )
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.done,
                              size: 30.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new RescueLocation(
                                          latitude: latitude,
                                          longitude: longitude,
                                          placeName: placeName)));

                              print(
                                  'lat: $latitude : long: $longitude - place: $placeName');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // tile for predictions
            (placePredictionList.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return predictionTile(placePredictionList[index]);
                      },
                      separatorBuilder: (context, int index) => CustomDivider(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(map_logo),
                            height: 120,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Không có kết quả tìm kiếm',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  double latitude, longitude;
  String placeName;

  getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(message: 'Đang xử lý...'));

    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';

    var res = await Assistant.getRequest(placeDetailsUrl);

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

      latitude = address.latitude;
      longitude = address.longitude;
      placeName = address.placeName;

      Navigator.pop(context);
    }
  }

  Widget predictionTile(PlacePredictions placePrediction) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        getPlaceAddressDetails(placePrediction.placeId, context);

        addressTextController.text = placePrediction.mainText;
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
                        placePrediction.mainText,
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        placePrediction.secondaryText,
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
