class Validators {
  Validators._();

  static final _streetRegex = RegExp(r"^\d+[A-Za-z]?(?:-\d+)?\s+(?:[NSEW]\s+)?[A-Za-z0-9 .'-]+(?:\s+(?:Apt|Apartment|Unit|Ste|Suite|#)\s*\w[\w-]*)?$");
  static final _cityRegex = RegExp(r'^[a-zA-Z\s.\-]+$');
  static final _zipRegex = RegExp(r'^\d{5}(-\d{4})?$');

  static String? required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  static String? street(String? value) {
    if (value == null || value.trim().isEmpty) return 'Street address is required';
    if (!_streetRegex.hasMatch(value.trim())) return 'Enter a valid street (e.g. 123 Main St)';
    return null;
  }

  static String? city(String? value) {
    if (value == null || value.trim().isEmpty) return 'City is required';
    if (!_cityRegex.hasMatch(value.trim())) return 'Enter a valid city name';
    return null;
  }

  static String? zip(String? value) {
    if (value == null || value.trim().isEmpty) return 'ZIP code is required';
    if (!_zipRegex.hasMatch(value.trim())) return 'Enter a valid ZIP (e.g. 94105)';
    return null;
  }
}
