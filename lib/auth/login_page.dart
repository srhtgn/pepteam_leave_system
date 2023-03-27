import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pepteam_permission_system/auth/forgot_password_page.dart';
import 'package:pepteam_permission_system/auth/utils.dart';
import 'package:pepteam_permission_system/constants/image_items.dart';
import 'package:pepteam_permission_system/constants/input_decoration.dart';
import 'package:pepteam_permission_system/main.dart';
import 'package:pepteam_permission_system/view/home_page.dart';
import 'package:pepteam_permission_system/auth/register_page.dart';

//Giriş ekranı
class LoginPage extends StatefulHookConsumerWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(246, 246, 246, 1.0),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(SvgImage().logoIcon),
                        SizedBox(height: 15),
                        SvgPicture.asset(SvgImage().pepteamLogoIcon),
                        SizedBox(height: 15),
                        Text("İzin Portalı",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(50, 50, 50, 1.0)))),
                      ],
                    )),
                Expanded(
                    flex: 6,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text('Email'),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecorators().EmailInput,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (email) => email != null && ! EmailValidator.validate(email) //email adresi giriş doğrulaması
                                ? 'Enter a valid email' : null,
                          ),
                          SizedBox(height: 15),
                          Text('Şifre'),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecorators().PasswordInput,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 8 //Şifre doğrulaması
                                ? 'Enter min. 8 characters' : null,
                          ),
                          Spacer(),
                          Container(
                              width: double.maxFinite,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: Text('Şifremi Unuttum',
                                        style: GoogleFonts.inter(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    105, 65, 198, 1.0)))),
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordPage())),
                                  )
                                  ,
                                ],
                              )),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(127, 86, 217, 1),
                                  minimumSize: Size(double.maxFinite, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                signIn();
                              },
                              child: Text('Giriş Yap',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500)))),
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
                                Text('Google ile giriş yap',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                52, 64, 84, 1.0)))),
                              ],
                            ),
                          ),
                          Spacer(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Hesabınız yok mu?',
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(
                                              102, 112, 133, 1.0)))),
                              SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.push( //Kullanıcının hesabı yoksa kayıt sayfasına git
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()));
                                },
                                child: Text('Kaydol',
                                    style: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromRGBO(
                                                105, 65, 198, 1.0)))),
                              )
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));

  }
  Future signIn() async { //Girilen email ve şifre doğruysa ana sayfaya git yanlışsa hata mesajı göster
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword( //
          email: _email.text.trim(),
          password: _password.text.trim()).then((user) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()), //Ana ekrana geç  //Switch to main screen
                (Route<dynamic> route) => false);
      });
    }on FirebaseAuthException catch (e){
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
