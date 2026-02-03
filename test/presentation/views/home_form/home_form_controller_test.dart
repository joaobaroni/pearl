import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/domain/models/us_state.dart';
import 'package:pearl/presentation/views/home_form/home_form_controller.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockCreateHomeUseCase mockCreateHome;
  late MockUpdateHomeUseCase mockUpdateHome;

  setUp(() {
    mockCreateHome = MockCreateHomeUseCase();
    mockUpdateHome = MockUpdateHomeUseCase();
  });

  group('HomeFormController', () {
    test('isEditing returns false when home is null', () {
      final controller = HomeFormController(mockCreateHome, mockUpdateHome);

      expect(controller.isEditing, isFalse);
    });

    test('isEditing returns true when home is provided', () {
      final controller = HomeFormController(
        mockCreateHome,
        mockUpdateHome,
        home: fakeHome(),
      );

      expect(controller.isEditing, isTrue);
    });

    test('text controllers initialized empty when creating', () {
      final controller = HomeFormController(mockCreateHome, mockUpdateHome);

      expect(controller.nameController.text, '');
      expect(controller.streetController.text, '');
      expect(controller.cityController.text, '');
      expect(controller.zipController.text, '');
    });

    test('text controllers initialized with home values when editing', () {
      final home = fakeHome(
        name: 'Beach House',
        address: fakeAddress(
          street: '456 Ocean Ave',
          city: 'Malibu',
          state: UsState.ca,
          zip: '90210',
        ),
      );
      final controller = HomeFormController(
        mockCreateHome,
        mockUpdateHome,
        home: home,
      );

      expect(controller.nameController.text, 'Beach House');
      expect(controller.streetController.text, '456 Ocean Ave');
      expect(controller.cityController.text, 'Malibu');
      expect(controller.zipController.text, '90210');
    });

    test('selectedState defaults to UsState.ca when creating', () {
      final controller = HomeFormController(mockCreateHome, mockUpdateHome);

      expect(controller.selectedState.value, UsState.ca);
    });

    test('selectedState matches home address state when editing', () {
      final home = fakeHome(
        address: fakeAddress(state: UsState.ny),
      );
      final controller = HomeFormController(
        mockCreateHome,
        mockUpdateHome,
        home: home,
      );

      expect(controller.selectedState.value, UsState.ny);
    });

    test('dispose does not throw', () {
      final controller = HomeFormController(mockCreateHome, mockUpdateHome);

      expect(() => controller.dispose(), returnsNormally);
    });
  });
}
