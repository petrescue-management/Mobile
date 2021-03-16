import 'package:flutter/cupertino.dart';
import 'package:pet_rescue_mobile/models/map/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation;

  void updatePickUpLocation(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}