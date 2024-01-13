String truncateText(String text, {int maxChars = 80}) {
  if (text.length <= maxChars) {
    return text;
  } else {
    return '${text.substring(0, maxChars)}...';
  }
}