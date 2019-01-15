import 'package:flutter/material.dart';
import '../../mixins/validation_mixin.dart';
import '../../widgets/overscrollDisableWidget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../graphql/mutations.dart';
import '../home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> with ValidateMixing {
  final formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(25, 40, 25, 0),
        child: Form(
          key: formKey,
          child: OverScrollDisable(
            child: SingleChildScrollView(
              child: mainColumnWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainColumnWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(margin: EdgeInsets.only(top: 35)),
        welcomeTextWidget(),
        Container(margin: EdgeInsets.only(top: 5)),
        continueTextWidget(),
        Container(margin: EdgeInsets.only(top: 75)),
        emailFieldWidget(),
        Container(margin: EdgeInsets.only(top: 25)),
        passwordFieldWidget(),
        Container(margin: EdgeInsets.only(top: 45)),
        Align(
          alignment: Alignment.centerRight,
          child: submitButtonWidget(),
        ),
      ],
    );
  }

  Widget welcomeTextWidget() {
    return Text(
      'Welcome',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget continueTextWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        'Sign in to continue',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget emailFieldWidget() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email',
        hintText: 'example@mail.com',
      ),
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      validator: validateEmail,
      onSaved: (email) {
        this.email = email;
      },
    );
  }

  Widget passwordFieldWidget() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: validatePassword,
      onSaved: (String password) {
        this.password = password;
      },
    );
  }

  Widget submitButtonWidget() {
    return Mutation(
      loginMutation,
      builder: (runMutation, {loading, error, data}) {
        return MaterialButton(
          minWidth: 400,
          height: 45,
          color: Colors.pinkAccent,
          child: Text('Login', style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
              print('My email is $email and password is $password');
              runMutation({'email': email, 'password': password});
            }
          },
        );
      },
      onCompleted: (Map<String, dynamic> data) async {
        final Map loginData = data['login'];
        print("from graphql login" + loginData['id'].toString());
        if (loginData['id'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('UID', loginData['id']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                    uid: loginData['id'],
                    admin: loginData['admin'],
                  ),
            ),
          );
        }
      },
    );
  }
}
