import 'package:flutter/foundation.dart';

class BucketModel extends ChangeNotifier {
  List<Map<String, dynamic>> selectedDishes = [];

  void addToBucket(Map<String, dynamic> dish) {
    selectedDishes.add(dish);
    notifyListeners();
  }

  void removeFromBucket(int index) {
    selectedDishes.removeAt(index);
    notifyListeners();
  }

  int getTotalDishes() {
    return selectedDishes.length;
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var dish in selectedDishes) {
      int price = dish['price'] ?? 0;
      totalPrice += price;
    }
    return totalPrice;
  }

  List<Map<String, dynamic>> getSelectedDishes() {
    return selectedDishes;
  }
}
