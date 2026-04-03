import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

  static String formatAmount(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 2,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  static String formatAmountCompact(double amount, {String symbol = '₹'}) {
    if (amount.abs() >= 10000000) {
      return '$symbol${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount.abs() >= 100000) {
      return '$symbol${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount.abs() >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatAmount(amount, symbol: symbol);
  }

  static String formatAmountShort(double amount, {String symbol = '₹'}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: 0,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  static String formatPercentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  static String formatSignedAmount(double amount, {String symbol = '₹'}) {
    final prefix = amount >= 0 ? '+' : '';
    return '$prefix${formatAmount(amount, symbol: symbol)}';
  }
}
