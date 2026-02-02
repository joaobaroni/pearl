import 'us_state.dart';

class AddressModel {
  final String street;
  final String city;
  final UsState state;
  final String zip;

  const AddressModel({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  String get formatted {
    final parts = [street, city, '${state.abbreviation} $zip'.trim()];
    return parts.where((p) => p.isNotEmpty).join(', ');
  }
}
