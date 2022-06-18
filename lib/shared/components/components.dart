import 'package:flutter/material.dart';

Widget defultTextField({
  required TextEditingController controller,
  required TextInputType type,
  required String text,
  required IconData prefixIcon,
  required Function validator,
  bool obscureText = false,
  IconData? suffixIcon,
  Function? onTap,
  Function(dynamic? val)? onSubmit,
  Function? onChange,
  Function? suffoxPressed,
  bool isClickable=true,
}) =>
    TextFormField(
        controller: controller,
        enabled: isClickable,
        keyboardType: type,
        onTap:() {return onTap!();},
        onFieldSubmitted: (s) {
        },
        onChanged: (s) {},
        validator: (value) {
          return validator(value);
        },
        obscureText: obscureText,
        decoration: InputDecoration(
          label: Text(text),
          border: OutlineInputBorder(),
          prefixIcon: Icon(
            prefixIcon,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    suffoxPressed!();
                  },
                  icon: Icon(
                    suffixIcon,
                  ),
                )
              : null,
        ));


Widget buildTaskItem(Map model)=> Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
children: [

CircleAvatar(
  radius: 40.0,
  child: Text('${model['time']}'),
),
SizedBox(width: 20.0,),
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
children: [
Text("${model['title']}",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
Text("${model['date']}",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.grey),),
],

),
],

      ),
    );