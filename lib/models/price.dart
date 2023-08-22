// ignore_for_file: public_member_api_docs, sort_constructors_first
// {
//   "success": true,
//   "data": [
//     {
//       "product_id": 15,
//       "category_name": "Engine",
//       "company_name": "Suzuki",
//       "car_name": "shift dzire",
//       "price": 569320,
//       "inventory": 45630,
//       "state": "Punjab"
//     }
//   ]
// }

import 'dart:convert';

class Price {
  int productId;
  String categoryName;
  String companyName;
  String carName;
  int price;
  int inventory;
  String state;
  Price({
    required this.productId,
    required this.categoryName,
    required this.companyName,
    required this.carName,
    required this.price,
    required this.inventory,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'categoryName': categoryName,
      'companyName': companyName,
      'carName': carName,
      'price': price,
      'inventory': inventory,
      'state': state,
    };
  }

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      productId: map['product_id'] as int,
      categoryName: map['category_name'] as String,
      companyName: map['company_name'] as String,
      carName: map['car_name'] as String,
      price: map['price'] as int,
      inventory: map['inventory'] as int,
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Price.fromJson(String source) => Price.fromMap(json.decode(source) as Map<String, dynamic>);
}
