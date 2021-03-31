import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatefulWidget {
  UserModel user;

  ProfileDetails({this.user});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ScrollController scrollController = ScrollController();

  Future<bool> _confirmPop() {
    return confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
        positiveText: "Có",
        neutralText: "Không",
        confirm: false,
        title: "", positiveAction: () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN');
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: _confirmPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              'Chỉnh sửa thông tin',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
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
                confirmationDialog(context, "Hủy chỉnh sửa thông tin ?",
                    positiveText: "Có",
                    neutralText: "Không",
                    confirm: false,
                    title: "", positiveAction: () {
                  Navigator.of(context).pop();
                });
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.save,
                ),
                color: Colors.black,
                onPressed: () {
                  confirmationDialog(context, "Lưu chỉnh sửa thông tin ?",
                      positiveText: "Có",
                      neutralText: "Không",
                      confirm: false,
                      title: "", positiveAction: () {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
          body: Container(
            child: Column(
              children: [
                profilePic(context, widget.user),
                profileInfo(context, widget.user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profilePic(BuildContext context, UserModel user) {
    var height = MediaQuery.of(context).size.height * 0.2;

    return Container(
      height: height,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color2, width: 2),
              image: DecorationImage(
                image: NetworkImage(user.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                  ),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  convertStringtoDateTime(String date) {
    DateTime tmp = DateFormat('yyyy-MM-dd').parse(date);
    var result = DateFormat.yMMMMd('vi_VN').format(tmp);
    return result;
  }

  String getUserGender(int index) {
    if (index == 1)
      return 'Nữ';
    else if (index == 2)
      return 'Nam';
    else
      return 'Khác';
  }

  Widget profileInfo(BuildContext context, UserModel user) {
    var userDob = convertStringtoDateTime(user.dob);
    var userGender = getUserGender(user.gender);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        height: MediaQuery.of(context).size.height * 0.7,
        child: SizedBox(
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  'Họ',
                  '${user.lastName}',
                ),
                customText(
                  'Tên',
                  '${user.firstName}',
                ),
                customText(
                  'Giới tính',
                  userGender,
                ),
                customText(
                  'Ngày sinh',
                  userDob == null ? 'Chưa có' : userDob,
                ),
                customText(
                  'Email',
                  '${user.email}',
                ),
                customText(
                  'Số điện thoại',
                  (user.phone == null || user.phone == '')
                      ? 'Chưa có'
                      : '${user.phone}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
