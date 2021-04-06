import 'package:flutter/material.dart';
import 'package:commons/commons.dart';

import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/bloc/account_bloc.dart';

import 'package:pet_rescue_mobile/models/user_model.dart';

import 'package:pet_rescue_mobile/repository/repository.dart';

import 'package:pet_rescue_mobile/main.dart';
import 'package:pet_rescue_mobile/views/login/policy.dart';
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

  bool hasRole = false;

  @override
  void initState() {
    super.initState();
    accountBloc.getDetail();
    SharedPreferences.getInstance().then((value) => {
          setState(() {
            avatar = value.getString('avatar');
            print(avatar);
            fullname = value.getString('fullname');
            print(fullname);
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
                      return Center(child: CircularProgressIndicator());
                    } else {
                      snapshot.data.roles.forEach((element) {
                        if (element == 'volunteer') {
                          hasRole = true;
                        }
                      });
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
      child: Container(
        margin: EdgeInsets.only(top: 25),
        height: MediaQuery.of(context).size.height * 0.6,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConfigMenu(
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
              ConfigMenu(
                text: 'Thú cưng của tôi',
                icon: Icons.favorite,
                press: () {},
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
              hasRole == false
                  ? ConfigMenu(
                      text: 'Trở thành tình nguyện viên',
                      icon: Icons.volunteer_activism,
                      press: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return VolunteerWelcome();
                            },
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      height: 0,
                    ),
              ConfigMenu(
                text: 'Điều khoản',
                icon: Icons.policy,
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PolicyPage();
                      },
                    ),
                  );
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
