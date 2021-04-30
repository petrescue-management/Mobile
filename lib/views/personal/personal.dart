import 'package:flutter/material.dart';
import 'package:commons/commons.dart';

import 'package:pet_rescue_mobile/bloc/account_bloc.dart';
import 'package:pet_rescue_mobile/models/user/user_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/main.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/personal/adoptedpet/adopted_pet.dart';
import 'package:pet_rescue_mobile/views/personal/config_menu.dart';
import 'package:pet_rescue_mobile/views/personal/profile/profile_details.dart';
import 'package:pet_rescue_mobile/views/personal/volunteer/volunteer.dart';
import 'package:pet_rescue_mobile/views/personal/progress/progress_report.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _repo = Repository();

  ScrollController scrollController = ScrollController();

  String avatar, fullname;

  @override
  void initState() {
    super.initState();
    accountBloc.getDetail();
    SharedPreferences.getInstance().then((value) => {
          setState(() {
            avatar = value.getString('avatar');
            fullname = value.getString('fullname');
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Center(
              child: Container(
                child: StreamBuilder(
                  stream: accountBloc.userDetail,
                  builder: (context, AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return loading(context);
                    } else {
                      return Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [color3, color2, color1],
                                ),
                              ),
                              child: profilePic(snapshot.data),
                            ),
                            configMenu(snapshot.data),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePic(UserModel user) {
    if (avatar != user.imgUrl ||
        fullname != '${user.lastName} ${user.firstName}') {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 125,
            height: 125,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: NetworkImage(user.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              '${user.lastName} ${user.firstName}',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget configMenu(UserModel user) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      child: SizedBox(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: ConfigMenu(
                  text: 'Chỉnh sửa thông tin',
                  icon: Icons.account_circle,
                  press: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ProfileDetails(
                            user: user,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              ConfigMenu(
                text: 'Thú cưng của tôi',
                icon: Icons.favorite,
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AdoptedPet();
                      },
                    ),
                  );
                },
              ),
              ConfigMenu(
                text: 'Yêu cầu của tôi',
                icon: Icons.add_box,
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProgressReportPage();
                      },
                    ),
                  );
                },
              ),
              ConfigMenu(
                text: 'Trở thành tình nguyện viên',
                icon: Icons.volunteer_activism,
                press: () {
                  if (user.roles.length == 0 || user.roles == []) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return VolunteerWelcome();
                        },
                      ),
                    );
                  } else {
                    infoDialog(
                      context,
                      'Bạn đã là tình nguyện viên.\nBạn không thể đăng ký làm tình nguyện viên của trung tâm khác ngay lúc này.',
                      title: 'Thông báo',
                      neutralText: 'Đóng',
                    );
                  }
                },
              ),
              ConfigMenu(
                text: 'Đăng xuất',
                icon: Icons.logout,
                press: () {
                  confirmationDialog(context, "Bạn chắc chắn muốn đăng xuất ?",
                      positiveText: "Có",
                      neutralText: "Không",
                      confirm: false,
                      title: "", positiveAction: () {
                    _repo.signOut().then((_) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    });
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
