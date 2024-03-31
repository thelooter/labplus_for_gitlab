import 'package:labplus_for_gitlab/shared/highlight/src/highlight.dart';
import 'package:labplus_for_gitlab/shared/highlight/languages/all.dart';

export 'package:labplus_for_gitlab/shared/highlight/src/highlight.dart';
export 'package:labplus_for_gitlab/shared/highlight/src/node.dart';
export 'package:labplus_for_gitlab/shared/highlight/src/mode.dart';
export 'package:labplus_for_gitlab/shared/highlight/src/result.dart';

final highlight = Highlight()..registerLanguages(allLanguages);
