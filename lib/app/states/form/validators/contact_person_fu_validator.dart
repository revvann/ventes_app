class ContactPersonFormUpdateValidator {
  String? contactvalue(String? value) {
    if (value == null || value.isEmpty) {
      return "Contact value is required";
    }
    return null;
  }
}
