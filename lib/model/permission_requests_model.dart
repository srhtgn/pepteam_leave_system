import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PermissionRequestsModel{
  late final String id;
  late final String requestStatus;
  late final String statement;
  late final String type;
  late final String name;
  late final int totalDaysOff;
  late final DateTime permissionStart;
  late final DateTime workStart;
  late final DateTime recordTime;

  PermissionRequestsModel({
    required this.id,
    required this.requestStatus,
    required this.statement,
    required this.type,
    required this.name,
    required this.totalDaysOff,
    required this.permissionStart,
    required this.workStart,
    required this.recordTime,
  });

  factory PermissionRequestsModel.fromSnapshot(DocumentSnapshot snapshot) {
    return PermissionRequestsModel(
      id: snapshot.id,
      requestStatus: snapshot['request status'],
      statement: snapshot['statement'],
      type: snapshot['type'],
      name: snapshot['username'],
      totalDaysOff: snapshot['total days off'],
      permissionStart: snapshot['permission start'],
        workStart: snapshot['work start'],
        recordTime: snapshot['recordTime']
    );
  }
}