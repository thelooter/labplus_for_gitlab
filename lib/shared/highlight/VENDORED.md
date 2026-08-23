# Vendored: `highlight` / `flutter_highlight`

**Do not try to replace this with the pub.dev packages. It will not resolve.**

## What this is

- `lib/shared/highlight/` — a verbatim copy of [`highlight`](https://pub.dev/packages/highlight) **0.7.0**
- `lib/shared/flutter_highlight/` — a **modified** copy of [`flutter_highlight`](https://pub.dev/packages/flutter_highlight) **0.7.0**

## Why it is vendored

Both packages were last published in **2020** and declare:

```yaml
environment:
  sdk: ">=2.12.0 <3.0.0"
```

That upper bound excludes Dart 3. This project targets `sdk: ^3.5.1`, so
`flutter pub add highlight flutter_highlight` fails version resolution. Neither
package has been updated, and neither is formally marked discontinued — they are
simply abandoned.

Checked alternatives, none of which are drop-in:

| Package | Status |
|---|---|
| `highlighter` / `flutter_highlighter` | Same `<3.0.0` bound. Dead end. |
| `re_highlight` | Dart 3 compatible (`>=2.17.0 <4.0.0`), but a **different API**. Swapping to it is a real migration of `AppHighlightView`, the theme map, and every theme file — not a dependency change. |

If you want to un-vendor, `re_highlight` is the target and it is a project, not a
chore. Budget accordingly.

## Local modifications

### `lib/shared/highlight/` — effectively unmodified

Diffed against upstream 0.7.0: all 190 language files and the `src/` tree are
byte-identical except for

1. import/export paths rewritten from `package:highlight/...` to
   `package:labplus_for_gitlab/shared/highlight/...`
2. `src/highlight.dart` — a debug `print(err)` removed from a `catch` block
3. `src/highlight.dart` — one redundant `?.` dropped (`.firstWhereOrNull`)

Treat this directory as read-only upstream code. It is excluded from the
analyzer in `analysis_options.yaml` for that reason.

### `lib/shared/flutter_highlight/` — deliberately modified, maintain it

This directory **is** analyzed, because we own the changes here.

All 90 upstream themes are kept. Only `vs` and `vs2015` are currently reachable —
`AppCodeTheme` (`lib/shared/data/sp_storage.dart`) hardcodes `vs` for light mode
and `vs2015` for dark mode, and there is no theme picker in the UI yet. The other
88 are retained on purpose: a user-facing theme picker is planned, and they are
the inventory it will draw from. **Do not delete them as dead code.**

Four themes differ from upstream on purpose:

| Theme | Local change |
|---|---|
| `vs`, `vs2015`, `github`, `dark` | `backgroundColor` set to `Colors.transparent` so code blocks inherit the app background instead of the theme's hardcoded one |
| `vs` | diff `addition` / `deletion` rendered as background fills (green / red) rather than text colours — **this is what makes commit and merge-request diffs readable**; do not restore the upstream values |
| `vs` | comments and quotes italicised |

Note the asymmetry: the transparent-background patch has only been applied to
those four. **Any theme wired into a future picker will need the same treatment**,
or it will render with a hardcoded background that clashes with the app theme.
That is the main piece of work standing between the remaining 86 unpatched
themes and being usable.

If you ever re-sync from upstream, re-apply all of the above.
