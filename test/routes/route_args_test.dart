import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';

/// Routes whose bindings cast `Get.arguments` to a route-argument type.
///
/// That cast throws at runtime if a caller navigates without arguments, and
/// nothing in the type system stops someone adding such a call. Grepping the
/// source is unglamorous, but it turns "the issue screen crashes when opened
/// from the new entry point somebody added" into a failing test.
const _argumentRoutes = [
  'Routes.issue',
  'Routes.editIssue',
  'Routes.issueNotes',
  'Routes.editIssueNote',
  'Routes.mergeRequest',
  'Routes.editMergeRequest',
  'Routes.mergeRequestNotes',
  'Routes.milestone',
  'Routes.editMilestone',
];

void main() {
  group('navigation', () {
    test('every navigation to an argument-bound route passes arguments', () {
      final offenders = <String>[];

      for (final file in io.Directory('lib')
          .listSync(recursive: true)
          .whereType<io.File>()
          .where((f) => f.path.endsWith('.dart'))) {
        final source = file.readAsStringSync();
        for (final route in _argumentRoutes) {
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
