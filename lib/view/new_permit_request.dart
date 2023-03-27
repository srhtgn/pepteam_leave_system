import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pepteam_permission_system/constants/input_decoration.dart';
import 'package:pepteam_permission_system/services/permission_requests_service.dart';
import 'package:pepteam_permission_system/services/users_service.dart';
import 'package:pepteam_permission_system/view/permit_request_sent.dart';

class NewPermitRequest extends StatefulWidget {
  const NewPermitRequest({Key? key}) : super(key: key);

  @override
  State<NewPermitRequest> createState() => _NewPermitRequestState();
}

class _NewPermitRequestState extends State<NewPermitRequest> {
  final dateFormat = DateFormat('dd.MM.yyyy');
  var currentDate = DateTime.now();

  bool enabledState = false;

  TextEditingController _permissionStartController = TextEditingController();
  TextEditingController _workStartController = TextEditingController();
  TextEditingController _statementController = TextEditingController();

  var permissionStart;
  var workStart;
  String? statement;

  late int yearPermissionDateFormat;
  late int monthPermissionDateFormat;
  late int dayPermissionDateFormat;

  @override
  void dispose() {
    _permissionStartController.dispose();
    _workStartController.dispose();
    _statementController.dispose();
    super.dispose();
  }

  void valueInput() {
    setState(() {
      statement = _statementController.text;
    });
  }

  String requestStatus = 'Bekliyor';
  String? type;
  List listItem = ['Yıllık İzin', 'Ücretsiz İzin', 'Ücretli İzin']; //İzin türü listesi

  PermissionRequestsService _permissionRequestsService =
      PermissionRequestsService();

  UsersService _usersService = UsersService();

  late List<DocumentSnapshot> listOfDocumentSnapRequests;
  late List<DocumentSnapshot> listOfDocumentSnapUser;

  @override
  Widget build(BuildContext context) {
    if (permissionStart != null) { //
      enabledState = true;
      yearPermissionDateFormat =
          int.parse(DateFormat('yyyy').format(permissionStart));
      monthPermissionDateFormat =
          int.parse(DateFormat('MM').format(permissionStart));
      dayPermissionDateFormat = int.parse(
          DateFormat('dd').format(permissionStart.add(Duration(days: 1))));
    }

    int yearDateFormat = int.parse(DateFormat('yyyy').format(currentDate));
    int monthDateFormat = int.parse(DateFormat('MM').format(currentDate));
    int dayDateFormat = int.parse(DateFormat('dd').format(currentDate));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text('Yeni İzin Talebi'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 35),
        child: StreamBuilder<QuerySnapshot>( //
          stream: _usersService.getSpecificUsers(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            if (asyncSnapshot.hasError) {
              return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
            }
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (asyncSnapshot.hasData) {
                listOfDocumentSnapUser = asyncSnapshot.data.docs;
                var userName;
                for (int i = 0; i < listOfDocumentSnapUser.length; i++) {
                  userName = listOfDocumentSnapUser[i]['name'];
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('İzin Türü'),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: DropdownButton(
                        hint: Text('Ücretsiz İzin'),
                        focusColor: Colors.white,
                        value: type,
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (newValue) {
                          setState(() {
                            type = newValue as String?;
                          });
                        },
                        items: listItem.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem, child: Text(valueItem));
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text('Çıkış Tarihi'),
                    SizedBox(height: 5),
                    TextField(
                      readOnly: true,
                      controller: _permissionStartController,
                      decoration: InputDecorators().PermissionStartInput,
                      onTap: () async {
                        var initialDate;
                        if (currentDate.weekday == DateTime.saturday) { //Şu anki tarihin hafta sonu olması halinde yapılcak işlemler
                          initialDate = currentDate.add(Duration(days: 2));
                        } else if (currentDate.weekday == DateTime.sunday) {
                          initialDate = currentDate.add(Duration(days: 1));
                        }else{ initialDate = currentDate;}

                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            selectableDayPredicate: (DateTime val) => //Hafta sonları dışındaki günler seçilebilir
                                val.weekday == 6 || val.weekday == 7
                                    ? false
                                    : true,
                            firstDate: DateTime(
                                yearDateFormat, monthDateFormat, dayDateFormat),
                            lastDate: DateTime(currentDate.year + 1));
                        if (newDate != null) {
                          setState(() {
                            _permissionStartController.text =
                                dateFormat.format(newDate);
                            permissionStart = newDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    Text('Başlama Tarihi'),
                    SizedBox(height: 5),
                    TextField(
                      enabled: enabledState,
                      readOnly: true,
                      controller: _workStartController,
                      decoration: InputDecorators().WorkStartInput,
                      onTap: () async {
                        var initialDate;
                        DateTime workStartDate = permissionStart.add(Duration(days: 1)); //İşe başlama tarihi en erken izin başlangıç tarihinden 1 gün sonrası seçilebilir

                        if (workStartDate.weekday == DateTime.saturday) {
                          initialDate = workStartDate.add(Duration(days: 2));

                        } else if (workStartDate.weekday == DateTime.sunday) {
                          initialDate = workStartDate.add(Duration(days: 1));
                        }else{
                          initialDate = workStartDate;
                        }
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            selectableDayPredicate: (DateTime val) =>
                                val.weekday == 6 || val.weekday == 7
                                    ? false
                                    : true,
                            firstDate: DateTime(
                                yearPermissionDateFormat,
                                monthPermissionDateFormat,
                                dayPermissionDateFormat),
                            lastDate: DateTime(currentDate.year + 1));
                        if (newDate != null) {
                          setState(() {
                            _workStartController.text =
                                dateFormat.format(newDate);
                            workStart = newDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 15),
                    Text('Açıklama (opsiyonel)'),
                    SizedBox(height: 5),
                    TextField(
                      controller: _statementController,
                      decoration: InputDecorators().StatementInput,
                    ),
                    Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(127, 86, 217, 1),
                            minimumSize: Size(double.maxFinite, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          valueInput();

                          Duration difference = workStart.difference(permissionStart); //İki tarih arasındaki gün sayısını bul, hafta sonu günleri sayısını hesapla, gün sayısından hafta sonlarını çıkar
                          int differenceInDays = difference.inDays;
                          int weekends =
                              calculateweekends(permissionStart, workStart);
                          int totalDaysOff = differenceInDays - weekends;

                          if(totalDaysOff > 0){ //Tarihlerin yanlış girilmesi durumundaki kontrol ve hata mesajı
                            PermissionRequestsService().addData(
                                totalDaysOff,
                                requestStatus,
                                statement!,
                                type!,
                                userName,
                                currentDate,
                                permissionStart,
                                workStart);

                            Navigator.push( //Verilerin eksiksiz girilmesi durumunda izin gönderildi sayfasına git
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PermitRequestSent()));
                          } else {
                            final snackBar = SnackBar(
                              content: Text('Çıkış tarihi başlama tarihinden daha sonraki bir gün olarak seçilmiş!'),
                              backgroundColor: Colors.red,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          }



                        },
                        child: Text('Talebi Gönder'))
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          },
        ),
      ),
    );
  }

  int calculateweekends(permissionStart, workStart) { //Hafta sonlarını hesaplayan method
    int weekends = 0;
    for (DateTime date = permissionStart;
        date.isBefore(workStart);
        date = date.add(Duration(days: 1))) {
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        weekends++;
      }
    }
    return weekends;
  }
}
