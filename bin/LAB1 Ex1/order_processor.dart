double processOrder({
  required int orderId,
  required double itemPrice,
  String? promoCode,
  double? deliveryFee,
}) {
  double finalPrice = itemPrice;

  if (promoCode == 'SAVE10') {
    finalPrice = itemPrice - (itemPrice * 0.10);
  }

  double delivery = deliveryFee ?? 500.0;

  double total = finalPrice + delivery;

  print('Order ID: $orderId');
  print('Item price: $itemPrice₸');
  print('Promo code: ${promoCode ?? "none"}');
  print('Price after discount: $finalPrice₸');
  print('Delivery fee: $delivery₸');
  print('Total: $total₸');

  return total;
}

void main() {
  processOrder(orderId: 1, itemPrice: 1000.0, promoCode: 'SAVE10');
  print('---');
  processOrder(orderId: 2, itemPrice: 2000.0, deliveryFee: 300.0);
  print('---');
  processOrder(orderId: 3, itemPrice: 1500.0);
}