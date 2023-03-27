// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pepteam_permission_system/providers/auth_provider.dart';
// import 'package:pepteam_permission_system/viewmodel/login_state.dart';
// import 'package:flutter/material.dart';
//
// class LoginController extends StateNotifier<LoginState> {
//   LoginController(this.ref) : super(LoginStateInitial());
//
//   final Ref ref;
//
//   void Login(String email, String password) async {
//     state = LoginStateLoading();
//
//     try{
//       await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
//         email,
//         password
//       );
//       state = LoginStateSuccess();
//     }catch (e){
//       state = LoginStateError(e.toString());
//     }
//
//   }
//   void signOut() async {
//     await ref.read(authRepositoryProvider).signOut();
//   }
// }
//
// final loginControllerProvider =
// StateNotifierProvider<LoginController, LoginState>((ref) {
//   return LoginController(ref);
// });