import 'package:intl/intl.dart';

/// DateTime extensions for formatting and calculations
extension DateTimeExtensions on DateTime {
  /// Format date as "MMM dd, yyyy" (e.g., "Jan 15, 2024")
  String toFormattedDate() {
    return DateFormat('MMM dd, yyyy').format(this);
  }

  /// Format date as "dd/MM/yyyy" (e.g., "15/01/2024")
  String toShortDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Format date as "yyyy-MM-dd" (e.g., "2024-01-15")
  String toIsoDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Format time as "HH:mm" (e.g., "14:30")
  String toTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format time as "hh:mm a" (e.g., "02:30 PM")
  String to12HourTime() {
    return DateFormat('hh:mm a').format(this);
  }

  /// Format date and time as "MMM dd, yyyy HH:mm" (e.g., "Jan 15, 2024 14:30")
  String toFormattedDateTime() {
    return DateFormat('MMM dd, yyyy HH:mm').format(this);
  }

  /// Format date and time as "dd/MM/yyyy HH:mm" (e.g., "15/01/2024 14:30")
  String toShortDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Get time ago string (e.g., "2 hours ago", "3 days ago")
  String timeAgo({bool numericDates = true}) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return numericDates
          ? '$years year${years > 1 ? 's' : ''} ago'
          : 'Last year';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return numericDates
          ? '$months month${months > 1 ? 's' : ''} ago'
          : 'Last month';
    } else if (difference.inDays > 0) {
      return numericDates
          ? '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago'
          : 'Yesterday';
    } else if (difference.inHours > 0) {
      return numericDates
          ? '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago'
          : 'Today';
    } else if (difference.inMinutes > 0) {
      return numericDates
          ? '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago'
          : 'Just now';
    } else {
      return 'Just now';
    }
  }

  /// Get relative time string (e.g., "in 2 hours", "3 days ago")
  String relativeTime() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years > 0
          ? 'in $years year${years > 1 ? 's' : ''}'
          : '${years.abs()} year${years.abs() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months > 0
          ? 'in $months month${months > 1 ? 's' : ''}'
          : '${months.abs()} month${months.abs() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return difference.inDays > 0
          ? 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}'
          : '${difference.inDays.abs()} day${difference.inDays.abs() > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return difference.inHours > 0
          ? 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}'
          : '${difference.inHours.abs()} hour${difference.inHours.abs() > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes > 0
          ? 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}'
          : '${difference.inMinutes.abs()} minute${difference.inMinutes.abs() > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is in this week
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart.subtract(const Duration(days: 1))) &&
        isBefore(weekEnd.add(const Duration(days: 1)));
  }

  /// Check if date is in this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is in this year
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    final daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add months
  DateTime addMonths(int months) {
    return DateTime(year, month + months, day);
  }

  /// Subtract months
  DateTime subtractMonths(int months) {
    return DateTime(year, month - months, day);
  }

  /// Add years
  DateTime addYears(int years) {
    return DateTime(year + years, month, day);
  }

  /// Subtract years
  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day);
  }

  /// Get days difference from another date
  int daysDifference(DateTime other) {
    return difference(other).inDays;
  }

  /// Get hours difference from another date
  int hoursDifference(DateTime other) {
    return difference(other).inHours;
  }

  /// Get minutes difference from another date
  int minutesDifference(DateTime other) {
    return difference(other).inMinutes;
  }

  /// Check if date is between two dates
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  /// Get age in years
  int get age {
    final now = DateTime.now();
    int years = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      years--;
    }
    return years;
  }
}
