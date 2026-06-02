import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a true two-colour (duotone) Solar icon from assets.
/// - [color] == null  -> brand bi-colour (tech blue detail + cyan soft layer).
/// - [color] != null  -> flat mono tint (used on gradient/coloured surfaces,
///   e.g. selected nav, filled buttons, where a single colour reads best).
class DuoIcon extends StatelessWidget {
  const DuoIcon(this.name, {super.key, this.size = 24, this.color});

  final String name;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/duo/$name.svg',
      width: size,
      height: size,
      colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
