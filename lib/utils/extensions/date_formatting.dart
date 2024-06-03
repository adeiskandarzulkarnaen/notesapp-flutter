extension DateFormatting on String {
  String get formattedDatetime {
    final date = DateTime.parse(this);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute, $day/$month/$year';
  }
}
