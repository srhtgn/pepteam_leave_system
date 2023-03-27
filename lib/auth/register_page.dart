import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pepteam_permission_system/auth/utils.dart';
import 'package:pepteam_permission_system/constants/image_items.dart';
import 'package:pepteam_permission_system/main.dart';
import 'package:pepteam_permission_system/view/home_page.dart';
import 'package:pepteam_permission_system/auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  // final Function() onClickedLogin;
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 12, left: 12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kayıt Ol',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(16, 24, 40, 1.0),
                            fontWeight: FontWeight.w600,
                            fontSize: 20))),
                SizedBox(height: 30),
                Text('Tam Adınız',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(52, 64, 84, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14))),
                SizedBox(height: 5),
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 20, left: 20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Tam Adınızı girin',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 1
                      ? 'Enter a user name'
                      : null,
                ),
                SizedBox(height: 20),
                Text('Email',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(52, 64, 84, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14))),
                SizedBox(height: 5),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 20, left: 20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Email girin',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),

                SizedBox(height: 20),

                Text('Şifre',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(52, 64, 84, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14))),

                SizedBox(height: 5),

                TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: 20, left: 20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Şifre oluştur',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 8
                      ? 'Enter min. 8 characters'
                      : null,
                ),

                SizedBox(height: 5),

                Text('Minimum 8 karakter',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color.fromRGBO(102, 112, 133, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 14))),

                SizedBox(height: 25),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(127, 86, 217, 1),
                        minimumSize: Size(double.maxFinite, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    onPressed: () {
                      signUp();
                    },
                    child: Text('Kaydol',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)))),

                SizedBox(height: 15),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: Size(double.maxFinite, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(SvgImage().socialIcon),
                      SizedBox(width: 15),
                      Text('Google ile kaydol',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(52, 64, 84, 1.0)))),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabınız var mı?',
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(102, 112, 133, 1.0)))),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text('Giriş Yap',
                          style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(105, 65, 198, 1.0)))),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    var _userName = _name.text.trim();
    var _userEmail = _email.text.trim();
    var _userPassword = _password.text.trim();

    String? _role;
    String _statistics ;

    var _approvedLeaves = 0;
    var _deniedLeaves = 0;
    var _freeLeaves = 0;
    var _annualLeaveEntitlement = 30;

    var _leavesPendingApproval = 0;
    var _approvedLeavesForAdmin = 0;
    var _deniedLeavesForAdmin = 0;
    var _numberOfLeaveToday = 0;

    List state = [];
    if (_userEmail == 's@s.com') {
      _role = 'yönetici';
      _statistics = 'admin statistics';

      state = [
        _leavesPendingApproval,
        _approvedLeavesForAdmin,
        _deniedLeavesForAdmin,
        _numberOfLeaveToday
      ];
    } else {
      _role = 'çalışan';
      _statistics = 'employee statistics';

      state = [
        _approvedLeaves,
        _deniedLeaves,
        _freeLeaves,
        _annualLeaveEntitlement
      ];
    }

    if (!isValid) return;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword)
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(value.user!.uid)
            .set({
          'name': _userName,
          'role': _role,
          'email': _userEmail,
          _statistics : state,
          'id': value.user!.uid,
          'image': 'image',
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const HomePage()), //Ana ekrana geç  //Switch to main screen
            (Route<dynamic> route) => false);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
