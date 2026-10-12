import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubit/user_cubit/user_cubit.dart';
import 'package:to_do_app/cubit/user_cubit/user_states.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserStates>(
      listener: (context, state) {
        if (state is UserErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "To Do App Login",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: userNameController,
                  label: "Enter your user name",
                  icon: "assets/login.png",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: passwordController,
                  label: "Enter your password",
                  icon: "assets/login.png",
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: "Login / Register",
                  onPressed: () {
                    BlocProvider.of<UserCubit>(context).loginOrRegister(
                      userNameController.text,
                      passwordController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
