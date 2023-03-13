import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/conroller/cubit_states.dart';
import 'package:to_do_app/view/task.dart';

import '../conroller/cubit.dart';
import 'constant.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ListView.separated(
              itemBuilder: (context, index) =>
                  Task(model: AppCubit.get(context).tasks[index]),
              separatorBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                );
              },
              itemCount: AppCubit.get(context).tasks.length);
        });
  }
}
