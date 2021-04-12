import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

import 'adoption_regis_detail.dart';

// ignore: must_be_immutable
class AdoptionRegistrationFormCard extends StatefulWidget {
  AdoptionRegisForm form;

  AdoptionRegistrationFormCard({this.form});

  @override
  _AdoptionRegistrationFormCard createState() =>
      _AdoptionRegistrationFormCard();
}

class _AdoptionRegistrationFormCard
    extends State<AdoptionRegistrationFormCard> {
  List<String> imgUrlList;
  String firstUrl;
  String status;

  String insertedAt;

  @override
  void initState() {
    super.initState();
    setState(() {
      imgUrlList = widget.form.pet.petImgUrl;
      firstUrl = imgUrlList.elementAt(0);

      status = getFormStatus(widget.form.adoptionRegistrationStatus);

      insertedAt = formatDateTime(widget.form.insertedAt);
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
    return result;
  }

  getFormStatus(int status) {
    String result = '';

    if (status == 1) {
      result = 'Đang chờ xử lý';
    } else if (status == 2) {
      result = 'Đang duyệt';
    } else if (status == 3) {
      result = 'Yêu cầu bị hủy';
    } else {
      result = 'Thành công';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AdoptFormDetails(
                form: widget.form,
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(firstUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // pet name & status
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.form.pet.petName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ngày đăng ký: $insertedAt',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: widget.form
                                                .adoptionRegistrationStatus !=
                                            3
                                        ? Colors.green
                                        : Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
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
