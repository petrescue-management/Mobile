import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
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
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.logout),
                color: Colors.black,
                onPressed: () {
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
              )
            ],
          ),
          body: Center(
            child: StreamBuilder(
              stream: accountBloc.userDetail,
              builder: (context, AsyncSnapshot<UserModel> snapshot) {
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    children: [
                      profilePic(snapshot.data),
                      configMenu(snapshot.data),
                    ],
                  );
                }
              },
            ),
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
            SizedBox(
              height: 125,
              width: 125,
              child: Stack(
                fit: StackFit.expand,
                overflow: Overflow.visible,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.imgUrl),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '${user.lastName} ${user.firstName}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
              text: 'Trở thành Trung tâm cứu hộ',
              icon: Icons.pets,
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
