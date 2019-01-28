import 'package:flutter/material.dart';

class Patient {
  final String guid;
  final String phone;
  final String token;
  final String name;
  final String lastName;

  Patient({@required this.guid, @required this.phone, @required this.token , @required this.name , @required this.lastName });
}