import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vybln/logic/login/login_cubit.dart';
import 'package:vybln/presentation/utils/vybln_colors.dart';

import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            LoginCubit(context.repository<AuthenticationRepository>()),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Authentication Failed")),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 52.0),
              child: Image(
                image: AssetImage("assets/images/vybln.png"),
                height: MediaQuery.of(context).size.height * 0.18,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(
                "VYBLN",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 12,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(
                "Be Part Of The Community",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            _EmailTextField(),
            _PasswordTextField(),
            RectangularGreenButton(),
            _SignUpButtton(),
          ],
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 56.0),
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.email != current.email,
        builder: (context, state) {
          return TextField(
            onChanged: (email) =>
                context.bloc<LoginCubit>().emailChanged(email),
            key: const Key('loginForm_email_textField'),
            cursorColor: kGreenLight,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.55),
              ),
              errorText: state.email.invalid ? 'Invalid Email' : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenLight,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenDark,
                  width: 0.75,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (previous, current) => previous.password != current.password,
        builder: (context, state) {
          return TextField(
            onChanged: (password) =>
                context.bloc<LoginCubit>().passwordChanged(password),
            key: const Key('loginForm_password_textField'),
            cursorColor: kGreenLight,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.55),
              ),
              errorText: state.password.invalid ? 'Invalid Password' : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenLight,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kGreenDark,
                  width: 0.75,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RectangularGreenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return CircularProgressIndicator(
            backgroundColor: kGreenLight,
          );
        } else {
          return Container(
            margin: EdgeInsets.only(top: 24.0, bottom: 8.0),
            height: 40,
            width: 116,
            child: RaisedButton(
              color: kGreenLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  letterSpacing: 1,
                ),
              ),
              onPressed: state.status.isValidated
                  ? () => context.bloc<LoginCubit>().logInWithCredentials()
                  : null,
            ),
          );
        }
      },
    );
  }
}

class _SignUpButtton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      key: const Key('loginForm_signup_flatButton'),
      child: Text(
        "Create Account",
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      onPressed: () => Navigator.of(context).push<void>(SignUpScreen.route()),
    );
  }
}
