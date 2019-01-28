import 'package:flutter/material.dart';

class RTN {
   String msg = '';
   bool success = false;
   String guid ='';
   String srcPath ='';
   String thumbPath ='';
   dynamic obj ='';

  RTN(
      {@required this.msg,
      @required this.guid,
      @required this.obj,
      @required this.srcPath,
      @required this.success,
      @required this.thumbPath});
}
