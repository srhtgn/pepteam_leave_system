import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pepteam_permission_system/auth/utils.dart';
import 'package:pepteam_permission_system/constants/input_decoration.dart';

// Şifre sıfırlama ekranı
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose(){
    _email.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Şifreyi Değiştir'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 12, left: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorators().EmailInput,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && ! EmailValidator.validate(email) //email adresi giriş doğrulaması
                    ? 'Enter a valid email' : null,
              ),

              SizedBox(height: 20,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(127, 86, 217, 1),
                      minimumSize: Size(double.maxFinite, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    resetPassword();
                  },
                  child: Text('Şifreyi Değiştir',
                      style: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500)))),
            ],
          ),
        ),
      ),
    );
  }
  Future resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail( //Girilen email adresine şifre sıfırlama emaili gönder
          email: _email.text.trim());

      Utils.showSnackBar('Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
