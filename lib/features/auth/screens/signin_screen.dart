import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../../common/extensions/email_ext.dart';
import '../../../common/extensions/password_ext.dart';
import '../../../common/widgets/rounded_filled_textfield.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../../core/routing/app_router.dart';
import '../blocs/signin/signin_bloc.dart';
import '../repositories/auth_repository.dart';

class SigninScreen extends StatelessWidget {
  static const String sPath = '/signin';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => SigninBloc(
        authRepository: sl<AuthRepository>(),
      ),
      child: BlocListener<SigninBloc, SigninState>(
        listener: (context, state) {
          if (state.mStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.mError ?? "Login Failed")),
              );
          }
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: kScaffoldPaddingHoriz * 2,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(
                    'assets/logo/logo.svg',
                    width: 80.0,
                    height: 80.0,
                  ),
                  const SizedBox(height: 48.0),
                  const _EmailInput(),
                  const SizedBox(height: 12.0),
                  const _PasswordInput(),
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot password?',
                        style: textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const _SigninButton(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: textTheme.caption,
                      ),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.sSignupPath);
                        },
                        child: Text(
                          'Sign Up now',
                          style: textTheme.caption?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
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

class _SigninButton extends StatelessWidget {
  const _SigninButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SigninBloc>();

    return BlocBuilder<SigninBloc, SigninState>(
      buildWhen: (previous, current) => previous.mStatus != current.mStatus,
      builder: (context, state) {
        if (state.mStatus.isSubmissionInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: state.mStatus.isInvalid
              ? null
              : () => bloc.add(SigninSubmitted()),
          child: const Text('Sign In'),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SigninBloc>();

    return BlocBuilder<SigninBloc, SigninState>(
      buildWhen: (previous, current) => previous.mPassword != current.mPassword,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SigninPasswordChanged(value)),
          obscureText: true,
          hintText: 'Enter your Password',
          errorText:
              state.mPassword.invalid ? state.mPassword.error?.text() : null,
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SigninBloc>();

    return BlocBuilder<SigninBloc, SigninState>(
      buildWhen: (previous, current) => previous.mEmail != current.mEmail,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SigninEmailChanged(value)),
          keyboardType: TextInputType.emailAddress,
          hintText: 'Enter your Email',
          errorText: state.mEmail.invalid ? state.mEmail.error?.text() : null,
        );
      },
    );
  }
}
