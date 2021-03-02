import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/bloc/account_bloc.dart';
import 'package:pet_rescue_mobile/models/user_model.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key key}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: TextStyle(
            color: Colors.black,
          ),),
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: accountBloc.userDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [profilePic(snapshot.data)],
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
        child: SizedBox(
          height: 125,
          width: 125,
          child: Stack(
            fit: StackFit.expand,
            overflow: Overflow.visible,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.imgUrl),
              ),
              Positioned(
                  right: -25,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF5F6F9), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.camera,
                        size: 22,
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
