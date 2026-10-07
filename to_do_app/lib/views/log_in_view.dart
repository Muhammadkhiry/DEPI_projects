import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/cubits/user_cubit/user_cubit.dart';
import 'package:to_do_app/widgets/custom_button.dart';
import 'package:to_do_app/widgets/custom_text_field.dart';

// ignore: must_be_immutable
class LoginView extends StatelessWidget {
  LoginView({super.key});
  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "To Do app",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomTextField(
                controller: userNameController,
                label: "Enter your user name",
                icon: "assets/login.png",
              ),
            ),
            SizedBox(height: 15),
            CustomButton(
              label: "Login",
              onPressed: () {
                BlocProvider.of<UserCubit>(
                  context,
                ).saveUserName(userNameController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
