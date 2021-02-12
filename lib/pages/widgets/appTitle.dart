import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Apptitle(String title, String subtitle,double titleFont,double subFont,){
  return RichText(text:TextSpan(text: title,style: TextStyle(color: Colors.lightBlueAccent,fontSize: titleFont,fontWeight: FontWeight.bold),
  children: [
    TextSpan(
        text:subtitle,style: TextStyle(color: Colors.black,fontSize: subFont)
    )
  ]
  )

  );
}