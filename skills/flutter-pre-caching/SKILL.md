---
name: flutter-pre-caching
description: Pre-caches assets, fonts, images, and startup data in Flutter and Flutter Web. Use when preloading Google Fonts, asset/network images, Lottie/Rive animations, local JSON/config files, warming up initial API data, or optimizing Flutter Web startup.
---

# Pre-caching in Flutter and Flutter Web

Pre-caching helps avoid jank, loading flashes, font swaps, and delayed first renders.

The key rule:

> Pre-cache only what the user will likely see in the next 1 to 2 screens.

Do not pre-cache the whole app. That can slow startup and waste memory.

---

## 1. Google Fonts

### Runtime Google Fonts preloading

Use `GoogleFonts.pendingFonts()` to load the font variants before showing text.

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExampleSimple extends StatefulWidget {
  const ExampleSimple({super.key});

  @override
  State<ExampleSimple> createState() => _ExampleSimpleState();
}

class _ExampleSimpleState extends State<ExampleSimple> {
  late final Future<List<void>> googleFontsPending;

  @override
  void initState() {
    super.initState();

    googleFontsPending = GoogleFonts.pendingFonts([
      GoogleFonts.poppins(),
      GoogleFonts.montserrat(fontStyle: FontStyle.italic),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final pushButtonTextStyle = GoogleFonts.poppins(
      textStyle: Theme.of(context).textTheme.headlineMedium,
    );

    final counterTextStyle = GoogleFonts.montserrat(
      fontStyle: FontStyle.italic,
      textStyle: Theme.of(context).textTheme.displayLarge,
    );

    return FutureBuilder<List<void>>(
      future: googleFontsPending,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have pushed the button this many times:',
              style: pushButtonTextStyle,
            ),
            Text(
              '0',
              style: counterTextStyle,
            ),
          ],
        );
      },
    );
  }
}
```

### Production recommendation

For production and offline support, prefer bundling critical fonts as assets.

```yaml
flutter:
  fonts:
    - family: AppFont
      fonts:
        - asset: assets/fonts/AppFont-Regular.ttf
        - asset: assets/fonts/AppFont-Bold.ttf
          weight: 700
```

Use it in the app theme:

```dart
MaterialApp(
  theme: ThemeData(
    fontFamily: 'AppFont',
  ),
)
```

---

## 2. Asset images

Use `precacheImage` for images that appear soon.

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  precacheImage(
    const AssetImage('assets/images/header.png'),
    context,
  );
}
```

Then use the image normally:

```dart
Image.asset('assets/images/header.png')
```

---

## 3. Network images

Use `precacheImage` with `NetworkImage`.

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  precacheImage(
    const NetworkImage('https://example.com/image.png'),
    context,
  );
}
```

Then use it normally:

```dart
Image.network('https://example.com/image.png')
```

**Important:**
`precacheImage` warms Flutter’s in-memory image cache. It does not provide long-term offline caching.

For disk caching, use a package like `cached_network_image`:

```yaml
dependencies:
  cached_network_image: ^latest
```

Example:

```dart
CachedNetworkImage(
  imageUrl: 'https://example.com/image.png',
)
```

---

## 4. Multiple image preloading

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  final images = <ImageProvider>[
    const AssetImage('assets/images/header.png'),
    const AssetImage('assets/images/avatar.png'),
    const NetworkImage('https://example.com/banner.png'),
  ];

  for (final image in images) {
    precacheImage(image, context);
  }
}
```

---

## 5. Waiting until images are ready

`precacheImage` returns a `Future<void>`, so you can wait before rendering the real UI.

```dart
late Future<void> _preloadImagesFuture;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  _preloadImagesFuture = Future.wait([
    precacheImage(
      const AssetImage('assets/images/header.png'),
      context,
    ),
    precacheImage(
      const NetworkImage('https://example.com/banner.png'),
      context,
    ),
  ]);
}

@override
Widget build(BuildContext context) {
  return FutureBuilder<void>(
    future: _preloadImagesFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const CircularProgressIndicator();
      }

      return Column(
        children: [
          Image.asset('assets/images/header.png'),
          Image.network('https://example.com/banner.png'),
        ],
      );
    },
  );
}
```

> [!NOTE]
> Use `didChangeDependencies`, not `initState`, when you need `context` for `precacheImage`.

---

## 6. What should normally be pre-cached on app start?

**Good candidates:**
- App logo
- First screen hero image
- First visible background image
- Current user avatar
- First visible card/list images
- Main font variants
- Small local config files
- Translations needed for first paint
- First API request
- Lottie/Rive animation shown immediately

**Bad candidates:**
- All product images
- All gallery images
- All remote feed images
- All icons in the app
- All route images
- Every image from every screen
- Large animations not shown immediately

---

## 7. Practical app-start preloader

```dart
class AppPreloader {
  const AppPreloader();

  Future<void> preload(BuildContext context) async {
    await Future.wait([
      _precacheImages(context),
      _loadCriticalAssets(),
      _warmUpInitialData(),
    ]);
  }

  Future<void> _precacheImages(BuildContext context) {
    return Future.wait([
      precacheImage(
        const AssetImage('assets/images/home_hero.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/images/logo.png'),
        context,
      ),
    ]);
  }

  Future<void> _loadCriticalAssets() async {
    await rootBundle.loadString('assets/config/app_config.json');
  }

  Future<void> _warmUpInitialData() async {
    // Example:
    // await userRepository.getCurrentUser();
  }
}
```

Usage:

```dart
late Future<void> _preloadFuture;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  _preloadFuture = const AppPreloader().preload(context);
}
```

With `FutureBuilder`:

```dart
@override
Widget build(BuildContext context) {
  return FutureBuilder<void>(
    future: _preloadFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const SplashScreen();
      }

      return const HomeScreen();
    },
  );
}
```

---

## 8. Local JSON / config preloading

Useful for feature flags, local app config, mock data, translations, or onboarding content.

```dart
import 'package:flutter/services.dart';

final configJson = await rootBundle.loadString(
  'assets/config/app_config.json',
);
```

Example:

```dart
class AppConfigLoader {
  Future<String> load() {
    return rootBundle.loadString('assets/config/app_config.json');
  }
}
```

---

## 9. Initial API request warm-up

This is not pre-caching in the Flutter image-cache sense, but it is often the most useful startup optimization.

```dart
final userFuture = userRepository.getCurrentUser();
final dashboardFuture = dashboardRepository.getDashboard();
```

Example:

```dart
class StartupData {
  const StartupData({
    required this.user,
    required this.dashboard,
  });

  final User user;
  final Dashboard dashboard;
}

Future<StartupData> loadStartupData() async {
  final results = await Future.wait([
    userRepository.getCurrentUser(),
    dashboardRepository.getDashboard(),
  ]);

  return StartupData(
    user: results[0] as User,
    dashboard: results[1] as Dashboard,
  );
}
```

---

## 10. Lottie preloading

If the animation appears immediately, preload it.

```dart
final composition = await AssetLottie(
  'assets/animations/success.json',
).load();
```

Use this only for animations shown early. Avoid preloading many large animations on app start.

---

## 11. Rive preloading

Rather than triggering the asset load during a build (which causes jank), preload the `RiveFile` byte data in advance:

```dart
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

// Preload the RiveFile
final data = await rootBundle.load('assets/animations/character.riv');
final riveFile = RiveFile.import(data);

// Display using direct constructor to avoid initialization delays:
RiveAnimation.direct(riveFile);
```

This ensures that the animation renders immediately upon widget mount.

---

## 12. Shader warm-up

Most apps do not need this. It can help if you have:
- Heavy custom painting
- Complex transitions
- Known animation jank
- Older rendering paths

Basic shape:

```dart
class CustomShaderWarmUp extends ShaderWarmUp {
  @override
  void warmUpOnCanvas(Canvas canvas) {
    final paint = Paint();

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 100, 100),
      paint,
    );
  }
}
```

Then set it before `runApp`:

```dart
void main() {
  PaintingBinding.instance.shaderWarmUp = CustomShaderWarmUp();

  runApp(const MyApp());
}
```

Use this only when profiling shows shader compilation jank.

---

## 13. Flutter Web: different mindset

On Flutter Web, think less:
* Pre-cache everything in memory

Think more:
* Make the browser download key files early
* Warm Flutter cache only for first-screen assets
* Avoid surprise font fallback downloads
* Avoid loading huge assets before first paint

---

## 14. Flutter Web image preload

For critical first-screen images, use both browser preload and Flutter `precacheImage`.

In `web/index.html`:

```html
<link
  rel="preload"
  href="assets/assets/images/home_hero.png"
  as="image"
>
```

In Flutter:

```dart
await precacheImage(
  const AssetImage('assets/images/home_hero.png'),
  context,
);
```

**Why both?**
- HTML preload starts the browser download earlier.
- `precacheImage` warms Flutter's image cache.

---

## 15. Flutter Web network image preload

In `web/index.html`:

```html
<link
  rel="preload"
  href="https://example.com/banner.png"
  as="image"
>
```

In Flutter:

```dart
await precacheImage(
  const NetworkImage('https://example.com/banner.png'),
  context,
);
```

Only do this for images the user is almost guaranteed to see.

---

## 16. Flutter Web font preload

Declare the font in `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: AppFont
      fonts:
        - asset: assets/fonts/AppFont-Regular.ttf
        - asset: assets/fonts/AppFont-Bold.ttf
          weight: 700
```

Preload the critical font in `web/index.html`:

```html
<link
  rel="preload"
  href="assets/assets/fonts/AppFont-Regular.ttf"
  as="font"
  type="font/ttf"
  crossorigin
>
```

Use it in Flutter:

```dart
ThemeData(
  fontFamily: 'AppFont',
)
```

Usually preload:
- Regular
- Bold
- Maybe medium

Avoid preloading every weight and italic variant unless the first screen needs them.

---

## 17. Flutter Web and emojis

Emojis can trigger font fallback work.

Example:

```dart
Text('Welcome 👋 🎉')
```

On web, this can cause:
- Extra font download
- Delayed render
- Fallback font swap
- Blank boxes
- Different emoji style across platforms

---

## 18. Option 1: avoid emojis on first paint

Simple and effective:

```dart
Text('Welcome')
```

Then show emojis after the app has loaded:

```dart
Text('Welcome 👋')
```

This is often the best option if emojis are decorative.

---

## 19. Option 2: bundle and preload an emoji font

Add the font to `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: NotoColorEmoji
      fonts:
        - asset: assets/fonts/NotoColorEmoji.ttf
```

Preload it in `web/index.html`:

```html
<link
  rel="preload"
  href="assets/assets/fonts/NotoColorEmoji.ttf"
  as="font"
  type="font/ttf"
  crossorigin
>
```

Use it where needed:

```dart
const Text(
  '👋 🎉 ❤️',
  style: TextStyle(
    fontFamily: 'NotoColorEmoji',
  ),
)
```

**Important:**
- Emoji fonts can be large.
- Do not bundle a huge emoji font unless emojis are important to your product.

---

## 20. When emoji preloading makes sense

**Good cases:**
- Chat app
- Reactions
- Comments
- Social UI
- Emoji picker
- Emoji-heavy onboarding
- Brand uses emoji heavily

**Bad cases:**
- One decorative emoji on the welcome screen
- Random emoji in a button
- Rare emoji usage deep in the app

**Rule:**
- If emojis are decorative, delay them or remove them from first paint.
- If emojis are core to the product, use a known emoji rendering strategy.

---

## 21. Flutter Web renderer files

Flutter Web startup can also include renderer assets, for example CanvasKit or Skwasm files.

Usually, you do not preload these from Dart. You configure the renderer through Flutter Web initialization.

Example in web bootstrap:

```js
_flutter.loader.load({
  config: {
    renderer: 'canvaskit',
  },
});
```

Other configs can include things like:

```js
_flutter.loader.load({
  config: {
    renderer: 'canvaskit',
    canvasKitBaseUrl: '/canvaskit/',
  },
});
```

Most apps should let Flutter manage this unless there is a clear hosting or performance reason to change it.

---

## 22. Practical Flutter Web startup list

**Usually preload:**
- App font regular/bold
- Logo
- First hero image
- First visible background image
- Critical above-the-fold asset images
- Emoji font only if emojis are core to first paint
- Small config needed immediately

**Usually avoid:**
- All emoji fonts
- All product images
- All route images
- All remote avatars
- Large Lottie/Rive files not shown immediately
- Every font weight
- Every image in assets

---

## 23. Suggested folder structure

```text
assets/
  images/
    logo.png
    home_hero.png
    onboarding_hero.png

  fonts/
    AppFont-Regular.ttf
    AppFont-Bold.ttf
    NotoColorEmoji.ttf

  config/
    app_config.json

  animations/
    success.json
    character.riv
```

---

## 24. Example pubspec.yaml

```yaml
flutter:
  assets:
    - assets/images/
    - assets/config/
    - assets/animations/

  fonts:
    - family: AppFont
      fonts:
        - asset: assets/fonts/AppFont-Regular.ttf
        - asset: assets/fonts/AppFont-Bold.ttf
          weight: 700

    - family: NotoColorEmoji
      fonts:
        - asset: assets/fonts/NotoColorEmoji.ttf
```

---

## 25. Example web/index.html preload block

```html
<!-- App fonts -->
<link
  rel="preload"
  href="assets/assets/fonts/AppFont-Regular.ttf"
  as="font"
  type="font/ttf"
  crossorigin
>

<link
  rel="preload"
  href="assets/assets/fonts/AppFont-Bold.ttf"
  as="font"
  type="font/ttf"
  crossorigin
>

<!-- Only if emojis are critical to first paint -->
<link
  rel="preload"
  href="assets/assets/fonts/NotoColorEmoji.ttf"
  as="font"
  type="font/ttf"
  crossorigin
>

<!-- Critical images -->
<link
  rel="preload"
  href="assets/assets/images/logo.png"
  as="image"
>

<link
  rel="preload"
  href="assets/assets/images/home_hero.png"
  as="image"
>
```

> [!NOTE]
> Flutter web asset URLs often include `assets/assets/...` because Flutter serves declared assets under the `assets/` path, while your asset path also starts with `assets/`.
> 
> For example:
> - Flutter asset: `assets/images/logo.png`
> - Web URL: `assets/assets/images/logo.png`

---

## 26. Complete startup example

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStartupPreloader {
  const AppStartupPreloader();

  Future<void> preload(BuildContext context) async {
    await Future.wait([
      _preloadFonts(),
      _preloadImages(context),
      _preloadLocalConfig(),
      _preloadStartupData(),
    ]);
  }

  Future<void> _preloadFonts() {
    return GoogleFonts.pendingFonts([
      GoogleFonts.inter(),
      GoogleFonts.inter(fontWeight: FontWeight.w700),
    ]);
  }

  Future<void> _preloadImages(BuildContext context) {
    return Future.wait([
      precacheImage(
        const AssetImage('assets/images/logo.png'),
        context,
      ),
      precacheImage(
        const AssetImage('assets/images/home_hero.png'),
        context,
      ),
    ]);
  }

  Future<void> _preloadLocalConfig() async {
    await rootBundle.loadString('assets/config/app_config.json');
  }

  Future<void> _preloadStartupData() async {
    // Start your critical first API calls here.
    //
    // Example:
    // await userRepository.getCurrentUser();
    // await dashboardRepository.getDashboard();
  }
}
```

Usage:

```dart
class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  Future<void>? _startupFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _startupFuture ??= const AppStartupPreloader().preload(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SplashScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
```

---

## 27. Final rule of thumb

**Pre-cache this:**
- What the user sees immediately.
- What the user will almost certainly see next.
- What would cause visible jank if it loads late.

**Do not pre-cache this:**
- Everything.
- Large files that may never be used.
- Remote images far below the fold.
- Decorative emoji/font assets that are not critical.

**For Flutter Web specifically:**
- Use HTML preload for critical browser downloads.
- Use Flutter `precacheImage` for Flutter image cache.
- Bundle critical fonts.
- Avoid emoji font fallback on first paint.
- Delay decorative emojis.

---

## References

- [Flutter API: precacheImage](https://api.flutter.dev/flutter/widgets/precacheImage.html)
- [Flutter Web: Bootstrapping & Initialization](https://docs.flutter.dev/platform-integration/web/initialization)
- [Flutter Web: WebAssembly (Wasm) Compilation](https://docs.flutter.dev/platform-integration/web/wasm)
- [Flutter Performance: Shader Compilation Jank](https://docs.flutter.dev/perf/shader)
- [Flutter API: ShaderWarmUp Class](https://api.flutter.dev/flutter/painting/ShaderWarmUp-class.html)
- [MDN Web Docs: Preloading content with rel="preload"](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/preload)
- [pub.dev: google_fonts Package](https://pub.dev/packages/google_fonts)
- [pub.dev: lottie Package](https://pub.dev/packages/lottie)
- [pub.dev: rive Package](https://pub.dev/packages/rive)
