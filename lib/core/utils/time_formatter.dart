String formatTime(DateTime time) {
  int hour = time.hour % 12;
  if (hour == 0) hour = 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';

  return "$hour:$minute $period";
}
