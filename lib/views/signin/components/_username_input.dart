part of 'package:ventes/views/signin/signin.dart';

class _UsernameInput extends StatelessWidget {
  _UsernameInput({
    required this.controller,
  });
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return RegularInput(
      maxLines: 1,
      controller: controller,
      hintText: "Enter your username",
      label: "Username",
      inputType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return "Username can't be empty";
      },
    );
  }
}
