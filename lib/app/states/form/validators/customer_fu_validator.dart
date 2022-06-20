class CustomerFormUpdateValidator {
  String? cstmname(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
  }

  String? cstmphone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone cannot be empty';
    }
  }

  String? cstmaddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
  }
}
