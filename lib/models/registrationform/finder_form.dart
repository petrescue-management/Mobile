class FinderForm {
  String finderFormId;
  String finderDescription;
  List<String> finderImageUrl;
  String finderFormVidUrl;
  String finderDate;
  int petAttribute;
  int finderFormStatus;
  String phone;
  double lat;
  double lng;
  String canceledReason;

  FinderForm(form) {
    this.finderFormId = form['finderFormId'];
    this.finderDescription = form['description'];
    this.finderImageUrl = getImgUrlList(form['finderImageUrl']);
    this.finderFormVidUrl = form['finderFormVidUrl'];
    this.finderDate = form['finderDate'];
    this.petAttribute = form['petAttribute'];
    this.finderFormStatus = form['finderFormStatus'];
    this.phone = form['phone'];
    this.lat = form['lat'];
    this.lng = form['lng'];
    this.canceledReason = form['canceledReason'];
  }

  List getImgUrlList(String imgUrl) {
    List<String> result = [];

    List<String> tmp = imgUrl.split(';');
    tmp.forEach((item) {
      if (item == ';') {
        tmp.remove(item);
      }
    });

    tmp.removeLast();

    result = tmp;

    return result;
  }
}

class FinderFormBaseModel {
  List<FinderForm> result;

  FinderFormBaseModel({
    this.result,
  });

  FinderFormBaseModel.fromJson(List<dynamic> json) {
    List<FinderForm> tmpList = [];

    for (var i = 0; i < json.length; i++) {
      FinderForm tmp = FinderForm(json[i]);
      tmpList.add(tmp);
    }
    result = tmpList;
  }
}
