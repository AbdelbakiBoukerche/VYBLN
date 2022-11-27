import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:vybln/common/services/rsa_service.dart';

import '../../../common/extensions/email_ext.dart';
import '../../../common/extensions/fullname_ext.dart';
import '../../../common/extensions/password_ext.dart';
import '../../../common/extensions/username_ext.dart';
import '../../../common/widgets/rounded_filled_textfield.dart';
import '../../../core/constants.dart';
import '../../../core/injection_container.dart';
import '../../../core/routing/app_router.dart';
import '../blocs/signup/signup_bloc.dart';
import '../repositories/auth_repository.dart';

class SignupScreen extends StatelessWidget {
  static const String sPath = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => SignupBloc(
        authRepository: sl<AuthRepository>(),
        rsaService: sl<RSAService>(),
      ),
      child: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state.mStatus.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.mError ?? "Signup Failed")),
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
                  const SizedBox(height: 16.0),
                  const _FullnameInput(),
                  const SizedBox(height: 16.0),
                  const _UsernameInput(),
                  const SizedBox(height: 16.0),
                  const _PasswordInput(),
                  const SizedBox(height: 24.0),
                  const _SignupButton(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member? ',
                        style: textTheme.caption,
                      ),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go(AppRouter.sSigninPath);
                        },
                        child: Text(
                          'Sign In now',
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

class _SignupButton extends StatelessWidget {
  const _SignupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupBloc>();

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.mStatus != current.mStatus,
      builder: (context, state) {
        if (state.mStatus.isSubmissionInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: state.mStatus.isInvalid
              ? null
              : () => bloc.add(SignupSubmitted()),
          child: const Text('SIGN UP'),
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
    final bloc = context.read<SignupBloc>();

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.mPassword != current.mPassword,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SignupPasswordChanged(value)),
          hintText: 'Enter your Password',
          obscureText: true,
          errorText:
              state.mPassword.invalid ? state.mPassword.error?.text() : null,
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupBloc>();

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.mUsername != current.mUsername,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SignupUsernameChanged(value)),
          hintText: 'Enter your Username',
          errorText:
              state.mUsername.invalid ? state.mUsername.error?.text() : null,
        );
      },
    );
  }
}

class _FullnameInput extends StatelessWidget {
  const _FullnameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupBloc>();

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.mFullname != current.mFullname,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SignupFullnameChanged(value)),
          hintText: 'Enter your Full Name',
          errorText:
              state.mFullname.invalid ? state.mFullname.error?.text() : null,
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
    final bloc = context.read<SignupBloc>();

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.mEmail != current.mEmail,
      builder: (context, state) {
        return RoundedFilledTextfield(
          onChanged: (value) => bloc.add(SignupEmailChanged(value)),
          keyboardType: TextInputType.emailAddress,
          hintText: 'Enter your Email',
          errorText: state.mEmail.invalid ? state.mEmail.error?.text() : null,
        );
      },
    );
  }
}
