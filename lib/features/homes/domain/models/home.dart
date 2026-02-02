import 'address.dart';
import 'asset.dart';

class Home {
  final String id;
  final String name;
  final Address address;
  final List<Asset> assets;
  final DateTime createdAt;

  const Home({
    required this.id,
    required this.name,
    required this.address,
    this.assets = const [],
    required this.createdAt,
  });
}
