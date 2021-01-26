import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/style.dart';

class ProgressCard extends StatefulWidget {
  @override
  _ProgressCard createState() => _ProgressCard();
}

class _ProgressCard extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.13,
      child: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: color3,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Report ID",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "reporting",
                          style: TextStyle(
                            fontSize: 12,
                            color: fadedBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Processing",
                          style: TextStyle(
                            fontSize: 12,
                            color: fadedBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: Colors.black, width: 1.2)),
          ),
        ],
      ),
    );
  }
}
