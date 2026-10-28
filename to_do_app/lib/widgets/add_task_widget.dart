import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/task_cubit/tasks_cubit.dart';
import '../models/task_model.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class AddTaskWidget extends StatefulWidget {
  final TaskModel? task; // null = add mode, non-null = edit mode
  const AddTaskWidget({super.key, this.task});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool get isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      titleController.text = widget.task!.title;
      dateController.text = widget.task!.date;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // دالة فتح التقويم واختيار التاريخ
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      firstDate: isEditing ? DateTime(2020) : DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff00A896), // لون التقويم المتناسق
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        // تنسيق التاريخ المختار ليصبح بالشكل YYYY-MM-DD
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isEditing ? "Edit Task" : "Add New Task",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // حقل عنوان المهمة
              CustomTextField(
                controller: titleController,
                label: "Task Title",
                icon: "assets/checklist.png",
                obscureText: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // حقل اختيار التاريخ بالضغط فقط
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    controller: dateController,
                    label: "Set Date",
                    icon: "assets/calendar.png",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Date is required";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // زر الحفظ
              CustomButton(
                label: isEditing ? "Update Task" : "Save Task",
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final cubit = context.read<TasksCubit>();
                    final rootContext =
                        Navigator.of(context, rootNavigator: true).context;
                    final title = titleController.text.trim();
                    final date = dateController.text.trim();

                    Navigator.pop(context);

                    if (isEditing) {
                      await cubit.editTask(widget.task!, title, date);
                    } else {
                      await cubit.addTask(TaskModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: title,
                        date: date,
                        isCompleted: false,
                      ));
                    }

                    if (rootContext.mounted) {
                      _showDoneDialog(
                        rootContext,
                        isEditing ? "the task is updated" : "the task is added",
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDoneDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (dialogContext.mounted) Navigator.of(dialogContext).pop();
        });
        return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xffE0F7FA),
              child: Icon(Icons.check, size: 35, color: Color(0xff00B4D8)),
            ),
            const SizedBox(height: 16),
            const Text(
              "Done!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      );
      },
    );
  }
}