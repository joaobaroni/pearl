import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/presentation/views/home/home_controller.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockGetHomesUseCase mockGetHomes;
  late MockDeleteHomeUseCase mockDeleteHome;
  late MockSubjectNotifier mockSubjectNotifier;

  setUp(() {
    mockGetHomes = MockGetHomesUseCase();
    mockDeleteHome = MockDeleteHomeUseCase();
    mockSubjectNotifier = MockSubjectNotifier();
  });

  HomeController createController() {
    return HomeController(mockGetHomes, mockDeleteHome, mockSubjectNotifier);
  }

  group('HomeController', () {
    test('constructor calls loadHomes and populates homes list', () {
      final homes = [fakeHome(id: '1'), fakeHome(id: '2')];
      when(() => mockGetHomes()).thenReturn(Right(homes));

      final controller = createController();

      expect(controller.homes.length, 2);
      expect(controller.isLoading, isFalse);
      expect(controller.error, isNull);
    });

    test('loadHomes sets error on failure', () {
      when(() => mockGetHomes())
          .thenReturn(const Left(StorageFailure('failed')));

      final controller = createController();

      expect(controller.error, isA<StorageFailure>());
      expect(controller.isLoading, isFalse);
    });

    test('deleteHome removes home from list on success', () async {
      when(() => mockGetHomes())
          .thenReturn(Right([fakeHome(id: '1'), fakeHome(id: '2')]));
      when(() => mockDeleteHome(any()))
          .thenAnswer((_) async => const Right(null));

      final controller = createController();
      await controller.deleteHome('1');

      expect(controller.homes.length, 1);
      expect(controller.homes.first.id, '2');
    });

    test('deleteHome sets error on failure', () async {
      when(() => mockGetHomes()).thenReturn(Right([fakeHome(id: '1')]));
      when(() => mockDeleteHome(any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final controller = createController();
      await controller.deleteHome('1');

      expect(controller.error, isA<StorageFailure>());
    });

    test('registers subject listener on construction', () {
      when(() => mockGetHomes()).thenReturn(const Right([]));

      createController();

      verify(
        () => mockSubjectNotifier.addListener(Subject.home, any()),
      ).called(1);
    });

    test('dispose removes subject listener', () {
      when(() => mockGetHomes()).thenReturn(const Right([]));

      final controller = createController();
      controller.dispose();

      verify(
        () => mockSubjectNotifier.removeListener(Subject.home, any()),
      ).called(1);
    });

    test('loadHomes clears previous error on success', () {
      when(() => mockGetHomes())
          .thenReturn(const Left(StorageFailure('failed')));

      final controller = createController();
      expect(controller.error, isA<StorageFailure>());

      when(() => mockGetHomes()).thenReturn(Right([fakeHome()]));
      controller.loadHomes();

      expect(controller.error, isNull);
      expect(controller.homes.length, 1);
    });

    test('loadHomes notifies listeners', () {
      when(() => mockGetHomes()).thenReturn(const Right([]));

      final controller = createController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.loadHomes();

      // loadHomes calls notifyListeners twice: once for isLoading=true, once for isLoading=false
      expect(notifyCount, 2);
    });

    test('onSubjectChanged reloads homes via real SubjectNotifier', () {
      final realNotifier = SubjectNotifier();
      when(() => mockGetHomes()).thenReturn(const Right([]));

      final controller = HomeController(mockGetHomes, mockDeleteHome, realNotifier);

      when(() => mockGetHomes()).thenReturn(Right([fakeHome()]));
      realNotifier.notify(Subject.home);

      expect(controller.homes.length, 1);
    });

    test('deleteHome notifies listeners on failure', () async {
      when(() => mockGetHomes()).thenReturn(Right([fakeHome(id: '1')]));
      when(() => mockDeleteHome(any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final controller = createController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      await controller.deleteHome('1');

      expect(notifyCount, 1);
    });

    test('deleteHome keeps homes unchanged on failure', () async {
      when(() => mockGetHomes()).thenReturn(Right([fakeHome(id: '1')]));
      when(() => mockDeleteHome(any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final controller = createController();
      await controller.deleteHome('1');

      expect(controller.homes.length, 1);
      expect(controller.homes.first.id, '1');
    });

    test('deleteHome with non-existent id keeps list unchanged', () async {
      when(() => mockGetHomes())
          .thenReturn(Right([fakeHome(id: '1'), fakeHome(id: '2')]));
      when(() => mockDeleteHome(any()))
          .thenAnswer((_) async => const Right(null));

      final controller = createController();
      await controller.deleteHome('999');

      expect(controller.homes.length, 2);
    });

    test('subjects returns [Subject.home]', () {
      when(() => mockGetHomes()).thenReturn(const Right([]));

      final controller = createController();

      expect(controller.subjects, [Subject.home]);
    });
  });
}
