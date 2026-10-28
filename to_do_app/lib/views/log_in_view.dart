import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_cubit/user_cubit.dart';
import '../cubit/user_cubit/user_states.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'home_view.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA), // خلفية هادئة ومريحة للعين
      body: BlocListener<UserCubit, UserStates>(
        listener: (context, state) {
          if (state is UserSuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeView()),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey, // تفعيل Form Key للتحقق
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "To Do App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00A896), // اللون الأساسي المتناسق
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your username to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // حقل إدخال الاسم مع Validation
                  CustomTextField(
                    controller: nameController,
                    label: "Enter your user name",
                    icon: "assets/login.png",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username cannot be empty"; // التنبيه عند عدم إدخال اسم
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // زر الدخول
                  CustomButton(
                    label: "Login",
                    onPressed: () {
                      // التحقق من صحة المدخلات قبل التقديم
                      if (formKey.currentState!.validate()) {
                        context.read<UserCubit>().saveUserProfile(
                              nameController.text.trim(),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}