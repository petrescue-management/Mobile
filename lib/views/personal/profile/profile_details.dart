import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_field.dart';

// ignore: must_be_immutable
class ProfileDetails extends StatelessWidget {
  UserModel user;

  ProfileDetails({this.user});

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('vi_VN');
    return Scaffold(
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            profileInfo(context, user),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      height: MediaQuery.of(context).size.height * 0.9,
      child: SizedBox(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              customText(
                'Họ tên',
                '${user.lastName} ${user.firstName}',
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
              customText(
                'Địa chỉ',
                (user.address == null || user.address == '')
                    ? 'Chưa có'
                    : '${user.address}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
