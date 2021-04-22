import 'package:pet_rescue_mobile/models/pet/pet_model.dart';

class AdoptionRegisForm {
  String adoptionRegistrationId;
  int adoptionRegistrationStatus;
  String insertedAt;
  //user info
  String userName;
  String phone;
  String email;
  String job;
  String address;
  String houseType;
  String frequencyAtHome;
  String haveChildren;
  String childAge;
  String beViolentTendencies;
  String haveAgreement;
  String havePet;
  PetModel pet;

  AdoptionRegisForm(form) {
    this.adoptionRegistrationId = form['adoptionRegistrationId'];
    this.adoptionRegistrationStatus = form['adoptionRegistrationStatus'];
    this.insertedAt = form['insertedAt'];
    this.userName = form['userName'];
    this.phone = form['phone'];
    this.email = form['email'];
    this.job = form['job'];
    this.address = form['address'];
    this.houseType = getHouseType(form['houseType']);
    this.frequencyAtHome = getFrequencyAtHome(form['frequencyAtHome']);
    this.haveChildren = getHaveChildren(form['haveChildren']);
    this.childAge = getChildAge(form['childAge']);
    this.beViolentTendencies =
        getBeViolentTendencies(form['beViolentTendencies']);
    this.haveAgreement = getHaveAgreement(form['haveAgreement']);
    this.havePet = getHavePet(form['havePet']);
    this.pet = PetModel.fromJson(form['petProfile']);
  }

  List getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });
    result = tmp;

    return result;
  }

  getHouseType(int houseType) {
    String result = '';
    if (houseType == 1) {
      result = 'Nhà riêng';
    } else if (houseType == 2) {
      result = 'Chung cư';
    } else if (houseType == 3) {
      result = 'Nhà trọ';
    } else if (houseType == 4) {
      result = 'Nhà của bạn hoặc người thân';
    } else {
      result = 'Khác';
    }
    return result;
  }

  getFrequencyAtHome(int frequency) {
    String result = '';
    if (frequency == 1) {
      result = 'Chỉ về ngủ';
    } else if (frequency == 2) {
      result = 'Đi làm - Về nhà';
    } else if (frequency == 3) {
      result = 'Thường đi vắng';
    } else {
      result = 'Thường xuyên ở nhà';
    }
    return result;
  }

  getHaveChildren(bool haveChildren) {
    String result = '';
    if (haveChildren == true) {
      result = 'Có';
    } else {
      result = 'Không có';
    }
    return result;
  }

  getChildAge(int childAge) {
    if (childAge == 1) {
      return 'Dưới 5 tuổi';
    } else if (childAge == 2) {
      return 'Dưới 10 tuổi';
    } else {
      return 'Dưới 15 tuổi';
    }
  }

  getBeViolentTendencies(bool beViolentTendencies) {
    String result = '';
    if (beViolentTendencies == true) {
      result = 'Có';
    } else {
      result = 'Không có';
    }
    return result;
  }

  getHaveAgreement(bool haveAgreement) {
    String result = '';
    if (haveAgreement == true) {
      result = 'Có';
    } else {
      result = 'Không';
    }
    return result;
  }

  getHavePet(int havePet) {
    String result = '';
    if (havePet == 1) {
      result = 'Đã từng nuôi';
    } else if (havePet == 2) {
      result = 'Chưa từng nuôi';
    } else {
      result = 'Đang nuôi';
    }
    return result;
  }
}

class AdoptionRegisFormBaseModel {
  List<AdoptionRegisForm> result;

  AdoptionRegisFormBaseModel({
    this.result,
  });

  AdoptionRegisFormBaseModel.fromJson(List<dynamic> json) {
    List<AdoptionRegisForm> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      AdoptionRegisForm tmp = AdoptionRegisForm(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
