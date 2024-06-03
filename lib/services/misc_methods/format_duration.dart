String formatDuration(int duration) {
  int hours = duration ~/ 3600;
  int minutes = (duration % 3600) ~/ 60;
  int seconds = duration % 60;

  String hoursStr = hours > 0 ? '${hours}h' : '';
  String minutesStr = minutes > 0 ? '${minutes}m' : '';
  String secondsStr = '${seconds}s';

  return [hoursStr, minutesStr, secondsStr].where((str) => str.isNotEmpty).join(' ');
}