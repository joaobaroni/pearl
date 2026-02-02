import 'package:flutter/material.dart';

import 'controller.dart';

/// Identifies a domain topic that controllers can listen to or dispatch
/// notifications about.
enum Subject { home }

/// A lightweight pub/sub hub that lets controllers communicate through
/// [Subject]-based events without direct references to each other.
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

/// Mixin for controllers that need to react when a [Subject] is updated.
///
/// Implement [subjects] to declare which subjects to observe and
/// [onSubjectChanged] to handle the notification.
mixin SubjectListener on Controller {
  SubjectNotifier get subjectNotifier;
  List<Subject> get subjects;
  void onSubjectChanged();

  @override
  void onInit() {
    initSubjectListeners();
    super.onInit();
  }

  @override
  void dispose() {
    disposeSubjectListeners();
    super.dispose();
  }

  @protected
  void initSubjectListeners() {
    for (final subject in subjects) {
      subjectNotifier.addListener(subject, onSubjectChanged);
    }
  }

  @protected
  void disposeSubjectListeners() {
    for (final subject in subjects) {
      subjectNotifier.removeListener(subject, onSubjectChanged);
    }
  }
}

/// Mixin for controllers that publish [Subject] notifications, triggering
/// any registered [SubjectListener]s.
mixin SubjectDispatcher {
  SubjectNotifier get subjectNotifier;

  void notifySubject(Subject subject) {
    subjectNotifier.notify(subject);
  }
}
