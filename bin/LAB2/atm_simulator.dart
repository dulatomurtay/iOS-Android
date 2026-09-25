void checkBalance({required String name, required double balance}) =>
    print('$name, your available balance is: $balance₸');

double deposit({required double currentBalance, double? amount}) {
  double depositAmount = amount ?? 0.0;
  double newBalance = currentBalance + depositAmount;
  print('Deposit of $depositAmount₸ successful. New balance: $newBalance₸');
  return newBalance;
}

double withdraw({
  required String name,
  required double currentBalance,
  double? amount,
  int? pinCode,
}) {
  int correctPin = 1234;
  int enteredPin = pinCode ?? 0000;

  if (enteredPin != correctPin) {
    print('$name, transaction declined: incorrect PIN code.');
    return currentBalance;
  }

  double withdrawAmount = amount ?? 0.0;

  if (withdrawAmount > currentBalance) {
    print('$name, transaction declined: insufficient funds.');
    return currentBalance;
  }

  double newBalance = currentBalance - withdrawAmount;
  print('$name, withdrawal of $withdrawAmount₸ successful. New balance: $newBalance₸');
  return newBalance;
}

void main() {
  double balance = 10000.0;

  checkBalance(name: 'Abdulla', balance: balance);

  balance = deposit(currentBalance: balance, amount: 2000.0);

  balance = withdraw(name: 'Abdulla', currentBalance: balance, amount: 5000.0, pinCode: 1234);

  balance = withdraw(name: 'Abdulla', currentBalance: balance, amount: 3000.0, pinCode: 9999);

  balance = withdraw(name: 'Abdulla', currentBalance: balance, amount: 999999.0, pinCode: 1234);

  checkBalance(name: 'Abdulla', balance: balance);
}