import 'dart:async';

/// Something that happened which other parts of the app may want to react to.
///
/// This replaces eight `var somethingUpdate = 0.obs` counters on [Repository]
/// that were incremented to mean "something changed, everyone re-fetch". A
/// counter says nothing about *what* changed, so every listener re-fetched on
/// every bump and the compiler could not tell you who reacted to what.
///
/// Deliberately no payload yet. The obvious field to add is `projectId`, but
/// today the only place to read it from is `Repository.projectId` — the global
/// this refactor exists to delete. Adding it now would launder that global
/// through the event bus. It belongs in phase 3, once project ids arrive as
/// route parameters and there is a correct source to put on the event.
sealed class DomainEvent {
  const DomainEvent();
}

/// The set of projects changed -- one was created, or one's summary in a list
/// is now stale.
final class ProjectsChanged extends DomainEvent {
  const ProjectsChanged();
}

/// The project currently being looked at changed.
///
/// Named for the distinction rather than against [ProjectsChanged]: the two
/// used to differ by a single letter and are emitted on adjacent lines in
/// EditProjectController, which the compiler cannot help you with.
final class CurrentProjectChanged extends DomainEvent {
  const CurrentProjectChanged();
}

final class IssuesChanged extends DomainEvent {
  const IssuesChanged();
}

final class IssueNotesChanged extends DomainEvent {
  const IssueNotesChanged();
}

final class MergeRequestsChanged extends DomainEvent {
  const MergeRequestsChanged();
}

final class MilestonesChanged extends DomainEvent {
  const MilestonesChanged();
}

final class LabelsChanged extends DomainEvent {
  const LabelsChanged();
}

final class SnippetsChanged extends DomainEvent {
  const SnippetsChanged();
}

final class MembersChanged extends DomainEvent {
  const MembersChanged();
}

/// App-wide bus for [DomainEvent]s.
///
/// Registered as a permanent singleton in `AppBinding` and handed to
/// [Repository], so call sites reach it as `repository.events`. It is owned
/// separately from `Repository` on purpose: phase 4 makes that binding-scoped
/// so it dies when you leave a feature, and the bus must outlive that.
class DomainEvents {
  final _controller = StreamController<DomainEvent>.broadcast();

  /// Events of exactly one type. Listeners no longer wake for unrelated
  /// changes the way every counter listener used to.
  Stream<T> on<T extends DomainEvent>() =>
      _controller.stream.where((event) => event is T).cast<T>();

  /// All events, mostly useful for tests and debugging.
  Stream<DomainEvent> get all => _controller.stream;

  void emit(DomainEvent event) {
    if (_controller.isClosed) return;
    _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
