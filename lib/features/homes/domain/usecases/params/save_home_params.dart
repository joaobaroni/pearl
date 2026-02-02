import 'package:pearl/features/homes/domain/models/address.dart';

class SaveHomeParams {
  final String name;
  final Address address;

  const SaveHomeParams({required this.name, required this.address});
}
