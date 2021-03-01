import 'package:flutter/material.dart';
import 'package:commons/commons.dart';
import 'package:pet_rescue_mobile/bloc/account_bloc.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/repository/repository.dart';
import 'package:pet_rescue_mobile/views/personal/config_menu.dart';
import 'package:pet_rescue_mobile/main.dart';
import 'package:pet_rescue_mobile/views/personal/profile_details.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _repo = Repository();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc.getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.black,
              onPressed: () {
                confirmationDialog(
                    context, "Are you sure you want to sign out?",
                    positiveText: "Yes",
                    neutralText: "No",
                    confirm: false, positiveAction: () {
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
            stream: bloc.userDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [profilePic(snapshot.data), configMenu()],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

  Widget profilePic(UserModel user) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.25,
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: 130,
              width: 130,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.imgUrl),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(user.firstName + " " + user.lastName, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5
            ),)
          ],
        ));
  }

  Widget configMenu() {
    return Container(
        child: Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ConfigMenu(
              text: 'My Profile',
              icon: Icons.account_circle,
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileDetails();
                    },
                  ),
                );
              }),
          ConfigMenu(text: 'My Pet', icon: Icons.favorite, press: () {}),
          ConfigMenu(text: 'Become A Center', icon: Icons.pets, press: () {}),
        ],
      ),
    ));
  }
}
