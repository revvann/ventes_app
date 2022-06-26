// ignore_for_file: prefer_const_constructors

part of 'package:ventes/app/resources/views/chat_room/chat_room.dart';

class _ChatInput extends StatelessWidget {
  _ChatInput({
    Key? key,
    this.label,
    this.isPassword = false,
    this.inputType,
    this.validator,
    this.controller,
    this.hintText,
    this.value,
    this.enabled,
    this.maxLines,
    this.minLines,
    this.inputFormatters,
  }) : super(key: key);
  String? label;
  String? hintText;
  String? value;
  bool? enabled;
  bool isPassword;
  int? maxLines;
  int? minLines;
  TextInputType? inputType;
  String? Function(String?)? validator;
  TextEditingController? controller;
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          key: _key,
          maxLines: maxLines,
          minLines: minLines,
          initialValue: value,
          enabled: enabled,
          controller: controller,
          keyboardType: inputType,
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          validator: validator,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 16,
            color: RegularColor.dark,
          ),
          onChanged: (value) {
            _key.currentState?.validate();
          },
          onFieldSubmitted: (value) {
            _key.currentState?.validate();
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: RegularColor.gray,
            ),
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ],
    );
  }
}
