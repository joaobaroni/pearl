import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/features/homes/domain/models/address_model.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/models/us_state.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/features/homes/presentation/controllers/homes_list_controller.dart';

class MockGetHomesUseCase extends Mock implements GetHomesUseCase {}

class MockDeleteHomeUseCase extends Mock implements DeleteHomeUseCase {}

class MockGetHomeByIdUseCase extends Mock implements GetHomeByIdUseCase {}

void main() {
  late MockGetHomesUseCase mockGetHomes;
  late MockDeleteHomeUseCase mockDeleteHome;
  late MockGetHomeByIdUseCase mockGetHomeById;
  late SubjectNotifier subjectNotifier;
  late HomesListController controller;

  final testHome = HomeModel(
    id: '1',
    name: 'Test Home',
    address: const AddressModel(
      street: '123 Main St',
      city: 'Springfield',
      state: UsState.ca,
      zip: '90210',
    ),
    createdAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockGetHomes = MockGetHomesUseCase();
    mockDeleteHome = MockDeleteHomeUseCase();
    mockGetHomeById = MockGetHomeByIdUseCase();
    subjectNotifier = SubjectNotifier();

    when(() => mockGetHomes()).thenReturn(Right([testHome]));

    controller = HomesListController(
      mockGetHomes,
      mockDeleteHome,
      mockGetHomeById,
      subjectNotifier,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('SubjectListener integration', () {
    test('registers listener on init', () {
      // onInit already called in constructor — verify loadHomes was called
      verify(() => mockGetHomes()).called(1);
    });

    test('reloads homes when Subject.home is notified', () {
      // Reset call count from onInit
      reset(mockGetHomes);
      when(() => mockGetHomes()).thenReturn(Right([testHome]));

      subjectNotifier.notify(Subject.home);

      verify(() => mockGetHomes()).called(1);
    });

    test('stops listening after dispose', () {
      final localNotifier = SubjectNotifier();
      final localGetHomes = MockGetHomesUseCase();
      when(() => localGetHomes()).thenReturn(Right([testHome]));

      final localController = HomesListController(
        localGetHomes,
        mockDeleteHome,
        mockGetHomeById,
        localNotifier,
      );
      // Reset after constructor's loadHomes call
      reset(localGetHomes);
      when(() => localGetHomes()).thenReturn(Right([testHome]));

      localController.dispose();
      localNotifier.notify(Subject.home);

      verifyNever(() => localGetHomes());
    });
  });
}
