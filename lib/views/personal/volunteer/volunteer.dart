import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:pet_rescue_mobile/src/data.dart';
import 'package:pet_rescue_mobile/src/asset.dart';
import 'package:pet_rescue_mobile/src/style.dart';

import 'package:pet_rescue_mobile/views/personal/volunteer/volunteer_registration_form.dart';

class VolunteerWelcome extends StatefulWidget {
  @override
  _VolunteerWelcomeState createState() => _VolunteerWelcomeState();
}

class _VolunteerWelcomeState extends State<VolunteerWelcome> {
  ScrollController scrollController = new ScrollController();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.85)),
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: SizedBox(
                        child: volunteerPolicy,
                      ),
                    ),
                  ),
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
                                          builder: (context) => VolunteerForm(),
                                        ),
                                      );
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
                  fontFamily: 'SamsungSans',
                ),
                children: [
                  TextSpan(
                    text: '* ',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text:
                        'Tôi đảm bảo bản thân đáp ứng được các yêu cầu phía trên',
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
                      'Bạn cần đảm bảo được hết các yêu cầu của chúng tôi.'),
            ],
          ),
        ],
      ),
    );
  }
}
