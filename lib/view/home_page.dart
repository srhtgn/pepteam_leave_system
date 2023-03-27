import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pepteam_permission_system/auth/login_page.dart';
import 'package:pepteam_permission_system/constants/image_items.dart';
import 'package:pepteam_permission_system/services/users_service.dart';
import 'package:pepteam_permission_system/viewmodel/admin_home_page.dart';
import 'package:pepteam_permission_system/viewmodel/employee_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  UsersService userService = UsersService();

  late List<DocumentSnapshot> listOfDocumentSnapUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SvgPicture.asset(SvgImage().logoIconSmall),
            SizedBox(width: 5),
            SvgPicture.asset(SvgImage().pepteamLogoIcon),
          ],
        ),
        actions: [
          InkWell(
                onTap: (){
                  UserAlertDialog(context);
                },
                child: UserImage(),
              ),
          SizedBox(width: 10)
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 12, right: 12, left: 12),
          child: HomePages()),
    );
  }

  Widget? HomePages() {
    if (user.email == 's@s.com') {
      return AdminHomePage();
    } else {
      return EmployeeHomePage();
    }
  }

  Future<void> UserAlertDialog(BuildContext context) async {
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserInformation(),
              SizedBox(height: 5),
              TextButton(
                  onPressed: () async {
                    SignOutRequest(context);
                  },
                  child: Text(
                      'Çıkış Yap'))
            ],
          )
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> UserInformation() {
    return StreamBuilder<QuerySnapshot>(
        stream: userService.getSpecificUsers(),
        builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return Center(child: Text('Bir hata oluştu tekrar deneyiniz'));
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (asyncSnapshot.hasData) {
              listOfDocumentSnapUser = asyncSnapshot.data.docs;

              var name;
              var email;

              for (int i = 0; i < listOfDocumentSnapUser.length; i++) {
                name = listOfDocumentSnapUser[i]['name'];
                email = listOfDocumentSnapUser[i]['email'];
              }
              return Container(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: InkWell(
                            onTap: () {
                              ImageAlertDialog(context);
                            },
                            child: UserImage(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name),
                        SizedBox(height: 10),
                        Text(email),
                      ],
                    )

                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        });
  }

  Future<void> SignOutRequest(BuildContext context) async {
    showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          Column(
            children: [
              Text('Çıkış yapmak istediğinizden emin misiniz?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 5),
                  TextButton(
                      onPressed: () async {
                        await SignOut(context);
                      },
                      child: Text(
                          'Evet', style: TextStyle(color: Colors.red))),
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                          'Hayır'))
                ],
              )
            ],
          )

        ],
      ),
    );
  }

  Future<void> ImageAlertDialog(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    showDialog<double>(
        context: context,
        builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            actions: [
              Row(
                children: [
                  Spacer(),
                  IconButton(
                      onPressed: () async {
                        XFile? _fileGallery = await _picker.pickImage(
                            source: ImageSource.gallery);
                        await ImageUpload(_fileGallery);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.photo,
                          color: Colors.deepPurpleAccent)),
                  Spacer(),
                  IconButton(
                      onPressed: () async {
                        XFile? _fileCamera = await _picker.pickImage(
                            source: ImageSource.camera);
                        await ImageUpload(_fileCamera);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.photo_camera,
                          color: Colors.deepPurple)),
                  Spacer(),
                ],
              )
            ]));
  }

  StreamBuilder<QuerySnapshot<Object?>> UserImage() {
    return StreamBuilder<QuerySnapshot>(
                stream: userService.getSpecificUsers(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                        child: Text('Bir hata oluştu tekrar deneyiniz'));
                  }
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (asyncSnapshot.hasData) {
                      listOfDocumentSnapUser = asyncSnapshot.data.docs;
                      var image;
                      var state;

                      for (int i = 0; i < listOfDocumentSnapUser.length; i++) {
                        image = listOfDocumentSnapUser[i]['image'];
                      }


                      if(image == 'image'){
                        state = Icon(Icons.account_circle, color: Colors.deepPurpleAccent, size: 35);
                      }else{
                        state = CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(image),
                        );
                      }

                      return state;

                    }else {
                      return Center(child: CircularProgressIndicator());
                  }
                }});
  }



  Future<void> ImageUpload(XFile? file) async {
    XFile? _file = file;
    var _profileRef = FirebaseStorage.instance.ref('${user.email}');
    var _task = _profileRef.putFile(File(_file!.path));

    _task.whenComplete(() async {
      var _url = await _profileRef.getDownloadURL();
      try{
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'image': _url.toString()}, SetOptions(merge: true));
      }catch(e){}
    });
  }


  Future<void> SignOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

}
