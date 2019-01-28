import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

import '../model/patient.dart';
import '../model/dr.dart';
import '../model/rtn.dart';

mixin Connected on Model {
  List<Doctor> _doctor = [];
  Patient _authenticatedPatient;
  bool _isLoading = false;
  List<Doctor> get allDrs {
    return List.from(_doctor);
  }
}

mixin PatientModel on Connected {
  PublishSubject<bool> _patientSubject = PublishSubject();

  Patient get patient {
    return _authenticatedPatient;
  }

  PublishSubject<bool> get patientSubject {
    return _patientSubject;
  }

  Future<Map<String, dynamic>> authenticateFirst(String phone) async {
    try{
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authFirstData = {
      'Phone': phone,
    };
    http.Response response;
    response = await http.post(
      'http://guffy.ir/Auth/RegisterOne',
      body: json.encode(authFirstData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'خطایی پیش آمده است';
    print(responseData);
    if (responseData.containsKey("guid")) {
       hasError = false;
       RTN rtn = new RTN(
      msg : responseData["msg"],
      guid : responseData["guid"],
      obj : responseData["obj"],
      srcPath : responseData["srcPath"],
      success : responseData["success"],
      thumbPath : responseData["thumbPath"],);
      message = rtn.msg;
      // _authenticatedPatient = Patient(
      //   guid: responseData["guid"],
      //   phone: phone,
      //   token: null,
      //   name: null,
      //   lastName: null,
      // );
      // _patientSubject.add(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', '');
      prefs.setString('patientPhone', phone);
      prefs.setString('patientGuid', responseData['guid']);
      prefs.setString('name', '');
      prefs.setString('lastName', '');
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
  catch(error){
    _isLoading = false;
    print(error);
    return {'success': false};
  }}
  Future<Map<String, dynamic>> authenticateSecond(String code) async {
    _isLoading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> authSecondData = {
    "Code": code,
    "Guid": prefs.getString('patientGuid'),
    "Phone":prefs.getString('patientPhone'),
    };
    print(prefs.getString('patientPhone'));
    http.Response response;
    response = await http.post(
      'http://guffy.ir/Auth/RegisterTwo',
      body: json.encode(authSecondData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'خطایی پیش آمده است';
    print(responseData);
    if (responseData.containsKey('guid')) {
      hasError = false;
       RTN rtn = new RTN(
      msg : responseData["msg"],
      guid : responseData["guid"],
      obj : responseData["obj"]['token'],
      srcPath : responseData["srcPath"],
      success : responseData["success"],
      thumbPath : responseData["thumbPath"],);
      message = rtn.msg;
      // _authenticatedPatient = Patient(
      //   guid: responseData["guid"],
      //   phone: phone,
      //   token: null,
      //   name: null,
      //   lastName: null,
      // );
      // _patientSubject.add(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', rtn.obj);
      prefs.setString('name', null);
      prefs.setString('lastName', null);
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
    Future<Map<String, dynamic>> authenticateThird(String name , String lastName) async {
    _isLoading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final Map<String, dynamic> authThirdData = {
      'FirstName': name,
      'LastName': lastName
    };
    http.Response response;
    response = await http.post(
      'http://guffy.ir/Prof/EditPatientProfile',
      body: json.encode(authThirdData),
      headers: {'Content-Type': 'application/json',
      'Authorization' :
        'Bearer $token' ,}
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'خطایی پیش آمده است';
    print(responseData);
    if (responseData.containsKey('guid')) {
      
      hasError = false;
       RTN rtn = new RTN(
      msg : responseData["msg"],
      guid : responseData["guid"],
      obj : responseData["obj"],
      srcPath : responseData["srcPath"],
      success : responseData["success"],
      thumbPath : responseData["thumbPath"],);
      message = rtn.msg;
      final String patientPhone = prefs.getString('patientPhone');
      final String patientGuid = prefs.getString('patientGuid');
      _authenticatedPatient = Patient(
        guid: patientGuid,
        phone: patientPhone,
        token: token,
        name: name,
        lastName: lastName,
      );
      _patientSubject.add(true);
      
      prefs.setString('name', name);
      prefs.setString('lastName', lastName);
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  // end of authenticate -----------------------------------------


  Future<Map<String, dynamic>> sendAgain(String phone) async {
    try{
    _isLoading = true;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> authFirstData = {
      'Phone': prefs.getString('patientPhone'),
    };
    http.Response response;
    response = await http.post(
      'http://guffy.ir/Auth/RegisterOne',
      body: json.encode(authFirstData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    bool hasError = true;
    String message = 'خطایی پیش آمده است';
    print(responseData);
    if (responseData.containsKey("guid")) {
       hasError = false;
       RTN rtn = new RTN(
      msg : responseData["msg"],
      guid : responseData["guid"],
      obj : responseData["obj"],
      srcPath : responseData["srcPath"],
      success : responseData["success"],
      thumbPath : responseData["thumbPath"],);
      message = rtn.msg;
      // _authenticatedPatient = Patient(
      //   guid: responseData["guid"],
      //   phone: phone,
      //   token: null,
      //   name: null,
      //   lastName: null,
      // );
      // _patientSubject.add(true);
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('token', '');
      // prefs.setString('patientPhone', phone);
      // prefs.setString('patientGuid', responseData['guid']);
      // prefs.setString('name', '');
      // prefs.setString('lastName', '');
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }
  catch(error){
    _isLoading = false;
    print(error);
    return {'success': false};
  }}
  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name');
    final String lastName = prefs.getString('lastName');
    if (name != '' && lastName != '') {
      final String patientPhone = prefs.getString('patientPhone');
      final String patientGuid = prefs.getString('patientGuid');
      final String token = prefs.getString('token');
      _authenticatedPatient =
          Patient(guid: patientGuid, phone: patientPhone, token: token , name: name , lastName: lastName);
      _patientSubject.add(true);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedPatient = null;
    _patientSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('PatientEmail');
    prefs.remove('PatientId');
  }
}
mixin UtilityModel on Connected {
  bool get isLoading {
    return _isLoading;
  }
}
