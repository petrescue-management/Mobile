import 'package:flutter/material.dart';

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

    // setState(() {
    //   trackingList = widget.resultList;

    //   trackingList.sort((a, b) =>
    //       DateTime.parse(b.adoptedAt).compareTo(DateTime.parse(a.adoptedAt)));
    // });
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
  String insertedAt;

  @override
  void initState() {
    super.initState();
    setState(() {
      insertedAt = formatDateTime(widget.tracking.insertedAt);
    });
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year} ${tmp.hour}:${tmp.minute}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 15, bottom: 5),
      height: MediaQuery.of(context).size.height * 0.06,
      child: Stack(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    'Ngày báo cáo: $insertedAt',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }
}
