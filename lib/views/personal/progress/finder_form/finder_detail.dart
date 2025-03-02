import 'package:commons/commons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:pet_rescue_mobile/resource/location/assistant.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_button.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';
import 'package:pet_rescue_mobile/views/custom_widget/video/custom_video_player.dart';
import '../../../../main.dart';
import '../progress_report.dart';

// ignore: must_be_immutable
class FinderCardDetail extends StatefulWidget {
  FinderForm finder;
  String address;

  FinderCardDetail({
    this.finder,
    this.address,
  });

  @override
  _FinderCardDetailState createState() => _FinderCardDetailState();
}

class _FinderCardDetailState extends State<FinderCardDetail> {
  ScrollController scrollController = ScrollController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _repo = Repository();

  String petAttribute;

  Position finderPosition;

  getPetAttribute(int petAttribute) {
    if (petAttribute == 1)
      return 'Đi lạc';
    else if (petAttribute == 2)
      return 'Bị bỏ rơi';
    else if (petAttribute == 3)
      return 'Bị thương';
    else
      return 'Cho đi';
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      petAttribute = getPetAttribute(widget.finder.petAttribute);
    });

    locateUserAddressPosition();
  }

  locateUserAddressPosition() async {
    String address = '';

    finderPosition =
        Position(latitude: widget.finder.lat, longitude: widget.finder.lng);

    address = await Assistant.searchCoordinateAddress(finderPosition, context);

    print('This is user Address: ' + address);

    setState(() {
      widget.address = address;
    });
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

  @override
  Widget build(BuildContext context) {
    var contextHeight = MediaQuery.of(context).size.height;
    var contextWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'CHI TIẾT CỨU HỘ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgp8),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Container(
            height: contextHeight,
            width: contextWidth,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontFamily: 'SamsungSans'),
                        children: [
                          TextSpan(
                            text: 'Địa chỉ của bạn:\n',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 16,
                              height: 2,
                            ),
                          ),
                          TextSpan(
                              text: (widget.address != null ||
                                      widget.address != '')
                                  ? '${widget.address}'
                                  : '',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 30,
                    left: 30,
                  ),
                  child: CustomDivider(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _rescueForm(context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 60,
                        ),
                        child: _btnSubmitFinderForm(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _btnSubmitFinderForm(context) {
    if (widget.finder.finderFormStatus == 1) {
      return CustomCancelButton(
        label: 'HỦY YÊU CẦU',
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 6,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "LÍ DO HỦY YÊU CẦU",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: CustomDivider(),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            child: TextFormField(
                              controller: reasonController,
                              maxLines: 5,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  counterText: '',
                                  hintText:
                                      'Hãy nhập lí do bạn hủy yêu cầu...'),
                              maxLength: 1000,
                            )),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.white,
                              child: Text(
                                "HỦY YÊU CẦU",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                if (reasonController.text == null ||
                                    reasonController.text == '') {
                                  warningDialog(
                                    context,
                                    'Xin hãy nhập lí do hủy yêu cầu.',
                                    title: '',
                                    neutralText: 'Đóng',
                                    neutralAction: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  confirmationDialog(
                                      context, 'Hủy yêu cầu cứu hộ?',
                                      title: '',
                                      confirm: false,
                                      neutralText: 'Không',
                                      positiveText: 'Có', positiveAction: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => ProgressDialog(
                                              message: 'Đang hủy yêu cầu...',
                                            ));
                                    _repo
                                        .cancelFinderForm(
                                            widget.finder.finderFormId,
                                            reasonController.text)
                                        .then((value) {
                                      if (value != null) {
                                        successDialog(
                                          context,
                                          'Yêu cầu cứu hộ đã bị hủy.',
                                          title: 'Đã hủy',
                                          neutralText: 'Đóng',
                                          neutralAction: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyApp(),
                                              ),
                                            );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgressReportPage()));
                                          },
                                        );
                                      } else {
                                        warningDialog(
                                          context,
                                          'Không thể hủy yêu cầu cứu hộ này.',
                                          title: '',
                                          neutralText: 'Đóng',
                                          neutralAction: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    });
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 8),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Đóng",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      );
    } else if (widget.finder.finderFormStatus == 2 ||
        widget.finder.finderFormStatus == 3) {
      return CustomDisableButton(
        label: 'HỦY YÊU CẦU',
      );
    } else {
      return SizedBox(height: 0);
    }
  }

  Widget _rescueForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: <Widget>[
              //* STATUS
              Container(
                 margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Trạng thái yêu cầu',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: getFinderFormStatus(
                                    widget.finder.finderFormStatus) ==
                                null ||
                            getFinderFormStatus(
                                    widget.finder.finderFormStatus) ==
                                ''
                        ? ''
                        : getFinderFormStatus(widget.finder.finderFormStatus),
                    hintStyle: TextStyle(
                      color: widget.finder.finderFormStatus != 5
                          ? Colors.green
                          : Colors.red,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.rule_outlined,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //* IMAGE PICKER
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' Ảnh mô tả',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: GridView.builder(
                    itemCount: widget.finder.finderImageUrl.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemBuilder: (context, int index) {
                      String item = widget.finder.finderImageUrl[index];
                      return Image.network(
                        item,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
              SizedBox(height: 10),
              //* VIDEO PICKER
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' Video mô tả',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                child: (widget.finder.finderFormVidUrl == null ||
                        widget.finder.finderFormVidUrl == '')
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Không có video mô tả',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        child: VideoThumbnailFromUrl(
                          videoUrl: widget.finder.finderFormVidUrl,
                        ),
                      ),
              ),
              SizedBox(height: 10),
              //* PHONE NUMBER
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Số điện thoại',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.phone,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(height: 10),
              //* RADIO
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Tình trạng của thú cưng',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: petAttribute,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(
                      Icons.pets,
                      color: mainColor,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //* DESCRIPTION
              Container(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả thêm',
                    labelStyle: TextStyle(
                      color: mainColor,
                    ),
                    hintText: widget.finder.finderDescription,
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  enabled: false,
                  maxLines: 5,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //* CANCEL REASON
              widget.finder.finderFormStatus == 5
                  ? Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Lí do hủy',
                          labelStyle: TextStyle(
                            color: mainColor,
                          ),
                          hintText: widget.finder.canceledReason == null ||
                                  widget.finder.canceledReason == ''
                              ? ''
                              : widget.finder.canceledReason,
                          hintStyle: TextStyle(
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(
                            Icons.cancel,
                            color: mainColor,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        maxLines: 3,
                        enabled: false,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
