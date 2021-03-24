import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/resource/location/app_data.dart';
import 'package:pet_rescue_mobile/views/rescue/rescue.dart';
import 'package:pet_rescue_mobile/views/rescue/map/search_address.dart';

// ignore: must_be_immutable
class RescueLocation extends StatefulWidget {
  double latitude, longitude;

  RescueLocation({Key key, this.latitude, this.longitude}) : super(key: key);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  _RescueLocationState createState() => _RescueLocationState();
}

class _RescueLocationState extends State<RescueLocation> {
  GoogleMapController newGoogleMapController;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Position currentPosition;

  String address;

  var geoLocator = Geolocator();

  double bottomPaddingMap = 0;

  bool _isLoading;

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    print('position: $position');

    if (widget.latitude == null || widget.longitude == null) {
      currentPosition = position;
      print('0 nè $currentPosition');
    } else {
      currentPosition =
          Position(latitude: widget.latitude, longitude: widget.longitude);
      print('có nè $currentPosition');
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
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      this._isLoading = true;
    });
    Future.microtask(() async {
      await Permission.location.status;
      await Permission.location.request();
      await Permission.location.status.isGranted.then((value) {
        setState(() {
          this._isLoading = false;
        });
      });
    });
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
        body: _isLoading ? loadMap(context) : getLocation(context),
      ),
    );
  }

  Widget loadMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget getLocation(BuildContext context) {
    var contextWidth = MediaQuery.of(context).size.width;
    var contextHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // map
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: RescueLocation._kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            setState(() {
              bottomPaddingMap = contextHeight * 0.18;
            });

            locatePosition();
          },
        ),
        // search panel
        Positioned(
          bottom: 0.0,
          child: Container(
            width: contextWidth,
            height: contextHeight * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Xin chào, ',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 3.0),
                        Text('Địa chỉ của bạn là:',
                            style: TextStyle(fontSize: 18.0)),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // search address
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchAddress();
                              },
                            ),
                          );
                        },
                        child: Container(
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
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Flexible(
                                  child: Text(
                                    Provider.of<AppData>(context)
                                                .currentLocation !=
                                            null
                                        ? Provider.of<AppData>(context)
                                            .currentLocation
                                            .placeName
                                        : '',
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return Rescue(
                                    latitude: currentPosition.latitude,
                                    longitude: currentPosition.longitude,
                                    address: address,
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
