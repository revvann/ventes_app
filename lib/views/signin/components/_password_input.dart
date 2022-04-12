part of 'package:ventes/views/signin/signin.dart';

class _PasswordInput extends StatelessWidget {
  _PasswordInput({required this.controller});
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return RegularInput(
      maxLines: 1,
      controller: controller,
      hintText: "Enter your password",
      label: "Password",
      isPassword: true,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (value.length >= 6) {
            return null;
          }
          return "Password must be at least 6 characters";
        }
        return "Password can't be empty";
      },
    );
  }
}
