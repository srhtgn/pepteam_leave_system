import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable{
  Loginstate() {
    throw UnimplementedError();
  }

  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {
  LoginStateInitial();

  @override
  List<Object> get props => [];
}

class LoginStateLoading extends LoginState {
  LoginStateLoading();

  @override
  List<Object> get props => [];
}

class LoginStateSuccess extends LoginState {
  LoginStateSuccess();

  @override
  List<Object> get props => [];
}

class LoginStateError extends LoginState {
  late final String error;

  LoginStateError(String string);

  @override
  List<Object> get props => [];
}