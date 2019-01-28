import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VButton extends StatelessWidget {
  VButton({
    @required this.onPressed,
    @required this.text,
    @required this.color,
    @required this.width,
  });

  final width;
  final GestureTapCallback onPressed;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      highlightElevation: 40,
      onPressed: onPressed,
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
            borderRadius: BorderRadius.circular(40)),
        width: width,
        height: 55.0,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Text(
              text,
              style:
                  TextStyle(fontFamily: 'IrBold', color: color, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
