import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class NewTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.only(start: 20.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
        itemCount: tasks.length);
  }
}
