bool isLeapYear(int year) {
  if (year % 400 == 0) return true;
  if (year % 100 == 0) return false;
  if (year % 4 == 0) return true;
  return false;
}

int daysInMonth(int month, int year) {
  if (month == 2) {
    return isLeapYear(year) ? 29 : 28;
  }
  if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  }
  return 31;
}

void nextDay(int day, int month, int year) {
  int maxDay = daysInMonth(month, year);

  if (day > maxDay || day < 1 || month < 1 || month > 12) {
    print('$day.$month.$year -> invalid date');
    return;
  }

  int nextD = day;
  int nextM = month;
  int nextY = year;

  if (day < maxDay) {
    nextD = day + 1;
  } else if (month < 12) {
    nextD = 1;
    nextM = month + 1;
  } else {
    nextD = 1;
    nextM = 1;
    nextY = year + 1;
  }

  print('$day.$month.$year -> $nextD.$nextM.$nextY');
}

void main() {
  nextDay(5, 9, 2026);
  nextDay(28, 2, 2024);
  nextDay(28, 2, 2026);
  nextDay(29, 2, 2026);
  nextDay(28, 2, 2100);
  nextDay(31, 12, 2025);
}