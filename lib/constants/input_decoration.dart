import 'package:flutter/material.dart';

//TextField tasarımları
class InputDecorators{

  final EmailInput = InputDecoration(
      contentPadding:
      EdgeInsets.only(right: 20, left: 20),
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
  );

  final PasswordInput = InputDecoration(
    contentPadding:
    EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: '••••••••',
    fillColor: Colors.white,
    filled: true,
  );

  final CreatePasswordInput = InputDecoration(
    contentPadding:
    EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: 'Şifre Oluştur',
    fillColor: Colors.white,
    filled: true,
  );

  final NameInput = InputDecoration(
    contentPadding:
    EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: 'Tam Adınızı Girin',
    fillColor: Colors.white,
    filled: true,
  );

  final PermissionStartInput = InputDecoration(
    contentPadding: EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: '01.01.2023',
    fillColor: Colors.white,
    filled: true,
  );

  final WorkStartInput = InputDecoration(
    contentPadding: EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: '10.01.2023',
    fillColor: Colors.white,
    filled: true,
  );

  final StatementInput = InputDecoration(
    contentPadding: EdgeInsets.only(right: 20, left: 20),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    hintText: 'Açıklama girebilirsiniz',
    fillColor: Colors.white,
    filled: true,
  );
}