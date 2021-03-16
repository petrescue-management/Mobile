import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:provider/provider.dart';
import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/models/map/place_predictions.dart';
import 'package:pet_rescue_mobile/views/rescue/map/prediction_tile.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';

class SearchAddress extends StatefulWidget {
  @override
  _SearchAddressState createState() => _SearchAddressState();
}

class _SearchAddressState extends State<SearchAddress> {
  TextEditingController pickUpTextController = TextEditingController();
  TextEditingController tmpTextController = TextEditingController();

  List<PlacePredictions> placePredictionList = [];

  findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:vn';

      var response = await Assistant.getRequest(autoCompleteUrl);

      if (response == 'Failed') {
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
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? '';
    pickUpTextController.text = placeAddress;

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
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  top: 20.0,
                  right: 10.0,
                  bottom: 20.0,
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
                            'Chọn địa điểm',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                    // search component
                    Row(
                      children: [
                        Icon(
                          Icons.room,
                          size: 28.0,
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
                                  blurRadius: 5.0,
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
                                controller: tmpTextController,
                                decoration: InputDecoration(
                                  hintText: 'Địa chỉ của bạn...',
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
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
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
                            onPressed: () {},
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
                        return PredictionTile(
                          placePredictions: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (context, int index) => CustomDivider(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
