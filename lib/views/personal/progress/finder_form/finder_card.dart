import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';

import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/src/style.dart';

import 'finder_detail.dart';

// ignore: must_be_immutable
class FinderCard extends StatefulWidget {
  FinderForm finder;

  FinderCard({this.finder});

  @override
  _FinderCard createState() => _FinderCard();
}

class _FinderCard extends State<FinderCard> {
  List<String> imgUrlList;
  String firstUrl;
  String status;

  String finderDate;

  double latitude, longitude;
  Position finderPosition;
  String finderAddress = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      status = getFinderFormStatus(widget.finder.finderFormStatus);

      finderDate = formatDateTime(widget.finder.finderDate);

      latitude = widget.finder.lat;
      longitude = widget.finder.lng;
    });

    locateUserAddressPosition();
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
    return result;
  }

  getFinderFormStatus(int status) {
    String result = '';

    if (status == 1) {
      result = 'Đang chờ xử lý';
    } else if (status == 2) {
      result = 'Đang cứu hộ';
    } else if (status == 3) {
      result = 'Đã đến nơi';
    } else if (status == 4) {
      result = 'Cứu hộ thành công';
    } else {
      result = 'Bị hủy';
    }

    return result;
  }

  locateUserAddressPosition() async {
    String address = '';

    finderPosition = Position(latitude: latitude, longitude: longitude);

    address = await Assistant.searchCoordinateAddress(finderPosition, context);

    setState(() {
      finderAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return FinderCardDetail(
                finder: widget.finder,
                address: finderAddress,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.14,
        child: Stack(
          children: [
            Container(
              child: Row(
                children: [
                  // image
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          image: DecorationImage(
                            image: AssetImage(app_logo_notitle),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomLeft: Radius.circular(18),
                          ),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.finder.finderImageUrl.elementAt(0)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // location & status
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            finderAddress,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày gửi yêu cầu: $finderDate',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: widget.finder.finderFormStatus != 5
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: mainColor,
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
