import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/core/controllers/controller.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';

class _TestListenerController extends Controller with SubjectListener {
  @override
  final SubjectNotifier subjectNotifier;

  @override
  final List<Subject> subjects;

  int changeCount = 0;

  _TestListenerController(this.subjectNotifier, this.subjects);

  @override
  void onSubjectChanged() {
    changeCount++;
  }
}

class _TestDispatcherController extends Controller with SubjectDispatcher {
  @override
  final SubjectNotifier subjectNotifier;

  _TestDispatcherController(this.subjectNotifier);
}

void main() {
  group('SubjectNotifier', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('notify calls registered listener', () {
      int callCount = 0;
      notifier.addListener(Subject.home, () => callCount++);

      notifier.notify(Subject.home);

      expect(callCount, 1);
    });

    test('removeListener prevents callback from being called', () {
      int callCount = 0;
      void callback() => callCount++;

      notifier.addListener(Subject.home, callback);
      notifier.removeListener(Subject.home, callback);
      notifier.notify(Subject.home);

      expect(callCount, 0);
    });

    test('multiple listeners are all called', () {
      int count1 = 0;
      int count2 = 0;

      notifier.addListener(Subject.home, () => count1++);
      notifier.addListener(Subject.home, () => count2++);
      notifier.notify(Subject.home);

      expect(count1, 1);
      expect(count2, 1);
    });

    test('notify with no listeners does not throw', () {
      expect(() => notifier.notify(Subject.home), returnsNormally);
    });
  });

  group('SubjectListener', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('onInit registers listeners automatically', () {
      final controller = _TestListenerController(notifier, [Subject.home]);

      notifier.notify(Subject.home);

      expect(controller.changeCount, 1);
    });

    test('dispose removes listeners', () {
      final controller = _TestListenerController(notifier, [Subject.home]);

      controller.dispose();
      notifier.notify(Subject.home);

      expect(controller.changeCount, 0);
    });

    test('onSubjectChanged is called on each notify', () {
      final controller = _TestListenerController(notifier, [Subject.home]);

      notifier.notify(Subject.home);
      notifier.notify(Subject.home);
      notifier.notify(Subject.home);

      expect(controller.changeCount, 3);
    });
  });

  group('SubjectDispatcher', () {
    late SubjectNotifier notifier;

    setUp(() {
      notifier = SubjectNotifier();
    });

    test('notifySubject delegates to SubjectNotifier.notify', () {
      int callCount = 0;
      notifier.addListener(Subject.home, () => callCount++);

      final controller = _TestDispatcherController(notifier);
      controller.notifySubject(Subject.home);

      expect(callCount, 1);
    });
  });
}
