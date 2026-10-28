import 'package:flutter/material.dart';

import '../../../../core/index.dart';
import '../../../../resources/generated/l10n.dart';
import '../login_view_model.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({
    required this.viewModel,
    required this.onPressLogin,
    super.key,
  });

  final LoginViewModel viewModel;
  final Function() onPressLogin;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Builder(
        builder: (context) => CustomTextFormField(
          hintText: S.current.enter_email,
          labelText: S.current.email,
          keyboardType: TextInputType.emailAddress,
          errorText: viewModel.listen(
            context,
            (value) => value.email.errorText(),
          ),
          onChanged: viewModel.onEmailChanged,
        ),
      ),
      const SizedBox(height: 8),
      Builder(
        builder: (context) => CustomTextFormField(
          hintText: S.current.enter_password,
          labelText: S.current.password,
          keyboardType: TextInputType.text,
          isPasswordField: true,
          errorText: viewModel.listen(
            context,
            (value) => value.password.errorText(),
          ),
          onChanged: viewModel.onPasswordChanged,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: viewModel.listen(context, (value) => value.isValidButton)
                ? onPressLogin
                : null,
            child: Text(S.current.login_button),
          ),
        ),
      ),
    ],
  );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.keyboardType,
    required this.onChanged,
    super.key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.isPasswordField = false,
    this.textInputAction = TextInputAction.done,
  });

  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
    ),
    textInputAction: textInputAction,
    obscureText: isPasswordField,
    onChanged: onChanged,
  );
}
