# Localization and Package Boundaries

Use this when a Flutter app has app-level localization and reusable feature or
UI packages that render user-facing strings.

## Default Recommendation

Keep localization owned by the host app:

- Use Flutter gen-l10n with `flutter_localizations`, `intl`, `l10n.yaml`, and
  `.arb` files in the app package.
- Expose generated app strings through an app helper such as `context.l10n`.
- Pass localized copy into reusable packages through explicit constructor
  values, not by importing the app's generated localizations from the package.
- Keep package APIs dumb and portable: state in, callbacks out, labels in.

This keeps one translation surface for the product while allowing packages to
remain reusable.

## Reusable Package Pattern

For a reusable settings page, prefer a host-owned wrapper:

```dart
pkg_settings.SettingsPage(
  strings: SettingsPageStrings.fromL10n(context.l10n),
  themeMode: settingsState.themeMode,
  locale: settingsState.locale,
  supportedLocales: AppLocalizations.supportedLocales,
  showLanguageSelector: AppLocalizations.supportedLocales.length > 1,
  localeLabels: {
    const Locale('en'): context.l10n.localeEnglish,
  },
  onThemeModeChanged: context.read<SettingsCubit>().setThemeMode,
  onLocaleChanged: context.read<SettingsCubit>().setLocale,
  onAboutTapped: () => context.push('/about'),
  onLegalTapped: () => context.push('/legal'),
  onLogoutTapped: context.read<AuthCubit>().logOut,
)
```

The package owns layout and interactions. The app owns localization, routing,
state management, and business behavior.

## Language Controls

Do not show a visible language picker when only one locale is supported. A
visible selector that cannot change rendered text is a no-op preference.

Recommended behavior:

- Keep locale persistence in the settings cubit or view model.
- Pass `showLanguageSelector: AppLocalizations.supportedLocales.length > 1`.
- Keep `locale: settingsState.locale` wired into `MaterialApp`.
- Add the second `.arb` file before exposing the picker.

## Very Good Open Source Pattern

Very Good Core treats localization as an app-level concern:

- The generated app structure includes `l10n.yaml`, `lib/l10n/arb`, and a
  `lib/l10n/l10n.dart` helper.
- Their docs use `context.l10n` from app code after adding strings to
  `lib/l10n/arb/app_en.arb`.
- Adding languages means adding new app ARB files and platform locale config.

Very Good App UI Package is described as a design-system layer that separates
UI components from business logic. Very Good Flame Game follows the same core
architecture style. Together, these examples point to app-owned localization
and package-owned reusable UI, rather than each UI package creating an
independent translation universe.

## When Package-Owned l10n Is Appropriate

Let a package ship its own ARB bundle only when it is a genuinely reusable,
published package with stable copy that should be translated independently of
the host app. For app-specific feature packages in a monorepo, host-passed
strings are usually simpler and safer.
