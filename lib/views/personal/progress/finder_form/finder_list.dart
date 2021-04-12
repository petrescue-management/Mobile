import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/bloc/form_bloc.dart';
import 'package:pet_rescue_mobile/models/registrationform/finder_form.dart';

import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/personal/progress/finder_form/finder_card.dart';

class RescueRequestList extends StatefulWidget {
  @override
  _RescueRequestListState createState() => _RescueRequestListState();
}

class _RescueRequestListState extends State<RescueRequestList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    formBloc.getFinderList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: StreamBuilder(
        stream: formBloc.getFinderFormList,
        builder: (context, AsyncSnapshot<FinderFormBaseModel> snapshot) {
          if (snapshot.hasError || snapshot.data == null) {
            return loading(context);
          } else if (snapshot.data.result.length == 0) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 200),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(emptyBox),
                      height: 100,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Bạn chưa gửi yêu cầu cứu hộ nào!',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            List<FinderForm> resultList = snapshot.data.result;

            resultList.sort((a, b) => DateTime.parse(b.finderDate)
                .compareTo(DateTime.parse(a.finderDate)));

            return Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: resultList.length,
                itemBuilder: (context, index) {
                  FinderForm result = resultList[index];
                  return FinderCard(finder: result);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
