void main() {
  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];

  int max = numbers[0];
  int min = numbers[0];

  for (int i = 1; i < numbers.length; i++) {
    if (numbers[i] > max) {
      max = numbers[i];
    }
    if (numbers[i] < min) {
      min = numbers[i];
    }
  }

  print('max: $max');
  print('min: $min');
}