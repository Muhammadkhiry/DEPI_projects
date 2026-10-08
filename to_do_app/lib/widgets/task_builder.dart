import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubits/task_cubit/tasks_cubit.dart';
import 'package:to_do_app/models/task_model.dart';
import 'package:to_do_app/widgets/add_task_widget.dart';

class TaskBuilder extends StatelessWidget {
  const TaskBuilder({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 31),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: taskModel.isDone,
            onChanged: (val) {
              BlocProvider.of<TasksCubit>(context).toggleTaskStatus(taskModel);
            },
            activeColor: const Color(0xFF00B4D8),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  taskModel.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),

                Text(
                  taskModel.date,
                  style: TextStyle(color: Colors.grey.shade900, fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 24),
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 35,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          'Delete this task?',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 7),

                        const Text(
                          'This action cannot be undone.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Color(0xFF00B4D8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 60,
                              child: VerticalDivider(
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),

                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  BlocProvider.of<TasksCubit>(
                                    context,
                                  ).deleteTask(taskModel.id);
                                  Navigator.pop(context);
                                  showSuccessDialog(
                                    context,
                                    message: 'The task is deleted',
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Image.asset("assets/trash.png", height: 30, width: 30),
          ),
        ],
      ),
    );
  }
}
