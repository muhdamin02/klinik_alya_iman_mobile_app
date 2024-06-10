// Function to get the first two words from a string
String getFirstTwoWords(String fullName) {
  // Split the string into words
  List<String> words = fullName.split(' ');

  // Take the first two words and join them back into a string
  return words.take(2).join(' ');
}
