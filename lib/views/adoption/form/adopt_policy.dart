import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/adoption/form/adoption_form.dart';
import 'package:pet_rescue_mobile/views/custom_widget/custom_divider.dart';

// ignore: must_be_immutable
class AdoptionAgreement extends StatefulWidget {
  PetModel pet;

  AdoptionAgreement({this.pet});

  @override
  _AdoptionAgreementState createState() => _AdoptionAgreementState();
}

class _AdoptionAgreementState extends State<AdoptionAgreement> {
  ScrollController scrollController = new ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  List<String> imgUrlList;
  String firstUrl;

  @override
  void initState() {
    super.initState();
    setState(() {
      imgUrlList = widget.pet.petImgUrl;
      firstUrl = imgUrlList.elementAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(adoptregis),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pet short detail
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: mainColor, width: 2),
                            image: DecorationImage(
                              image: NetworkImage(firstUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.pet.petName,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Tuổi: ' + widget.pet.petAge,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Giống: ' + widget.pet.petBreedName,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomDivider(),
                  // conditions
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SizedBox(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: SizedBox(
                          child: adoptionPolicy,
                        ),
                      ),
                    ),
                  ),
                  // accept terms
                  FormBuilder(
                    key: _fbKey,
                    child: Expanded(
                      child: Stack(
                        children: [
                          confirmationCheckbox(context),
                          Positioned(
                            right: 0,
                            bottom: 30,
                            child: ClipOval(
                              child: Material(
                                color: primaryGreen,
                                child: InkWell(
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    if (_fbKey.currentState.saveAndValidate()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdoptFormRegistrationPage(
                                                    pet: widget.pet,
                                                  )));
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //back button
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.only(
                top: 8,
                left: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // confirmation check
  Widget confirmationCheckbox(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          //* CONFIRMATION
          FormBuilderCheckbox(
            attribute: 'acceptTerms',
            onChanged: (value) => () {
              var _onChanged = true;
              setState(() {
                value = _onChanged;
                _onChanged = !_onChanged;
              });
            },
            initialValue: false,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            label: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Philosopher',
                ),
                children: [
                  TextSpan(
                    text: '* ',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text:
                        'Tôi đồng ý với các điều khoản mà tổ thức đưa ra.',
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            validators: [
              FormBuilderValidators.requiredTrue(
                  errorText:
                      'Bạn cần đồng ý với điều khoản của chúng tôi.'),
            ],
          ),
        ],
      ),
    );
  }
}
