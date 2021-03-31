import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/bloc/account_bloc.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/views/personal/config_menu.dart';
import 'package:pet_rescue_mobile/main.dart';
import 'package:pet_rescue_mobile/views/personal/profile/profile_details.dart';
import 'package:pet_rescue_mobile/views/progress/progress_report.dart';

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
                child: StreamBuilder(
                  stream: accountBloc.userDetail,
                  builder: (context, AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Column(
                          children: [
                            profilePic(snapshot.data),
                            configMenu(snapshot.data),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Widget profilePic(UserModel user) {
    var height = MediaQuery.of(context).size.height * 0.25;

    if (avatar != user.imgUrl ||
        fullname != '${user.lastName} ${user.firstName}') {
      return Container(
        height: height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        height: height,
        alignment: Alignment.center,
        child: Column(
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
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '${user.lastName} ${user.firstName}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget configMenu(UserModel user) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              icon: Icons.article,
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
    );
  }
}
