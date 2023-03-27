import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pepteam_permission_system/constants/text_styles.dart';
import 'package:pepteam_permission_system/services/permission_requests_service.dart';
import 'package:pepteam_permission_system/services/users_service.dart';

enum Weekday { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final dateFormat = DateFormat('dd.MM.yyyy');
  final timeFormat = DateFormat('HH:mm');
  var currentDate = DateTime.now();

  PermissionRequestsService _permissionRequestsService =
      PermissionRequestsService();

  UsersService _usersService = UsersService();

  late List<DocumentSnapshot> listOfDocumentSnapRequests;
  late List<DocumentSnapshot> listOfDocumentSnapUser;

  final id = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    CollectionReference colRef = FirebaseFirestore.instance.collection('users');


    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _usersService.getSpecificUsers(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(
                      child: Text('Bir hata oluştu tekrar deneyiniz'));
                } else if (asyncSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (asyncSnapshot.hasData) {
                    listOfDocumentSnapUser = asyncSnapshot.data.docs;

                    var state;
                    var statistics;

                    for (int i = 0; i < listOfDocumentSnapUser.length; i++) {
                      statistics =
                          listOfDocumentSnapUser[i]['admin statistics'];
                    }
                    state = Container(
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8))),
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text('Onay Bekleyen İzinler',
                                      style: TextStyles().grey_w500_s14),
                                  Spacer(),
                                  Text('${statistics[0]}',
                                      style: TextStyles().black_w600_s18),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 70,
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text('Onaylanan İzinler',
                                      style: TextStyles().grey_w500_s14),
                                  Spacer(),
                                  Text('${statistics[1]}',
                                      style: TextStyles().black_w600_s18),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 70,
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text('Reddedilen İzinler',
                                      style: TextStyles().grey_w500_s14),
                                  Spacer(),
                                  Text('${statistics[2]}',
                                      style: TextStyles().black_w600_s18),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 70,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(8))),
                            child: Padding(
                              padding: EdgeInsets.only(right: 15, left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  Text('Bugün İzinli Sayısı',
                                      style: TextStyles().grey_w500_s14),
                                  Spacer(),
                                  Text('${statistics[3]}',
                                      style: TextStyles().black_w600_s18),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    return state;
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              },
            ),
          ),
          SizedBox(height: 25),
          Text('Bekleyen Talepler', style: TextStyles().darkBlue_w600_s14),
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder(
                stream:
                    _permissionRequestsService.getPermissionRequestsForAdmin(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                        child: Text('Bir hata oluştu tekrar deneyiniz'));
                  } else if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (asyncSnapshot.hasData) {
                      listOfDocumentSnapRequests = asyncSnapshot.data.docs;

                      int _leavesPendingApproval = 0;
                      int _approvedLeavesForAdmin = 0;
                      int _deniedLeavesForAdmin = 0;
                      int _numberOfLeaveToday = 0;

                      return ListView.builder(
                        itemCount: listOfDocumentSnapRequests.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              asyncSnapshot.data!.docs[index];

                          var _id = listOfDocumentSnapRequests[index]['userId'];
                          var _name = listOfDocumentSnapRequests[index]['name'];
                          var _type = listOfDocumentSnapRequests[index]['type'];
                          var _permissionStart =
                              listOfDocumentSnapRequests[index]
                                  ['permission start'];
                          var _workStart =
                              listOfDocumentSnapRequests[index]['work start'];
                          var _recordTime =
                              listOfDocumentSnapRequests[index]['record time'];
                          var _requestStatus = listOfDocumentSnapRequests[index]
                              ['request status'];
                          var _totalDaysOff = listOfDocumentSnapRequests[index]
                              ['total days off'];
                          var _statement =
                              listOfDocumentSnapRequests[index]['statement'];

                          var statusData;

                          DateTime recordTime = _recordTime.toDate();
                          Duration difference =
                          currentDate.difference(recordTime);
                          int differenceInDays = difference.inDays;

                          if(differenceInDays > 0){
                            statusData = 'Reddedildi';
                            statusUpdate(
                                documentSnapshot,
                                statusData);
                          }

                          var status;
                          var paleColor;
                          var color;
                          var randomValue = Random().nextInt(3);

                          if (randomValue == 0) {
                            paleColor = Color.fromRGBO(240, 249, 255, 1.0);
                            color = Color.fromRGBO(2, 106, 162, 1.0);
                          } else if (randomValue == 1) {
                            paleColor = Color.fromRGBO(236, 253, 243, 1.0);
                            color = Color.fromRGBO(2, 122, 72, 1.0);
                          } else {
                            paleColor = Color.fromRGBO(254, 243, 242, 1.0);
                            color = Color.fromRGBO(180, 35, 24, 1.0);
                          }

                          if (_requestStatus == 'Bekliyor') {
                            _leavesPendingApproval += 1;
                          } else if (_requestStatus == 'Onaylandı') {
                            _approvedLeavesForAdmin += 1;
                          } else if (_requestStatus == 'Reddedildi') {
                            _deniedLeavesForAdmin += 1;
                          }

                          _permissionStart as Timestamp;
                          _workStart as Timestamp;
                          var leaveStart = _permissionStart.toDate();
                          var workStart = _workStart.toDate();

                          Weekday weekday = Weekday.values[currentDate.weekday - 1];

                          bool result = true;
                          if (weekday == Weekday.Saturday || weekday == Weekday.Sunday) {
                            result = false;
                          }

                          if ((currentDate.isAfter(leaveStart) &&
                              currentDate.isBefore(workStart)) && result == true && _requestStatus == 'Onaylandı') {
                            _numberOfLeaveToday += 1;
                          }

                          AdminStatisticsUpdate(
                              _leavesPendingApproval,
                              _approvedLeavesForAdmin,
                              _deniedLeavesForAdmin,
                              _numberOfLeaveToday);

                          if (_requestStatus == 'Bekliyor') {
                            status = InkWell(
                              onTap: () async {
                                var userRef = colRef.doc(_id);
                                var response = await userRef.get();

                                if(response['image'] == 'image'){
                                }


                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25))),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            right: 12,
                                            left: 12,
                                            top: 12,
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Stack(
                                            alignment:
                                            AlignmentDirectional.topCenter,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                  top: 0,
                                                  child: Container(
                                                    height: 3,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                        color: Colors.black),
                                                    //color: Colors.white,
                                                  )),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 15),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('Talep Detayları'),
                                                      IconButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          icon: Icon(Icons.close))
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      UserImage(response['image']),
                                                      Text(_name)
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('İzin Türü'),
                                                      Text(_type),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('İzne Çıkış'),
                                                      Text(dateFormat.format(
                                                          _permissionStart
                                                              .toDate())),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('İşe Başlama'),
                                                      Text(dateFormat.format(
                                                          _workStart.toDate())),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text('İzinli Gün Toplamı'),
                                                      Text('${_totalDaysOff
                                                          .toString()} İş Günü'),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Container(
                                                    width: double.maxFinite,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('Açıklama'),
                                                        Text(_statement)
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(height: 30),
                                                  ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Color.fromRGBO(
                                                              127, 86, 217, 1),
                                                          minimumSize: Size(
                                                              double.maxFinite,
                                                              50),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8))),
                                                      onPressed: () async {
                                                        statusData = 'Onaylandı';
                                                        statusUpdate(
                                                            documentSnapshot,
                                                            statusData);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Kabul Et')),
                                                  SizedBox(height: 10),
                                                  OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                          minimumSize: Size(
                                                              double
                                                                  .maxFinite,
                                                              50),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  8))),
                                                      onPressed: () async {
                                                        statusData = 'Reddedildi';
                                                        statusUpdate(
                                                            documentSnapshot,
                                                            statusData);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Reddet')),
                                                  SizedBox(height: 35)
                                                ],
                                              )
                                            ],
                                          ),
                                      );
                                    });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('$_type'),
                                            Text(
                                                '${dateFormat.format(_permissionStart.toDate())} - ${dateFormat.format(_workStart.toDate())} (${_totalDaysOff} iş günü)'),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 2, 10, 2),
                                              child: Text(_name,
                                                  style: GoogleFonts.inter(
                                                      textStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: color))),
                                              decoration: BoxDecoration(
                                                  color: paleColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                                '${timeFormat.format(_recordTime.toDate())}')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5)
                                ],
                              ),
                            );
                          } else if (_requestStatus != 'Bekliyor') {
                            status = SizedBox();
                          }

                          return status;
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                }),
          ),
        ],
      ),
    );
  }
  Widget UserImage(data) {
    var userImage;
    if(data == 'image'){
      userImage = Icon(Icons.account_circle, color: Colors.deepPurpleAccent, size: 50);
    }else{
      userImage = ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child:
        Image(
          image: NetworkImage(data),
          fit: BoxFit.cover,
          height: 100,
          width: 100,
        ),
      );
    }

    return userImage;
  }

  void AdminStatisticsUpdate(int _leavesPendingApproval, int _approvedLeavesForAdmin,
      int _deniedLeavesForAdmin, int _numberOfLeaveToday) {
    try{
      FirebaseFirestore.instance.collection('users').doc(id).update({
        'admin statistics': [
          _leavesPendingApproval,
          _approvedLeavesForAdmin,
          _deniedLeavesForAdmin,
          _numberOfLeaveToday
        ]
      });
    }catch(e){}

  }

  Future<void> statusUpdate(
      DocumentSnapshot<Object?> documentSnapshot, String statusData) {
    return FirebaseFirestore.instance
        .collection('PermissionRequests')
        .doc(documentSnapshot.id)
        .update({'request status': statusData});
  }
}
