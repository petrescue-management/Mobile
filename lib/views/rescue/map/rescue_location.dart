import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/src/style.dart';

class RescueLocation extends StatefulWidget {
  @override
  _RescueLocationState createState() => _RescueLocationState();
}

class _RescueLocationState extends State<RescueLocation> {
  GoogleMapController newGoogleMapController;

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position currentPosition;
  var geoLocator = Geolocator();
  bool _isLoading;

  locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(
      target: latLngPosition,
      zoom: 20,
    );

    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    String address = await Assistant.searchCoordinateAddress(position);
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: color2,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading ? loadMap(context) : getLocation(context),
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
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            locatePosition();
          },
        ),
      ],
    );
  }
}
