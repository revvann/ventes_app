class ProspectCompetitorFormUpdateValidator {
  String? comptname(String? value) {
    if (value == null) {
      return 'Competitor name is required';
    }

    if (value.isEmpty) {
      return 'Competitor name is required';
    }

    return null;
  }

  String? comptproductname(String? value) {
    if (value == null) {
      return 'Product name is required';
    }

    if (value.isEmpty) {
      return 'Product name is required';
    }

    return null;
  }
}
