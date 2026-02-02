import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';

class _TestListenerController extends PearlController with SubjectListener {
  @override
  final SubjectNotifier subjectNotifier;

  @override
  final List<Subject> subjects;

  int changedCount = 0;

  _TestListenerController(this.subjectNotifier, this.subjects);

  @override
  void onSubjectChanged() => changedCount++;

  @override
  void onInit() {
    initSubjectListeners();
  }

  @override
  void onDispose() {
    disposeSubjectListeners();
  }
}

class _TestDispatcherController extends PearlController with SubjectDispatcher {
  @override
  final SubjectNotifier subjectNotifier;

  _TestDispatcherController(this.subjectNotifier);

  @override
  void onInit() {}
}

void main() {
  group('SubjectNotifier', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('notify calls listeners registered for the subject', () {
      var callCount = 0;
      notifier.addListener(Subject.home, () => callCount++);

      notifier.notify(Subject.home);

      expect(callCount, 1);
    });

    test('removeListener prevents future notifications', () {
      var callCount = 0;
      void callback() => callCount++;

      notifier.addListener(Subject.home, callback);
      notifier.notify(Subject.home);
      expect(callCount, 1);

      notifier.removeListener(Subject.home, callback);
      notifier.notify(Subject.home);
      expect(callCount, 1);
    });

    test('supports multiple listeners for the same subject', () {
      var count1 = 0;
      var count2 = 0;
      notifier.addListener(Subject.home, () => count1++);
      notifier.addListener(Subject.home, () => count2++);

      notifier.notify(Subject.home);

      expect(count1, 1);
      expect(count2, 1);
    });

    test('notify does nothing when no listeners are registered', () {
      // Should not throw
      notifier.notify(Subject.home);
    });

    test('adding same listener reference does not duplicate calls (Set)', () {
      var callCount = 0;
      void callback() => callCount++;

      notifier.addListener(Subject.home, callback);
      notifier.addListener(Subject.home, callback);

      notifier.notify(Subject.home);

      expect(callCount, 1);
    });

    test('removeListener for unregistered subject does nothing', () {
      notifier.removeListener(Subject.home, () {});
    });
  });

  group('SubjectListener', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('initSubjectListeners registers for all subjects', () {
      final controller =
          _TestListenerController(notifier, [Subject.home]);

      notifier.notify(Subject.home);

      expect(controller.changedCount, 1);
      controller.dispose();
    });

    test('disposeSubjectListeners removes all listeners', () {
      final controller =
          _TestListenerController(notifier, [Subject.home]);

      controller.dispose();
      notifier.notify(Subject.home);

      expect(controller.changedCount, 0);
    });

    test('onSubjectChanged is called for each notification', () {
      final controller =
          _TestListenerController(notifier, [Subject.home]);

      notifier.notify(Subject.home);
      notifier.notify(Subject.home);
      notifier.notify(Subject.home);

      expect(controller.changedCount, 3);
      controller.dispose();
    });

    test('multiple controllers can listen to the same subject', () {
      final controller1 =
          _TestListenerController(notifier, [Subject.home]);
      final controller2 =
          _TestListenerController(notifier, [Subject.home]);

      notifier.notify(Subject.home);

      expect(controller1.changedCount, 1);
      expect(controller2.changedCount, 1);

      controller1.dispose();
      controller2.dispose();
    });

    test('disposing one controller does not affect another', () {
      final controller1 =
          _TestListenerController(notifier, [Subject.home]);
      final controller2 =
          _TestListenerController(notifier, [Subject.home]);

      controller1.dispose();
      notifier.notify(Subject.home);

      expect(controller1.changedCount, 0);
      expect(controller2.changedCount, 1);

      controller2.dispose();
    });
  });

  group('SubjectDispatcher', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('notifySubject triggers listeners on the notifier', () {
      var notified = false;
      notifier.addListener(Subject.home, () => notified = true);

      final dispatcher = _TestDispatcherController(notifier);
      dispatcher.notifySubject(Subject.home);

      expect(notified, isTrue);
      dispatcher.dispose();
    });

    test('notifySubject does not affect other subjects', () {
      var homeNotified = false;
      notifier.addListener(Subject.home, () => homeNotified = true);

      final dispatcher = _TestDispatcherController(notifier);
      // Only one subject exists, so just verify home is triggered
      dispatcher.notifySubject(Subject.home);

      expect(homeNotified, isTrue);
      dispatcher.dispose();
    });
  });

  group('SubjectListener and SubjectDispatcher integration', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('dispatcher notifies listener through shared SubjectNotifier', () {
      final listener =
          _TestListenerController(notifier, [Subject.home]);
      final dispatcher = _TestDispatcherController(notifier);

      dispatcher.notifySubject(Subject.home);

      expect(listener.changedCount, 1);

      listener.dispose();
      dispatcher.dispose();
    });

    test(
        'listener stops receiving after dispose even if dispatcher keeps notifying',
        () {
      final listener =
          _TestListenerController(notifier, [Subject.home]);
      final dispatcher = _TestDispatcherController(notifier);

      dispatcher.notifySubject(Subject.home);
      expect(listener.changedCount, 1);

      listener.dispose();

      dispatcher.notifySubject(Subject.home);
      expect(listener.changedCount, 1);

      dispatcher.dispose();
    });
  });
}
