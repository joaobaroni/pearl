import 'address_model.dart';
import 'asset_model.dart';

class HomeModel {
  final String id;
  final String name;
  final AddressModel address;
  final List<AssetModel> assets;
  final DateTime createdAt;

  const HomeModel({
    required this.id,
    required this.name,
    required this.address,
    this.assets = const [],
    required this.createdAt,
  });
}
