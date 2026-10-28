/// Tiny formatter so we don't need the intl package for these screens.
abstract class DateFormatter {
  static const _short = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _long = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String short(DateTime d) =>
      '${_short[d.month - 1]} ${d.day.toString().padLeft(2, '0')}, ${d.year}';

  static String long(DateTime d) => '${_long[d.month - 1]} ${d.day}, ${d.year}';
}
