import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/bloc/center_bloc.dart';
import 'package:pet_rescue_mobile/models/center/center_base_model.dart';
import 'package:pet_rescue_mobile/models/center/center_model.dart';
import 'package:pet_rescue_mobile/views/personal/volunteer/center/center_item.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

class CenterList extends StatefulWidget {
  @override
  _CenterListState createState() => _CenterListState();
}

class _CenterListState extends State<CenterList> {
  @override
  void initState() {
    super.initState();
    centerBloc.getCenterList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chọn trung tâm cứu hộ',
          style: TextStyle(
            color: Colors.black,
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
                image: AssetImage(volunteer),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7)),
          ),
          Center(
            child: Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  stream: centerBloc.getCenter,
                  builder: (context, AsyncSnapshot<CenterBaseModel> snapshot) {
                    if (snapshot.hasError || snapshot.data == null) {
                      return loading(context);
                    } else {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.result.length,
                        itemBuilder: (context, index) {
                          CenterModel result = snapshot.data.result[index];
                          return CenterItem(
                            center: result,
                          );
                        },
                      );
                    }
                  },
                )),
          )
        ],
      ),
    );
  }

  // loading
  Widget loading(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white.withOpacity(0),
          ),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
