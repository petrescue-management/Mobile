import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/models/center/center_model.dart';
import 'package:pet_rescue_mobile/views/personal/volunteer/volunteer_registration_form.dart';
import 'package:pet_rescue_mobile/src/style.dart';

// ignore: must_be_immutable
class CenterItem extends StatelessWidget {
  CenterModel center;

  CenterItem({this.center});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: GestureDetector(
        onTap: () {
          showCenterDetail(context);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color2,
              width: 2,
            ),
            color: Colors.white,
          ),
          margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
          child: AspectRatio(
            aspectRatio: 3 / 1,
            child: Container(
              child: Row(
                children: [
                  // image
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          center.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            center.centerName.trim(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            center.address,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showCenterDetail(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 530,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          center.imageUrl,
                          width: 250,
                          height: 250,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        center.centerName.trim(),
                        style: TextStyle(
                            fontSize: 20,
                            color: darkBlue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        center.address.trim(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey[800],
                              fontFamily: 'Philosopher'),
                          children: [
                            TextSpan(
                                text: 'Thông tin liên lạc\n',
                                style: TextStyle(
                                    decoration: TextDecoration.underline)),
                            TextSpan(
                              text: 'Số điện thoại: ${center.phone} \n',
                            ),
                            TextSpan(
                              text: 'Email: ${center.email} \n',
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VolunteerForm(
                                center: center,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryGreen,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'ĐĂNG KÝ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
