import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:snappio_frontend/constants/snackbar.dart';
import 'package:snappio_frontend/screens/chat_section.dart';
import 'package:snappio_frontend/screens/signup_page.dart';
import 'package:snappio_frontend/services/auth_services.dart';
import 'package:snappio_frontend/themes.dart';

import '../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static String _username = '';
  static String _password = '';
  final RoundedLoadingButtonController _controller = RoundedLoadingButtonController();

  void loginBtnPressed(BuildContext context) async {
    var res = AuthServices().loginUser(
      username: _username,
      password: _password,
    );
    if(await res){
      showSnackBar(context, "Login Successful");
      _controller.success();
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, ChatSection.routeName);
    } else {
      showSnackBar(context, "Error: User doesn't exists");
      _controller.error();
      await Future.delayed(const Duration(seconds: 2));
      _controller.reset();
    }
  }
  
  void signupTextPressed() =>
    Navigator.pushReplacementNamed(context, SignupPage.routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Image.asset("assets/images/login.png"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Welcome to Snappio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textScaleFactor: 2.4),
                      const SizedBox(height: 80),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.account_circle_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                          // filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15)),
                        onChanged: (value) => _username = value,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.verified_user),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          // filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                        ),
                        obscureText: true,
                        onChanged: (value) => _password = value,
                      ),
                    const SizedBox(height: 70),
                    RoundedLoadingButton(
                        controller: _controller,
                        onPressed: () => loginBtnPressed(context),
                        animateOnTap: true,
                        height: 54,
                        elevation: 3,
                        successColor: Colors.green,
                        color: Theme.of(context).cardColor,
                        child: const Text("Sign In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        InkWell(
                          onTap: signupTextPressed,
                          child: const Text(" Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Themes.darkAccent)),
                        ),
                      ],
                    ),
                  ],
                )),
            ],
            ),
          ),
        )
      );
  }
}
