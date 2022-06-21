import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/home_layout.dart';
import 'package:todo/shared/block_Observer.dart';
import 'package:todo/shared/cubit/cubit.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
            create: (context) => AppCubit()..createDataBase())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: HomeLayout(),
      ),
    );
  }
}
