import 'dart:async';
import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/src/api_url.dart';
import 'package:pet_rescue_mobile/models/registrationform/adopt_form_model.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

class FormProvider {
  Future<bool> createRescueRequest(RescueReport rescueReport) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['finderDescription'] = rescueReport.finderDescription;
    resBody['petAttribute'] = rescueReport.petAttribute;
    resBody['finderFormImgUrl'] = rescueReport.finderFormImgUrl;
    resBody['lat'] = rescueReport.latitude;
    resBody['lng'] = rescueReport.longitude;
    resBody['phone'] = rescueReport.phone;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.createRescueRequest,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    print(str);

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
    }
    return null;
  }

  Future<String> createAdoptionRegistrionForm(AdoptForm adoptForm) async {
    String result = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['petProfileId'] = adoptForm.petProfileId;
    resBody['userName'] = adoptForm.userName;
    resBody['phone'] = adoptForm.phone;
    resBody['email'] = adoptForm.email;
    resBody['job'] = adoptForm.job;
    resBody['dob'] = adoptForm.dob;
    resBody['address'] = adoptForm.address;
    resBody['houseType'] = adoptForm.houseType;
    resBody['frequencyAtHome'] = adoptForm.frequencyAtHome;
    resBody['haveChildren'] = adoptForm.haveChildren;
    resBody['childAge'] = adoptForm.childAge;
    resBody['beViolentTendencies'] = adoptForm.beViolentTendencies;
    resBody['haveAgreement'] = adoptForm.haveAgreement;
    resBody['havePet'] = adoptForm.havePet;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.createAdoptRegistrationForm,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    print(str);

    if (response.statusCode == 200) {
      result = response.body.toString();
      return result;
    } else {
      print('Failed: ${response.statusCode} ${response.body}');
    }
    return null;
  }
}
