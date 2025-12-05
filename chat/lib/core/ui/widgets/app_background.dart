import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Shared dark background used on the home and chat screens.
class TurboBackground extends StatelessWidget {
  const TurboBackground({super.key, required this.child});

  static const Color color = Color(0xFF020617);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          'assets/logo/turbo_background.svg',
          fit: BoxFit.cover,
          placeholderBuilder: (_) => Container(color: color),
        ),
        Container(color: color.withOpacity(0.82)),
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.2),
              radius: 1.1,
              colors: [Colors.transparent, Colors.black54],
              stops: [0.55, 1.0],
            ),
          ),
        ),
        SafeArea(bottom: false, right: false, left: false, child: child),
      ],
    );
  }
}
