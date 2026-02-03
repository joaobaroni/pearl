import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/presentation/views/home_detail/home_detail_controller.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetHomeByIdUseCase mockGetHomeById;
  late MockDeleteAssetUseCase mockDeleteAsset;
  late MockSubjectNotifier mockSubjectNotifier;

  setUp(() {
    mockGetHomeById = MockGetHomeByIdUseCase();
    mockDeleteAsset = MockDeleteAssetUseCase();
    mockSubjectNotifier = MockSubjectNotifier();
  });

  Future<HomeDetailController> createController({String homeId = '1'}) async {
    final controller = HomeDetailController(
      mockGetHomeById,
      mockDeleteAsset,
      mockSubjectNotifier,
      homeId,
    );
    // Pump the binding to trigger addPostFrameCallback
    await Future.delayed(Duration.zero);
    WidgetsBinding.instance.scheduleFrame();
    await Future.delayed(Duration.zero);
    return controller;
  }

  group('HomeDetailController', () {
    test('constructor calls loadHome and sets home', () async {
      final home = fakeHome(id: '1', assets: [fakeAsset(id: 'a1')]);
      when(() => mockGetHomeById('1')).thenReturn(Right(home));

      final controller = await createController();

      expect(controller.home, isNotNull);
      expect(controller.home!.id, '1');
      expect(controller.error, isNull);
    });

    test('loadHome sets error on failure', () async {
      when(() => mockGetHomeById('1'))
          .thenReturn(const Left(NotFoundFailure('not found')));

      final controller = await createController();

      expect(controller.error, isA<NotFoundFailure>());
    });

    test('deleteAsset removes asset and calls notifySubject', () async {
      final home = fakeHome(
        id: '1',
        assets: [fakeAsset(id: 'a1'), fakeAsset(id: 'a2')],
      );
      when(() => mockGetHomeById('1')).thenReturn(Right(home));
      when(() => mockDeleteAsset(any(), any()))
          .thenAnswer((_) async => const Right(null));

      final controller = await createController();
      await controller.deleteAsset('a1');

      expect(controller.home!.assets.length, 1);
      expect(controller.home!.assets.first.id, 'a2');
      verify(() => mockSubjectNotifier.notify(Subject.home)).called(1);
    });

    test('deleteAsset sets error on failure without notifying subject',
        () async {
      final home = fakeHome(id: '1', assets: [fakeAsset(id: 'a1')]);
      when(() => mockGetHomeById('1')).thenReturn(Right(home));
      when(() => mockDeleteAsset(any(), any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final controller = await createController();
      await controller.deleteAsset('a1');

      expect(controller.error, isA<StorageFailure>());
      verifyNever(() => mockSubjectNotifier.notify(Subject.home));
    });
  });
}
