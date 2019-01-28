import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String placeholder;
  final IconData icon;
  final bool hasPrefix;
  final direction;
  final double width;

  CustomInput({
    @required this.direction,
    @required this.placeholder,
    @required this.icon,
    @required this.hasPrefix,
    @required this.width,
  });

  @override
  CustomInputState createState() => new CustomInputState();
}

class CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.end,
                    textDirection: widget.direction,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hasFloatingPlaceholder: true,
                      prefix: widget.hasPrefix ? Text('+98'): null,
                    ), 
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: Icon(
                    widget.icon,
                    color: Color(0xff969696),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
