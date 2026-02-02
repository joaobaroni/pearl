import 'package:pearl/features/homes/domain/models/address_model.dart';

class SaveHomeParams {
  final String name;
  final AddressModel address;

  const SaveHomeParams({required this.name, required this.address});
}
