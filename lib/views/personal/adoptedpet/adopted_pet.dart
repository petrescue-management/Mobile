import 'package:flutter/material.dart';

import 'package:pet_rescue_mobile/bloc/pet_bloc.dart';
import 'package:pet_rescue_mobile/models/pet/adopted_pet_model.dart';
import 'package:pet_rescue_mobile/models/pet/adopted_list_base_model.dart';

import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/src/asset.dart';

import 'package:pet_rescue_mobile/views/custom_widget/custom_dialog.dart';
import 'adopted_pet_detail.dart';

class AdoptedPet extends StatefulWidget {
  @override
  _AdoptedPetState createState() => _AdoptedPetState();
}

class _AdoptedPetState extends State<AdoptedPet> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    petBloc.getAdoptedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'THÚ CƯNG CỦA TÔI',
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
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: backgroundColor),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
          ),
          Container(
            child: StreamBuilder(
              stream: petBloc.getAdoptedPetList,
              builder: (context, AsyncSnapshot<AdoptedListBaseModel> snapshot) {
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
                            'Bạn chưa nhận nuôi bé nào!',
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
                  snapshot.data.result.sort((a, b) =>
                      DateTime.parse(b.adoptedAt)
                          .compareTo(DateTime.parse(a.adoptedAt)));

                  return Container(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      controller: scrollController,
                      itemCount: snapshot.data.result.length,
                      itemBuilder: (context, index) {
                        return AdoptedCard(
                            adopted: snapshot.data.result[index]);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AdoptedCard extends StatefulWidget {
  AdoptedPetModel adopted;

  AdoptedCard({this.adopted});

  @override
  _AdoptedCard createState() => _AdoptedCard();
}

class _AdoptedCard extends State<AdoptedCard> {
  @override
  void initState() {
    super.initState();
  }

  formatDateTime(String date) {
    DateTime tmp = DateTime.parse(date);
    String result = '${tmp.day}/${tmp.month}/${tmp.year}';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AdoptedDetails(
                adopted: widget.adopted,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: MediaQuery.of(context).size.height * 0.14,
        child: Stack(
          children: [
            Container(
              child: Row(
                children: [
                  // image
                  Container(
                    width: MediaQuery.of(context).size.width * 0.32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                      image: DecorationImage(
                        image:
                            NetworkImage(widget.adopted.petImgUrl.elementAt(0)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // name & adopted date
                  Expanded(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.adopted.petName,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Người nhận nuôi: ${widget.adopted.owner.lastName} ${widget.adopted.owner.firstName}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Ngày nhận nuôi: ${formatDateTime(widget.adopted.adoptedAt)}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fadedBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: mainColor,
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
