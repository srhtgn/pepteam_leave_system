import 'package:flutter/material.dart';
import 'package:pepteam_permission_system/constants/image_items.dart';
import 'package:pepteam_permission_system/constants/text_styles.dart';
import 'package:pepteam_permission_system/view/home_page.dart';

//İzin gönderildi sayfası
class PermitRequestSent extends StatefulWidget {
  const PermitRequestSent({Key? key}) : super(key: key);

  @override
  State<PermitRequestSent> createState() => _PermitRequestSentState();
}

class _PermitRequestSentState extends State<PermitRequestSent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 12, left: 12),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(
            child: Image(image: NetImage().requestSent),
          ),
          Text('İzin Talebiniz Başarıyla Gönderildi', style: TextStyles().blue_w700_s16),
          SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(127, 86, 217, 1),
                  minimumSize: Size(double.maxFinite, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Ana Sayfaya Dön'))
        ],
      ),),
    );
  }
}
