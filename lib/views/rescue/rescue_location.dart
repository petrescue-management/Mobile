import 'dart:async';
import 'package:provider/provider.dart';
import 'package:commons/commons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/models/map/address.dart';
import 'package:pet_rescue_mobile/models/map/place_predictions.dart';

import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/data.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue.dart';
import 'package:pet_rescue_mobile/main.dart';

// ignore: must_be_immutable
class RescueLocation extends StatefulWidget {
  double latitude = 0, longitude = 0;
  String placeName;

  RescueLocation({Key key, this.latitude, this.longitude, this.placeName})
      : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _RescueLocationState createState() => _RescueLocationState();
}

class _RescueLocationState extends State<RescueLocation> {
  TextEditingController addressTextController = TextEditingController();

  GoogleMapController newGoogleMapController;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Set<Marker> _markers = {};

  Position currentPosition;

  String address;

  var geoLocator = Geolocator();

  double bottomPaddingMap = 0, topPaddingMap = 0;

  bool _isLoading;

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print('position: $position');

    if (widget.latitude == 0 && widget.longitude == 0) {
      currentPosition = position;
      print('current position: $currentPosition');
    } else {
      currentPosition =
          Position(latitude: widget.latitude, longitude: widget.longitude);
      print('find position $currentPosition');
    }

    LatLng latLngPosition =
        LatLng(currentPosition.latitude, currentPosition.longitude);

    CameraPosition cameraPosition = new CameraPosition(
      target: latLngPosition,
      zoom: 20,
    );

    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    address = await Assistant.searchCoordinateAddress(currentPosition, context);
    print('This is your Address: ' + address);

    if (widget.latitude != null &&
        widget.longitude != null &&
        widget.latitude != 0 &&
        widget.longitude != 0) {
      Marker locateMarker = Marker(
        markerId: MarkerId('locate'),
        position: LatLng(widget.latitude, widget.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: widget.placeName,
          snippet: address,
        ),
      );

      setState(() {
        _markers.add(locateMarker);
      });
    }
  }

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
  void initState() {
    super.initState();
    setState(() {
      this._isLoading = true;
      widget.latitude = 0;
      widget.longitude = 0;
      widget.placeName = '';
    });

    Future.microtask(() async {
      await Permission.location.status;
      await Permission.location.request();
      await Permission.location.status.isGranted.then((value) {
        setState(() {
          this._isLoading = false;
        });
      });

      locatePosition();
    });
  }

  Future<bool> _confirmPop() {
    return confirmationDialog(context, "Bạn muốn hủy yêu cầu cứu hộ ?",
        positiveText: "Có",
        neutralText: "Không",
        confirm: false,
        title: "", positiveAction: () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _confirmPop,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: _isLoading ? loading(context) : getLocation(context),
        ),
      ),
    );
  }

  Widget getLocation(BuildContext context) {
    var contextWidth = MediaQuery.of(context).size.width;
    var contextHeight = MediaQuery.of(context).size.height;

    String fullAddress =
        (Provider.of<AppData>(context).currentLocation != null &&
                widget.placeName == '')
            ? Provider.of<AppData>(context).currentLocation.placeName
            : (widget.placeName == null ? '' : widget.placeName);

    return Stack(
      children: [
        // map
        GoogleMap(
          padding:
              EdgeInsets.only(bottom: bottomPaddingMap, top: topPaddingMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: RescueLocation._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            setState(() {
              bottomPaddingMap = contextHeight * 0.15;
              topPaddingMap = contextHeight * 0.65;
            });

            locatePosition();
          },
        ),
        // tile for predictions
        (placePredictionList.length > 0)
            ? Padding(
                padding: EdgeInsets.only(top: 60.0, left: 10.0, right: 10.0),
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
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
                ),
              )
            : SizedBox(height: 0),
        // search address
        Positioned(
          top: 60.0,
          child: Container(
            width: contextWidth,
            height: contextHeight * 0.06,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.5, 0.5),
                  )
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: TextField(
                  onChanged: (value) {
                    findPlace(value);
                  },
                  controller: addressTextController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    border: InputBorder.none,
                    isDense: true,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
        ),
        // result panel
        Positioned(
          bottom: 0.0,
          child: Container(
            width: contextWidth,
            height: contextHeight * 0.15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10.0,
                  spreadRadius: 0.3,
                  offset: Offset(0.5, 0.5),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('  Địa chỉ của bạn là:',
                      style: TextStyle(fontSize: 18.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // search address
                      Container(
                        width: contextWidth * 0.7,
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
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.room,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Flexible(
                                child: Text(
                                  fullAddress,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      // confirm address button
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
                          onPressed: () {
                            String resultAddress = '';
                            if (address.contains(widget.placeName)) {
                              resultAddress = address;
                            } else {
                              resultAddress = widget.placeName + ', ' + address;
                            }
                            print(resultAddress);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return Rescue(
                                    latitude: currentPosition.latitude,
                                    longitude: currentPosition.longitude,
                                    address: resultAddress,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // back to home page
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 35,
                  ),
                  onPressed: () {
                    confirmationDialog(context, "Bạn muốn hủy yêu cầu cứu hộ ?",
                        positiveText: "Có",
                        neutralText: "Không",
                        confirm: false,
                        title: "", positiveAction: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(message: 'Đang cập nhật vị trí...'));

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

      widget.latitude = address.latitude;
      widget.longitude = address.longitude;
      widget.placeName = address.placeName;

      locatePosition();

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

        addressTextController.text = '';

        placePredictionList.length = 0;
      },
      child: Container(
        color: Colors.white,
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
