void main() {
  String text = "flutter mobile development";
  String vowels = "aeiouAEIOU";
  int count = 0;

  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i])) {
      count++;
    }
  }
  print('Vowels in "$text": $count');

  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  int first = numbers[0];
  int last = numbers[numbers.length - 1];
  print('First: $first, Last: $last');
}