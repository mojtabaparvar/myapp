import 'package:flutter/material.dart';

class Doctor {
  final String guid;
  final String phone;
  final String name;
  final String lastName;

  Doctor(
      {@required this.guid,
      @required this.phone,
      @required this.name,
      @required this.lastName});
}
