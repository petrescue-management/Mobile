import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:pet_rescue_mobile/models/pet/pet_tracking_model.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/personal/adoptedpet/tracking/tracking_report.dart';

// ignore: must_be_immutable
class TrackingList extends StatefulWidget {
  List<PetTrackingModel> resultList;
  String petProfileId;

  TrackingList({this.resultList, this.petProfileId});

  @override
  _TrackingListState createState() => _TrackingListState();
}

class _TrackingListState extends State<TrackingList> {
  ScrollController scrollController = ScrollController();

  List<PetTrackingModel> trackingList;

  @override
  void initState() {
    super.initState();

    setState(() {
      trackingList = widget.resultList;

      trackingList.sort((a, b) =>
          DateTime.parse(b.insertedAt).compareTo(DateTime.parse(a.insertedAt)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BÁO CÁO CỦA BẠN',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, size: 35),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 35),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return TrackingReport(
                      petProfileId: widget.petProfileId,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(adopted),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.65)),
          ),
          Container(
            child: (widget.resultList == null || widget.resultList == [])
                ? Center(
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
                            'Bạn chưa gửi báo cáo sau khi nhận nuôi nào về \ntrung tâm cứu hộ từng quản lý bé.',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        right: 20, left: 20, top: 20, bottom: 10),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      itemCount: widget.resultList.length,
                      itemBuilder: (context, index) {
                        PetTrackingModel result = widget.resultList[index];
                        return TrackingCard(tracking: result);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TrackingCard extends StatefulWidget {
  PetTrackingModel tracking;

  TrackingCard({this.tracking});

  @override
  _TrackingCard createState() => _TrackingCard();
}

class _TrackingCard extends State<TrackingCard> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController insertedAtController = TextEditingController();

  String insertedAt;
  List<String> imgUrlList;
  List<Widget> imageSliders;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      insertedAt = formatDateTime(widget.tracking.insertedAt);
      descriptionController.text = widget.tracking.description;
      insertedAtController.text = insertedAt;

      imgUrlList = widget.tracking.adoptionReportTrackingImgUrl;

      imageSliders = imgUrlList
          .map(
            (item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      imgUrlList.forEach((imageUrl) {
        precacheImage(NetworkImage(imageUrl), context);
      });
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result =
        '${tmp.day}/${tmp.month}/${tmp.year} - ${tmp.hour}:${tmp.minute}';
    return result;
  }

  showReportDetail(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 450,
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider(
                      items: imageSliders,
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgUrlList.map((url) {
                        int index = imgUrlList.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4)),
                        );
                      }).toList(),
                    ),
                    // description
                    Container(
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Mô tả',
                          labelStyle: TextStyle(
                            color: mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: mainColor,
                              width: 2,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        enabled: false,
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // inserted at
                    Container(
                      child: TextFormField(
                        controller: insertedAtController,
                        decoration: InputDecoration(
                          labelText: 'Ngày tạo báo cáo',
                          labelStyle: TextStyle(
                            color: mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: mainColor,
                              width: 2,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showReportDetail(context);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Stack(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      'Ngày báo cáo: $insertedAt',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(18)),
                border: Border.all(
                  color: mainColor,
                  width: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
