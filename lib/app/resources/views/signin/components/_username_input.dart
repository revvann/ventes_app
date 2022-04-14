part of 'package:ventes/app/resources/views/signin/signin.dart';

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
      hintText: SigninString.usernameHint,
      label: SigninString.usernameLabel,
      inputType: TextInputType.name,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return SigninString.usernameNotValid;
      },
    );
  }
}
