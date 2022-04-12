part of "package:ventes/views/schedule_form/create/schedule_fc.dart";

class _TitleInput extends StatelessWidget {
  _TitleInput({
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return RegularInput(
      controller: controller,
      label: "Title",
      hintText: "Enter title",
    );
  }
}
