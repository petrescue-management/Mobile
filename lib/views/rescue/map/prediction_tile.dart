import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/models/map/place_predictions.dart';

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  PredictionTile({Key key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Row(
            children: [
              Icon(Icons.add_location),
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
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
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
    );
  }
}
