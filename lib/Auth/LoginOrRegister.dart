import 'package:flutter/material.dart';
import 'package:register/Pages/Login.dart';
import 'package:register/Pages/Register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => LoginOrRegisterState();
}

class LoginOrRegisterState extends State<LoginOrRegister>{

  bool showLoginPage = true;

  void switchPages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context){
    if(showLoginPage){
      return Login(
          switchPages: switchPages,
      );
    }else{
      return Register(
          switchPages: switchPages,
      );
    }
  }
}