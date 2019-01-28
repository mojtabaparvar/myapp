//FIXME: size input / cursor width va position / ersale form va daryafte kod
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './main_page.dart';
import '../scoped_model/main_model.dart';
import '../widgets/ui_elements/colors.dart';

class AuthThreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthThreePageState();
  }
}

class _AuthThreePageState extends State<AuthThreePage> {
  final Map<String, dynamic> _formData = {
    'name': '',
    'lastName': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildNameTextField() {
    return Column(
      children: <Widget>[
        Container(
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
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.end,
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 22.0, color: CustomColors().khakestari),
                    decoration: InputDecoration(
                      filled: false,
                      isDense: true,
                      errorStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                      hintText: 'نام',
                      hintStyle: TextStyle(fontSize: 22.0),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'لطفا نام خود را وارد کنید';
                      }
                    },
                    onSaved: (String value) {
                      _formData['name'] = value;
                    },
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.contacts,
                  color: CustomColors().khakestari,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 22),
        Container(
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
                  style: TextStyle(
                      fontSize: 22.0, color: CustomColors().khakestari),
                  decoration: InputDecoration(
                    filled: false,
                    isDense: true,
                    errorStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    hintText: 'نام خانوادگی',
                    hintStyle: TextStyle(fontSize: 22.0),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'لطفا نام خانوادگی خود را وارد کنید';
                    }
                  },
                  onSaved: (String value) {
                    _formData['lastName'] = value;
                  },
                ),
              ),
              Container(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.phone_iphone,
                  color: CustomColors().khakestari,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitForm(Function authenticateThird) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation =
        await authenticateThird(_formData['name'], _formData['lastName']);
    if (successInformation['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MainPage();
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
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
            child: Column(
              children: <Widget>[
                Center(
                    child: Text(
                  'ورود / ثبت نام ',
                  style: TextStyle(fontSize: 40.0, fontFamily: 'IrYek'),
                )),
                SizedBox(height: MediaQuery.of(context).size.height / 7),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildNameTextField(),
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
                                      _submitForm(model.authenticateThird),
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
