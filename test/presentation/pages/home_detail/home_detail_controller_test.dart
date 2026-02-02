import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/address_model.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/models/asset_category.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/models/us_state.dart';
import 'package:pearl/features/homes/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/presentation/controllers/home_detail_controller.dart';

class MockGetHomeByIdUseCase extends Mock implements GetHomeByIdUseCase {}

class MockDeleteAssetUseCase extends Mock implements DeleteAssetUseCase {}

void main() {
  late MockGetHomeByIdUseCase mockGetHomeById;
  late MockDeleteAssetUseCase mockDeleteAsset;
  late SubjectNotifier subjectNotifier;
  late HomeDetailController controller;

  HomeModel createTestHome() => HomeModel(
        id: '1',
        name: 'Test Home',
        address: const AddressModel(
          street: '123 Main St',
          city: 'Springfield',
          state: UsState.ca,
          zip: '90210',
        ),
        assets: [
          AssetModel(
            id: 'asset-1',
            name: 'Furnace',
            category: AssetCategory.hvac,
          ),
        ],
        createdAt: DateTime(2024, 1, 1),
      );

  setUp(() {
    mockGetHomeById = MockGetHomeByIdUseCase();
    mockDeleteAsset = MockDeleteAssetUseCase();
    subjectNotifier = SubjectNotifier();

    when(() => mockGetHomeById('1')).thenReturn(Right(createTestHome()));

    controller = HomeDetailController(
      mockGetHomeById,
      mockDeleteAsset,
      subjectNotifier,
      '1',
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('SubjectDispatcher integration', () {
    test('notifies Subject.home after successful asset deletion', () async {
      var notified = false;
      subjectNotifier.addListener(Subject.home, () => notified = true);

      when(() => mockDeleteAsset('1', 'asset-1'))
          .thenAnswer((_) async => const Right(null));

      await controller.deleteAsset('asset-1');

      expect(notified, isTrue);
    });

    test('does not notify Subject.home when asset deletion fails', () async {
      var notified = false;
      subjectNotifier.addListener(Subject.home, () => notified = true);

      when(() => mockDeleteAsset('1', 'asset-1')).thenAnswer(
        (_) async => const Left(StorageFailure('error')),
      );

      await controller.deleteAsset('asset-1');

      expect(notified, isFalse);
    });
  });

  group('deleteAsset', () {
    test('removes asset from local list without refetching', () async {
      when(() => mockDeleteAsset('1', 'asset-1'))
          .thenAnswer((_) async => const Right(null));

      // Reset to track calls after onInit
      reset(mockGetHomeById);

      await controller.deleteAsset('asset-1');

      expect(controller.home!.assets, isEmpty);
      verifyNever(() => mockGetHomeById(any()));
    });

    test('sets error on failure without removing asset', () async {
      when(() => mockDeleteAsset('1', 'asset-1')).thenAnswer(
        (_) async => const Left(StorageFailure('delete failed')),
      );

      await controller.deleteAsset('asset-1');

      expect(controller.home!.assets, hasLength(1));
      expect(controller.error, isA<StorageFailure>());
    });
  });
}
