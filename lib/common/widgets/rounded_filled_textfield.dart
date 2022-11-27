import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoundedFilledTextfield extends HookWidget {
  const RoundedFilledTextfield({
    Key? key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  final void Function(String)? onChanged;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final isObscure = useState<bool>(obscureText);

    return TextField(
      onChanged: onChanged,
      obscureText: isObscure.value,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            width: 0.0,
            style: BorderStyle.none,
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        suffixIcon: !obscureText
            ? null
            : IconButton(
                splashRadius: 20.0,
                onPressed: () {
                  isObscure.value = !isObscure.value;
                },
                icon: Icon(
                  isObscure.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                ),
              ),
      ),
    );
  }
}
