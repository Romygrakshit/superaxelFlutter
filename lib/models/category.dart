// {
//   "success": true,
//   "data": [
//     {
//       "id": 6,
//       "category_name": "Gear"
//     },
//     {
//       "id": 7,
//       "category_name": "Head light"
//     },
//     {
//       "id": 8,
//       "category_name": "Wheel"
//     },
//     {
//       "id": 9,
//       "category_name": "Engine"
//     },
//     {
//       "id": 11,
//       "category_name": "Horn"
//     }
//   ]
// }

import 'dart:convert';

class CategoryItems {
  int id;
  String categoryName;
  CategoryItems({
    required this.id,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_name': categoryName,
    };
  }

  factory CategoryItems.fromMap(Map<String, dynamic> map) {
    return CategoryItems(
      id: map['id'] as int,
      categoryName: map['category_name'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CategoryItems.fromJson(String source) => CategoryItems.fromMap(json.decode(source) as Map<String, dynamic>);
}
