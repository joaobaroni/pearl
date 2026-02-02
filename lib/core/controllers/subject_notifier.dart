import 'dart:ui';

import 'pearl_controller.dart';

enum Subject { home }

class SubjectNotifier {
  final _listeners = <Subject, Set<VoidCallback>>{};

  void addListener(Subject subject, VoidCallback callback) {
    _listeners.putIfAbsent(subject, () => {}).add(callback);
  }

  void removeListener(Subject subject, VoidCallback callback) {
    _listeners[subject]?.remove(callback);
  }

  void notify(Subject subject) {
    final listeners = _listeners[subject];
    if (listeners == null) return;
    for (final listener in [...listeners]) {
      listener();
    }
  }
}

mixin SubjectListener on PearlController {
  SubjectNotifier get subjectNotifier;
  List<Subject> get subjects;
  void onSubjectChanged();

  void initSubjectListeners() {
    for (final subject in subjects) {
      subjectNotifier.addListener(subject, onSubjectChanged);
    }
  }

  void disposeSubjectListeners() {
    for (final subject in subjects) {
      subjectNotifier.removeListener(subject, onSubjectChanged);
    }
  }
}

mixin SubjectDispatcher {
  SubjectNotifier get subjectNotifier;

  void notifySubject(Subject subject) {
    subjectNotifier.notify(subject);
  }
}
