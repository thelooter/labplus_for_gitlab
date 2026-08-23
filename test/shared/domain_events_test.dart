import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/shared/data/domain_events.dart';

void main() {
  late DomainEvents events;

  setUp(() => events = DomainEvents());
  tearDown(() => events.dispose());

  test('delivers an event to a listener of that type', () async {
    final seen = <IssuesChanged>[];
    events.on<IssuesChanged>().listen(seen.add);

    events.emit(const IssuesChanged());
    await pumpEventQueue();

    expect(seen, hasLength(1));
  });

  // The whole point of the phase. With the old integer counters every listener
  // woke on every bump, because a counter carries no information about what
  // changed.
  test('does not wake listeners of other types', () async {
    final issues = <DomainEvent>[];
    final milestones = <DomainEvent>[];
    events.on<IssuesChanged>().listen(issues.add);
    events.on<MilestonesChanged>().listen(milestones.add);

    events.emit(const IssuesChanged());
    await pumpEventQueue();

    expect(issues, hasLength(1));
    expect(milestones, isEmpty);
  });

  test('broadcasts to every listener of the same type', () async {
    var first = 0;
    var second = 0;
    events.on<ProjectsChanged>().listen((_) => first++);
    events.on<ProjectsChanged>().listen((_) => second++);

    events.emit(const ProjectsChanged());
    await pumpEventQueue();

    expect([first, second], [1, 1]);
  });

  test('a cancelled subscription stops receiving', () async {
    var count = 0;
    final sub = events.on<LabelsChanged>().listen((_) => count++);

    events.emit(const LabelsChanged());
    await pumpEventQueue();
    await sub.cancel();
    events.emit(const LabelsChanged());
    await pumpEventQueue();

    expect(count, 1);
  });

  test('on<DomainEvent> and all see every event type', () async {
    final seen = <DomainEvent>[];
    events.all.listen(seen.add);

    events.emit(const IssuesChanged());
    events.emit(const MembersChanged());
    events.emit(const SnippetsChanged());
    await pumpEventQueue();

    expect(seen, hasLength(3));
  });

  // Controllers emit from onClose paths during teardown; a closed bus must not
  // take the app down with it.
  test('emitting after dispose is a no-op rather than a throw', () async {
    await events.dispose();

    expect(() => events.emit(const IssuesChanged()), returnsNormally);
  });
}
