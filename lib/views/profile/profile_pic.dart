import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      alignment: Alignment.center,
        child: SizedBox(
      height: 125,
      width: 125,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(app_logo),
          ),
          Positioned(
              right: -25,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: FlatButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.camera,
                    size: 22,
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
