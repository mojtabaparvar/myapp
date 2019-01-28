import 'package:flutter/material.dart';
import '../scoped_model/main_model.dart';

class MainPage extends StatefulWidget {
  // final MainModel model;
  // MainPage(this.model);
  @override
  State<StatefulWidget> createState() {

    return _mainPageState();
  }
}

class  _mainPageState extends State<MainPage> {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(child: Text('saloom'),),
      );
    }
}
