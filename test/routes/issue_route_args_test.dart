import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/routes/route_args.dart';

/// Routes whose bindings do `Get.arguments as IssueArgs`.
///
/// That cast throws at runtime if a caller navigates without arguments, and
/// nothing in the type system stops someone adding such a call. Grepping the
/// source is unglamorous, but it turns "the issue screen crashes when opened
/// from the new entry point somebody added" into a failing test.
const _issueRoutes = [
  'Routes.issue',
  'Routes.editIssue',
  'Routes.issueNotes',
  'Routes.editIssueNote',
];

void main() {
  group('IssueArgs', () {
    test('copyWith replaces the issue and keeps the identifiers', () {
      const args = IssueArgs(projectId: 4, issueIid: 12);

      final withIssue = args.copyWith(issue: Issue(iid: 12, title: 'x'));

      expect(withIssue.projectId, 4);
      expect(withIssue.issueIid, 12);
      expect(withIssue.issue?.title, 'x');
    });

    test('copyWith keeps an existing issue when passed nothing', () {
      final args =
          IssueArgs(projectId: 4, issueIid: 12, issue: Issue(title: 'kept'));

      expect(args.copyWith().issue?.title, 'kept');
    });
  });

  group('navigation', () {
    test('every navigation to an issue route passes arguments', () {
      final offenders = <String>[];

      for (final file in io.Directory('lib')
          .listSync(recursive: true)
          .whereType<io.File>()
          .where((f) => f.path.endsWith('.dart'))) {
        final source = file.readAsStringSync();
        for (final route in _issueRoutes) {
          // `Get.toNamed(Routes.issue)` with nothing after the route name.
          final bare = RegExp(
            r'Get\.(?:to|off|offAll)Named\(\s*' + RegExp.escape(route) + r'\s*\)',
          );
          if (bare.hasMatch(source)) {
            offenders.add('${file.path}: $route navigated without arguments');
          }
        }
      }

      expect(offenders, isEmpty,
          reason: 'These routes bind IssueArgs and will throw at runtime:\n'
              '${offenders.join('\n')}');
    });
  });
}
