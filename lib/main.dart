import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ColorPaletteApp());

const Color kBackground = Color(0xFF0E0A2A);
const Color kCard = Color(0xFF1A1440);
const Color kPurple = Color(0xFF7B61FF);
const Color kMuted = Color(0xFF9C96C4);

class Palette {
  const Palette(this.name, this.colors);

  final String name;
  final List<Color> colors;
}

const List<Palette> kPalettes = [
  Palette('Sunset', [
    Color(0xFFFF5F6D),
    Color(0xFFFF7A5C),
    Color(0xFFFF9A5B),
    Color(0xFFFFC371),
    Color(0xFFFFE29A),
  ]),
  Palette('Ocean', [
    Color(0xFF023E8A),
    Color(0xFF0077B6),
    Color(0xFF0096C7),
    Color(0xFF48CAE4),
    Color(0xFFADE8F4),
  ]),
  Palette('Forest', [
    Color(0xFF1B4332),
    Color(0xFF2D6A4F),
    Color(0xFF40916C),
    Color(0xFF52B788),
    Color(0xFF95D5B2),
  ]),
  Palette('Lavender', [
    Color(0xFF7B61FF),
    Color(0xFF9D8DFF),
    Color(0xFFB9AFFF),
    Color(0xFFD6D0FF),
    Color(0xFFEDEAFF),
  ]),
  Palette('Candy', [
    Color(0xFFE63980),
    Color(0xFFFF6BA8),
    Color(0xFFFF9EC4),
    Color(0xFFFFC2D8),
    Color(0xFFFFE3EE),
  ]),
  Palette('Ember', [
    Color(0xFF6A040F),
    Color(0xFF9D0208),
    Color(0xFFD00000),
    Color(0xFFE85D04),
    Color(0xFFFAA307),
  ]),
  Palette('Retro', [
    Color(0xFF264653),
    Color(0xFF2A9D8F),
    Color(0xFFE9C46A),
    Color(0xFFF4A261),
    Color(0xFFE76F51),
  ]),
  Palette('Midnight', [
    Color(0xFF0F0B2E),
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
    Color(0xFF4338CA),
    Color(0xFF6366F1),
  ]),
];

String hexOf(Color color) =>
    '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

String rgbOf(Color color) {
  final value = color.toARGB32();
  final r = (value >> 16) & 0xFF;
  final g = (value >> 8) & 0xFF;
  final b = value & 0xFF;
  return 'RGB  $r, $g, $b';
}

String hslOf(Color color) {
  final hsl = HSLColor.fromColor(color);
  return 'HSL  ${hsl.hue.round()}°, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%';
}

Color contentOn(Color background) =>
    background.computeLuminance() > 0.5 ? const Color(0xFF15102E) : Colors.white;

class ColorPaletteApp extends StatelessWidget {
  const ColorPaletteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ColorScheme.fromSeed(
      seedColor: kPurple,
      brightness: Brightness.dark,
    );
    return MaterialApp(
      title: 'Color Palette',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: base.copyWith(
          primary: kPurple,
          surface: kBackground,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: kBackground,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF2A2260),
          contentTextStyle: TextStyle(color: Colors.white),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList.separated(
                itemCount: kPalettes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    PaletteCard(palette: kPalettes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
      child: Row(
        children: [
          const _FanMark(),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Color Palette',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap a color to view and copy its HEX',
                style: TextStyle(fontSize: 13, color: kMuted.withValues(alpha: 0.9)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FanMark extends StatelessWidget {
  const _FanMark();

  @override
  Widget build(BuildContext context) {
    Widget card(Color color, double angle) => Transform.rotate(
          angle: angle,
          child: Container(
            width: 20,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );

    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(offset: const Offset(-9, 0), child: card(const Color(0xFFFF5F6D), -0.35)),
          Transform.translate(offset: const Offset(-3, 0), child: card(const Color(0xFFFFC371), -0.18)),
          card(const Color(0xFF48CAE4), 0),
          Transform.translate(offset: const Offset(3, 0), child: card(const Color(0xFF52B788), 0.18)),
          Transform.translate(offset: const Offset(9, 0), child: card(kPurple, 0.35)),
        ],
      ),
    );
  }
}

class PaletteCard extends StatelessWidget {
  const PaletteCard({super.key, required this.palette});

  final Palette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                palette.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${palette.colors.length} colors',
                  style: const TextStyle(fontSize: 11, color: kMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 92,
            child: Row(
              children: [
                for (var i = 0; i < palette.colors.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _Swatch(
                      color: palette.colors[i],
                      paletteName: palette.name,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.paletteName});

  final Color color;
  final String paletteName;

  @override
  Widget build(BuildContext context) {
    final labelColor = contentOn(color);
    return GestureDetector(
      onTap: () => _openDetail(context),
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: hexOf(color)));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied ${hexOf(color)}'),
              duration: const Duration(milliseconds: 1400),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 8),
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            hexOf(color),
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: labelColor.withValues(alpha: 0.85),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ColorDetailSheet(color: color, paletteName: paletteName),
    );
  }
}

class ColorDetailSheet extends StatelessWidget {
  const ColorDetailSheet({
    super.key,
    required this.color,
    required this.paletteName,
  });

  final Color color;
  final String paletteName;

  @override
  Widget build(BuildContext context) {
    final onColor = contentOn(color);
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              hexOf(color),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: onColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$paletteName palette',
            style: const TextStyle(fontSize: 12, color: kMuted),
          ),
          const SizedBox(height: 6),
          Text(
            hexOf(color),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(rgbOf(color), style: const TextStyle(fontSize: 13, color: kMuted)),
          const SizedBox(height: 4),
          Text(hslOf(color), style: const TextStyle(fontSize: 13, color: kMuted)),
          const SizedBox(height: 22),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: kPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: hexOf(color)));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied ${hexOf(color)}')),
                  );
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 20),
              label: const Text(
                'Copy HEX',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: rgbOf(color)));
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied ${rgbOf(color)}')),
                );
              }
            },
            child: const Text('Copy RGB'),
          ),
        ],
      ),
    );
  }
}
