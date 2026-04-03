import 'package:flutter/material.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String prefix;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.prefix = '₹',
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final formatted = _formatNumber(animatedValue);
        return Text(
          '$prefix$formatted',
          style: style ?? Theme.of(context).textTheme.headlineLarge,
        );
      },
    );
  }

  String _formatNumber(double number) {
    if (number.abs() >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number.abs() >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    }
    // Indian number format
    final intPart = number.toInt();
    final decPart = ((number - intPart) * 100).round();
    final intStr = _formatIndianNumber(intPart);
    if (decPart == 0) return intStr;
    return '$intStr.${decPart.toString().padLeft(2, '0')}';
  }

  String _formatIndianNumber(int number) {
    if (number < 0) return '-${_formatIndianNumber(-number)}';
    final str = number.toString();
    if (str.length <= 3) return str;

    final lastThree = str.substring(str.length - 3);
    var remaining = str.substring(0, str.length - 3);
    final buffer = StringBuffer();

    while (remaining.length > 2) {
      buffer.write('${remaining.substring(remaining.length - 2)},');
      remaining = remaining.substring(0, remaining.length - 2);
    }

    if (remaining.isNotEmpty) {
      return '$remaining,${buffer.toString().split('').reversed.join()}$lastThree'
          .replaceAll(RegExp(r',+'), ',');
    }

    return '${buffer.toString().split('').reversed.join()}$lastThree';
  }
}
