//FIXME: size input / cursor width va position / ersale form va daryafte kod
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './authtwo.dart';
import '../scoped_model/main_model.dart';
import '../widgets/ui_elements/colors.dart';

class AuthOnePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthOnePageState();
  }
}

class _AuthOnePageState extends State<AuthOnePage> {
  final Map<String, dynamic> _formData = {
    'phone': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildPhoneTextField() {
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
          Text(
            ' +98',
            style: TextStyle(fontSize: 22.0 , color: CustomColors().khakestari),
          ),
          SizedBox(
            width: 1.0,
          ),
          VerticalDivider(
            indent: 8.0,
          ),
          SizedBox(width: 4.0),
          Expanded(
            child: TextFormField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.end,
              autofocus: true,
              style: TextStyle(fontSize: 22.0 , color: CustomColors().khakestari),
              decoration: InputDecoration(
                filled: false,
                isDense: true,
                errorStyle: TextStyle(fontSize: 15.0 ,),
                hintText: 'شماره تلفن',
                hintStyle: TextStyle( fontSize: 22.0),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
              validator: (String value) {
                if (value.isEmpty ||
                    value.length < 10 ||
                    !RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$")
                        .hasMatch(value)) {
                  return 'لطفا یک شماره تلفن معتبر وارد کنید';
                }
              },
              onSaved: (String value) {
                _formData['phone'] = value;
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
    );
  }

  void _submitForm(Function authenticateFirst) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await authenticateFirst(_formData['phone']);
    if (successInformation['success']) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return AuthTwoPage();
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
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.5),
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text(
                    'ورود / ثبت نام ',
                    style:
                        TextStyle(fontSize: 40.0, fontFamily: 'IrYek'),
                  )),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildPhoneTextField(),
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
                                        _submitForm(model.authenticateFirst),
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
