import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

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


Widget buildTaskItem(Map model,context)=> Dismissible(

  key:Key(model['id'].toString()),
  onDismissed:(direction) {
AppCubit.get(context).deleteData(id: model['id']);

  },
  child:   Padding(
  
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
  children: [
  
  
  
  CircleAvatar(
  
    radius: 40.0,
  
    child: Text('${model['time']}'),
  
  ),
  
  SizedBox(width: 20.0,),
  
  Expanded(
  
    child:   Column(
  
    
  
      crossAxisAlignment: CrossAxisAlignment.start,
  
    
  
      mainAxisSize: MainAxisSize.min,
  
    
  
    children: [
  
    
  
    Text("${model['title']}",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
  
    
  
    Text("${model['date']}",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.grey),),
  
    
  
    ],
  
    
  
    
  
    
  
    ),
  
  ),
  
  SizedBox(width: 20.0,),
  
  IconButton(onPressed: (){
  
  AppCubit.get(context).updataData(status:'done', id: model['id']);
  
  
  
  }, icon:Icon(Icons.done,color: Colors.green,) ),
  
  IconButton(onPressed: (){AppCubit.get(context).updataData(status: 'archive', id: model['id']);}, icon:Icon(Icons.archive,color: Colors.grey,) ),
  
  
  
  ],
  
  
  
        ),
  
      ),
);


Widget tasksBuilder({required List<Map> tasks})=>ConditionalBuilder(
       condition: tasks.length>0,
          builder: (context)=> ListView.separated(
            itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
            separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
                ),
            itemCount: tasks.length),
            fallback: (context)=>Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Icon(Icons.menu,size: 100.0,color: Colors.grey,),
                Text('No Task Yet , Please Add Some tasks',style: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold),)
              ],),
            ),
       
        );