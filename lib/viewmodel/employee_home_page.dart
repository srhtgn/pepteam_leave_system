import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pepteam_permission_system/constants/image_items.dart';
import 'package:pepteam_permission_system/constants/text_styles.dart';
import 'package:pepteam_permission_system/services/permission_requests_service.dart';
import 'package:pepteam_permission_system/services/users_service.dart';
import 'package:pepteam_permission_system/view/new_permit_request.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  final dateFormat = DateFormat('dd.MM.yyyy');
  final timeFormat = DateFormat('HH:mm');
  var currentDate = DateTime.now();

  PermissionRequestsService _permissionRequestsService =
  PermissionRequestsService();

  UsersService _usersService = UsersService();

  late List<DocumentSnapshot> listOfDocumentSnapRequests;
  late List<DocumentSnapshot> listOfDocumentSnapUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
      resizeToAvoidBottomInset: false,
      body: Column(
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
                      listOfDocumentSnapUser[i]['employee statistics'];
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
                                  Text('Onaylanan İzinlerim',
                                      style: TextStyles().grey_w500_s14),
                                  Spacer(),
                                  // getStatistics(0),
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
                                  Text('Reddedilen İzinlerim',
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
                                  Text('Ücretsiz İzinlerim',
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
                                  Text('Yıllık İzin Hakkım',
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
          SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bekleyen Talepler',
                    style: TextStyles().darkBlue_w600_s14),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewPermitRequest()));
                  },
                  child: DashedLineButton(),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: StreamBuilder(
                stream: _permissionRequestsService
                    .getPermissionRequestsForEmployee(),
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

                      int _approvedLeaves = 0;
                      int _deniedLeaves = 0;
                      int _freeLeaves = 0;
                      int _annualLeaveEntitlement = 30;
                      int _annualDayOff = 0;
                      var icon;
                      var iconText;

                      return ListView.builder(
                        itemCount: listOfDocumentSnapRequests.length,
                        itemBuilder: (context, index) {
                          var _type = listOfDocumentSnapRequests[index]['type'];
                          var _id = listOfDocumentSnapRequests[index]['userId'];
                          var _permissionStart = listOfDocumentSnapRequests[index]['permission start'];
                          var _workStart = listOfDocumentSnapRequests[index]['work start'];
                          var _recordTime = listOfDocumentSnapRequests[index]['record time'];
                          var _requestStatus = listOfDocumentSnapRequests[index]['request status'];
                          var _totalDaysOff = listOfDocumentSnapRequests[index]['total days off'];
                          var _statement = listOfDocumentSnapRequests[index]['statement'];

                          DateTime recordTime = _recordTime.toDate();

                          var paleColor;
                          var color;

                          if (_requestStatus == 'Onaylandı') {
                            _approvedLeaves += 1;
                          }

                          if (_requestStatus == 'Reddedildi') {
                            _deniedLeaves += 1;
                          }

                          if (_type == 'Ücretsiz İzin' &&
                              _requestStatus == 'Onaylandı') {
                            _freeLeaves += 1;
                          }
                          if (_type == 'Yıllık İzin' &&
                              _requestStatus == 'Onaylandı') {
                            _annualDayOff += _totalDaysOff as int;
                            _annualLeaveEntitlement -= _annualDayOff;
                            _annualDayOff = 0;
                          }

                          EmployeeStatisticsUpdate(_id, _approvedLeaves, _deniedLeaves, _freeLeaves, _annualLeaveEntitlement);

                          switch (_requestStatus) {
                            case 'Bekliyor':
                              {
                                paleColor = Color.fromRGBO(240, 249, 255, 1.0);
                                color = Color.fromRGBO(2, 106, 162, 1.0);
                                break;
                              }
                            case 'Onaylandı':
                              {
                                paleColor = Color.fromRGBO(236, 253, 243, 1.0);
                                color = Color.fromRGBO(2, 122, 72, 1.0);

                                break;
                              }
                            case 'Reddedildi':
                              {
                                paleColor = Color.fromRGBO(254, 243, 242, 1.0);
                                color = Color.fromRGBO(180, 35, 24, 1.0);

                                break;
                              }
                          }

                          var yesterday = currentDate.subtract(Duration(days: 1));
                          var recordDate;

                          if(dateFormat.format(recordTime) == dateFormat.format(currentDate)){
                            recordDate = 'Bugün';
                          }else if(dateFormat.format(recordTime) == dateFormat.format(yesterday)){
                            recordDate = 'Dün';
                          }
                          else{
                            recordDate = dateFormat.format(recordTime);
                          }

                          return InkWell(
                            onTap: () async {
                              bool _buttonVisible = true;
                              if (_requestStatus == 'Onaylandı') {
                                icon = SvgPicture.asset(SvgImage().tickIcon);
                                iconText = Text('Talep Onaylandı',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                2, 171, 101, 1.0))));

                                await approvedDeniedBottomSheet(
                                    context,
                                    icon,
                                    iconText,
                                    _type,
                                    _permissionStart,
                                    _workStart,
                                    _totalDaysOff,
                                    _statement,
                                    _buttonVisible,
                                    _requestStatus,
                                    index);


                              } else if (_requestStatus == 'Reddedildi') {
                                icon = SvgPicture.asset(SvgImage().crossIcon);
                                iconText = Text('Talebin Onaylanmadı',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromRGBO(
                                                179, 35, 24, 1.0))));
                                _buttonVisible = false;
                                await approvedDeniedBottomSheet(
                                    context,
                                    icon,
                                    iconText,
                                    _type,
                                    _permissionStart,
                                    _workStart,
                                    _totalDaysOff,
                                    _statement,
                                    _buttonVisible,
                                    _requestStatus,
                                    index);
                              } else if (_requestStatus == 'Bekliyor') {
                                await waitingBottomSheet(
                                    context,
                                    _type,
                                    _permissionStart,
                                    _workStart,
                                    _totalDaysOff,
                                    _statement,
                                    _requestStatus,
                                    index);
                              }

                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('$_type'),
                                          Text(
                                              '$recordDate ${ timeFormat.format(
                                                  _recordTime.toDate())}')]),
                                      Text(
                                          '${dateFormat.format(
                                              _permissionStart
                                                  .toDate())} - ${dateFormat
                                              .format(_workStart
                                              .toDate())} (${_totalDaysOff} iş günü)'),

                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 2, 10, 2),
                                            child: Text('${_requestStatus}',
                                                style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: color))),
                                            decoration: BoxDecoration(
                                                color: paleColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                        ],
                                      ),
                                ),
                                SizedBox(height: 5)
                              ],
                            ),
                          );
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

  void EmployeeStatisticsUpdate(_id, int _approvedLeaves, int _deniedLeaves, int _freeLeaves, int _annualLeaveEntitlement) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_id)
          .update({
        'employee statistics': [
          _approvedLeaves,
          _deniedLeaves,
          _freeLeaves,
          _annualLeaveEntitlement
        ]
      });
    } catch (e) {}
  }

  approvedDeniedBottomSheet(BuildContext context, icon, iconText, _type,
      _permissionStart, _workStart, _totalDaysOff, _statement,
      bool _buttonVisible, _requestStatus, int index) async {
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
                bottom: MediaQuery
                    .of(context)
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
                        icon,
                        SizedBox(height: 25),
                        iconText
                      ],
                    ),
                    SizedBox(height: 45),
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
                        Text(_totalDaysOff
                            .toString()),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text('Açıklama'),
                          Text(_statement)
                        ],
                      ),
                    ),

                    SizedBox(height: 30),
                    Visibility(
                        visible: _buttonVisible,
                        child: OutlinedButton(
                            style: OutlinedButton
                                .styleFrom(
                                minimumSize: Size(
                                    double
                                        .maxFinite,
                                    50)),
                            onPressed: () async {
                              if ((_requestStatus ==
                                  'Bekliyor') ||
                                  (_requestStatus ==
                                      'Onaylandı')) {
                                Navigator.of(context)
                                    .pop();
                                await listOfDocumentSnapRequests[
                                index]
                                    .reference
                                    .delete();
                              } else {}
                            },
                            child: Text(
                                'Talebi İptal Et'))),

                    SizedBox(height: 50)
                  ],
                )
              ],
            ),
          );
        });
  }

  waitingBottomSheet(BuildContext context, _type, _permissionStart, _workStart,
      _totalDaysOff, _statement, _requestStatus,
      int index) async {
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
                bottom: MediaQuery
                    .of(context)
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
                    SizedBox(height: 45),
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
                        Text(_totalDaysOff
                            .toString()),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text('Açıklama'),
                          Text(_statement)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    OutlinedButton(
                        style: OutlinedButton
                            .styleFrom(
                            minimumSize: Size(
                                double
                                    .maxFinite,
                                50)),
                        onPressed: () async {
                          if ((_requestStatus ==
                              'Bekliyor') ||
                              (_requestStatus ==
                                  'Onaylandı')) {
                            Navigator.of(context)
                                .pop();
                            await listOfDocumentSnapRequests[
                            index]
                                .reference
                                .delete();
                          } else {}
                        },
                        child: Text(
                            'Talebi İptal Et')),
                    SizedBox(height: 50)
                  ],
                )
              ],
            ),
          );
        });
  }
}

class DashedLineButton extends StatelessWidget {
  const DashedLineButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        color: Color.fromRGBO(0, 0, 71, 1.0),
        strokeWidth: 1.5,
        borderType: BorderType.RRect,
        dashPattern: [4, 2],
        radius: Radius.circular(8),
        child: Container(
          width: double.maxFinite,
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Color.fromRGBO(0, 0, 71, 1.0)),
              SizedBox(width: 5),
              Text('Yeni İzin Talebi', style: TextStyles().darkBlue_w600_s14)
            ],
          ),
        ));
  }
}
