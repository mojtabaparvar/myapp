//FIXME: ezafe kardane ersale mojadad va hamintor thalle moshkele namayesh nadadane shomare
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './auththree.dart';
import '../scoped_model/main_model.dart';
import '../widgets/ui_elements/colors.dart';
import './authone.dart';

class AuthTwoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthTwoPageState();
  }
}

class _AuthTwoPageState extends State<AuthTwoPage> {
  String _patientPhone;
  bool _buttonIsDisabled;
  static const timeout = const Duration(seconds: 120);
  @override
  void initState() {
    _buttonIsDisabled = true;
  }
//   startTimeout([int seconds]) {
//   var duration = seconds == null ? timeout : ms * seconds;
//   return new Timer(duration, handleTimeout);
// }

  Widget showSendAgain() {
    if (_buttonIsDisabled) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            child: Text('60 ثانیه تا ارسال مجدد کد'),
          ),);
    }
    else{
      return ScopedModelDescendant<MainModel>(
                          builder: (BuildContext context, Widget child,
                              MainModel model) {
                            return model.isLoading
                                ? CircularProgressIndicator()
                                : RawMaterialButton(
                                    highlightElevation: 40,
                                    onPressed: () =>
                                        model.sendAgain,
                                    splashColor: Colors.white,
                                    shape: StadiumBorder(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xff4b66ea),
                                              Color(0xff4b66ea),
                                              Color(0xff4b66ea),
                                              Colors.blue
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 1.5),
                                              blurRadius: 1.5,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      width: MediaQuery.of(context).size.width /
                                          1.05,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              15,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 20.0),
                                          child: Text(
                                            'ورود / ثبت نام',
                                            style: TextStyle(
                                                fontFamily: 'IrBold',
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        );
    }
  }

  Future<void> getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String patientPhone = await prefs.getString('patientPhone');
    print(patientPhone);

    setState(() => _patientPhone = patientPhone);
  }

  final Map<String, dynamic> _formData = {
    'code': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildCodeTextField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.05,
      height: MediaQuery.of(context).size.height / 16,
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors().khakestariKamrang),
        color: Colors.transparent,
        borderRadius: new BorderRadius.all(
          const Radius.circular(40.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.end,
              autofocus: true,
              style:
                  TextStyle(fontSize: 22.0, color: CustomColors().khakestari),
              decoration: InputDecoration(
                filled: false,
                isDense: true,
                errorStyle: TextStyle(
                  fontSize: 15.0,
                ),
                hintText: 'کد تایید را وارد کنید',
                hintStyle: TextStyle(fontSize: 22.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
              onSaved: (String value) {
                _formData['code'] = value;
              },
            ),
          ),
          Container(
            width: 50,
            height: 50,
            child: Icon(
              Icons.confirmation_number,
              color: CustomColors().khakestari,
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm(Function authenticateSecond) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticateSecond(_formData['code']);
    if (successInformation['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return AuthThreePage();
      }));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('خطایی رخ داد'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('خیلی خوب'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _patientPhone;
    Future<void> getPhone() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String patientPhone =  prefs.getString('patientPhone');
      print(patientPhone);

      setState(() => _patientPhone = patientPhone);
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
            child: Column(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _patientPhone != null
                      ? Text(
                          'لطفا کد ارسال شده به شماره ' +
                              '$_patientPhone' +
                              'را وارد کنید',
                          style: TextStyle(fontSize: 30.0, fontFamily: 'IrYek'),
                        )
                      : Container(),
                ),
                FlatButton.icon(
                  icon: Icon(
                    Icons.edit,
                    textDirection: TextDirection.rtl,
                  ),
                  label: Text(
                    'ویرایش شماره',
                    textDirection: TextDirection.rtl,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthOnePage()),
                    );
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 7),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildCodeTextField(),
                      SizedBox(
                        height: 50.0,
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return model.isLoading
                              ? CircularProgressIndicator()
                              : RawMaterialButton(
                                  highlightElevation: 40,
                                  onPressed: () =>
                                      _submitForm(model.authenticateSecond),
                                  splashColor: Colors.white,
                                  shape: StadiumBorder(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color(0xff4b66ea),
                                            Color(0xff4b66ea),
                                            Color(0xff4b66ea),
                                            Colors.blue
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 1.5),
                                            blurRadius: 1.5,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    width: MediaQuery.of(context).size.width /
                                        1.05,
                                    height:
                                        MediaQuery.of(context).size.height / 15,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 20.0),
                                        child: Text(
                                          'ورود / ثبت نام',
                                          style: TextStyle(
                                              fontFamily: 'IrBold',
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
