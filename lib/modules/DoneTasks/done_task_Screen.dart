

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/status.dart';
import 'package:flutter/material.dart';
class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {} ,
      builder: (context,state){
        var tasks =AppCubit.get(context).donetasks;
        return tasksBuilder(tasks: tasks);
      },
    );

  }
}