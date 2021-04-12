import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/bloc/form_bloc.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_regis_form.dart';

import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'package:pet_rescue_mobile/views/personal/progress/adopt_registration/adoption_regis_card.dart';

class AdoptionRegistrationFormList extends StatefulWidget {
  @override
  _AdoptionRegistrationFormListState createState() =>
      _AdoptionRegistrationFormListState();
}

class _AdoptionRegistrationFormListState
    extends State<AdoptionRegistrationFormList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    formBloc.getAdoptRegistrationList();
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
        stream: formBloc.getAdoptRegisList,
        builder: (context, AsyncSnapshot<AdoptionRegisFormBaseModel> snapshot) {
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
                      'Bạn chưa đăng ký nhận nuôi bé nào!',
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
            List<AdoptionRegisForm> resultList = snapshot.data.result;

            resultList.sort((a, b) => DateTime.parse(b.insertedAt)
                .compareTo(DateTime.parse(a.insertedAt)));

            return Container(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: resultList.length,
                itemBuilder: (context, index) {
                  AdoptionRegisForm result = resultList[index];
                  return AdoptionRegistrationFormCard(form: result);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
