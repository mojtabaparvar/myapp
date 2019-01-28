import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
// import 'package:flutter/rendering.dart';

import './scoped_model/main_model.dart';
import './pages/authone.dart';
import './pages/main_page.dart';
import './widgets/ui_elements/colors.dart';
import './model/dr.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    FlutterStatusbarcolor.setStatusBarColor(CustomColors().abiPorrang);
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
    _model.patientSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'EasyList',
        theme: ThemeData(
          cursorColor: CustomColors().khakestari,
          primaryColor: CustomColors().abiPorrang,
          accentColor: CustomColors().abiKamrang,
          backgroundColor: Colors.white,
          fontFamily: 'IrYek',
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            body1: TextStyle(fontSize: 16.0, fontFamily: 'IrYek'),
          ),
        ),
        home: AuthOnePage(),
        // routes: {
        //   '/': (BuildContext context) =>
        //       !_isAuthenticated ? AuthOnePage() : MainPage(_model),
        // },
        // onGenerateRoute: (RouteSettings settings) {
        //   if (!_isAuthenticated) {
        //     return MaterialPageRoute<bool>(
        //       builder: (BuildContext context) => AuthOnePage(),
        //     );
        //   }
        //     final List<String> pathElements = settings.name.split('/');
        //     if (pathElements[0] != '') {
        //       return null;
        //     }
        //     if (pathElements[1] == 'doctor') {
        //       final String drGuid = pathElements[2];
        //       final Doctor doctor =
        //           _model.allDrs.firstWhere((Doctor doctor) {
        //         return doctor.guid == drGuid;
        //       });
        //       return MaterialPageRoute<bool>(
        //         builder: (BuildContext context) =>
        //             !_isAuthenticated ? AuthOnePage() : MainPage(_model),
        //       );
        //     }
        //     return null;
        //   },
        //   onUnknownRoute: (RouteSettings settings) {
        //     return MaterialPageRoute(
        //         builder: (BuildContext context) =>
        //             !_isAuthenticated ? AuthOnePage() : MainPage(_model));
        // },
      ),
    );
  }
}
