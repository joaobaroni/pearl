import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/domain/models/asset_category.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/asset_template.dart';
import 'package:pearl/presentation/views/asset_form/asset_form_controller.dart';
import 'package:pearl/presentation/views/asset_form/enums/asset_form_step.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockAddAssetUseCase mockAddAsset;
  late MockUpdateAssetUseCase mockUpdateAsset;
  late MockSearchAssetTemplatesUseCase mockSearchTemplates;

  final sampleTemplates = [
    const AssetTemplate(
      name: 'Air Conditioner',
      category: AssetCategory.hvac,
      icon: IconData(0),
    ),
    const AssetTemplate(
      name: 'Solar Panel',
      category: AssetCategory.solar,
      icon: IconData(0),
    ),
  ];

  setUp(() {
    mockAddAsset = MockAddAssetUseCase();
    mockUpdateAsset = MockUpdateAssetUseCase();
    mockSearchTemplates = MockSearchAssetTemplatesUseCase();
  });

  Future<AssetFormController> createController({
    String homeId = 'home1',
    AssetModel? asset,
  }) async {
    when(() => mockSearchTemplates(any()))
        .thenAnswer((_) async => Right(sampleTemplates));

    final controller = AssetFormController(
      mockAddAsset,
      mockUpdateAsset,
      mockSearchTemplates,
      homeId,
      asset: asset,
    );
    // Wait for async _loadCatalog to complete
    await Future.delayed(Duration.zero);
    await Future.delayed(Duration.zero);
    return controller;
  }

  group('AssetFormController', () {
    test('isEditing returns false when asset is null', () async {
      final controller = await createController();

      expect(controller.isEditing, isFalse);
    });

    test('isEditing returns true when asset is provided', () async {
      final controller = await createController(asset: fakeAsset());

      expect(controller.isEditing, isTrue);
    });

    test('onInit loads catalog with empty query', () async {
      final controller = await createController();

      expect(controller.filteredCatalog.value.length, 2);
      verify(() => mockSearchTemplates('')).called(1);
    });

    test('selectAssetTemplate populates fields and changes step', () async {
      final controller = await createController();
      final template = sampleTemplates.first;

      controller.selectAssetTemplate(template);

      expect(controller.nameController.text, 'Air Conditioner');
      expect(controller.selectedCategory.value, AssetCategory.hvac);
      expect(controller.currentStep.value, AssetFormStep.details);
      expect(controller.selectedAssetTemplate.value, template);
    });

    test('goBackToCatalog sets step to catalog', () async {
      final controller = await createController();
      controller.selectAssetTemplate(sampleTemplates.first);

      controller.goBackToCatalog();

      expect(controller.currentStep.value, AssetFormStep.catalog);
    });

    test('currentStep starts at catalog when creating', () async {
      final controller = await createController();

      expect(controller.currentStep.value, AssetFormStep.catalog);
    });

    test('currentStep starts at details when editing', () async {
      final controller = await createController(asset: fakeAsset());

      expect(controller.currentStep.value, AssetFormStep.details);
    });

    test('dispose does not throw', () async {
      final controller = await createController();

      expect(() => controller.dispose(), returnsNormally);
    });
  });
}
