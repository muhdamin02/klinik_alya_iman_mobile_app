String truncateText(String text, {int maxChars = 20}) {
  if (text.length <= maxChars) {
    return text;
  } else {
    return '${text.substring(0, maxChars)}...';
  }
}