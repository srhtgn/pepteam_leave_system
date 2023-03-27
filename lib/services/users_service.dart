import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepteam_permission_system/model/permission_requests_model.dart';


class UsersService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot>? getSpecificUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: _auth.currentUser?.uid)
        .snapshots();
    return ref;
  }
}
