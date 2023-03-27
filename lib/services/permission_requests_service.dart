import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pepteam_permission_system/model/permission_requests_model.dart';


class PermissionRequestsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addData(
    int totalDaysOff,
    String requestStatus,
    String statement,
    String type,
    String name,
    DateTime recordTime,
    DateTime permissionStart,
    DateTime workStart,
  ) async {
    var ref = _firestore.collection('PermissionRequests');

    var documentRef = await ref.add({
      'userId': _auth.currentUser?.uid,
      'total days off' : totalDaysOff,
      'request status': requestStatus,
      'record time' : recordTime,
      'type': type,
      'name': name,
      'statement': statement,
      'permission start': permissionStart,
      'work start': workStart
    });

    return PermissionRequestsModel(
        id: documentRef.id,
        requestStatus: requestStatus,
        statement: statement,
        recordTime: recordTime,
        type: type,
        name : name,
        totalDaysOff: totalDaysOff,
        permissionStart: permissionStart,
        workStart: workStart);
  }

  Stream<QuerySnapshot>? getPermissionRequestsForEmployee() {
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('PermissionRequests')
        .where('userId', isEqualTo: _auth.currentUser?.uid)
        // .orderBy('record time', descending: true)
        .snapshots();
    return ref;
  }

  Stream<QuerySnapshot>? getPermissionRequestsForAdmin() {
    Stream<QuerySnapshot<Map<String, dynamic>>> ref = FirebaseFirestore.instance
        .collection('PermissionRequests')
        .orderBy('record time', descending: true)
        .snapshots();
    return ref;
  }

  Future removeStatus(String docId) {
    var ref = _firestore.collection('PermissionRequests').doc(docId).delete();
    return ref;
  }
}
