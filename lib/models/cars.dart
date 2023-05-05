import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cars {
  int id;
  String car_name;
  Cars({
    required this.id,
    required this.car_name,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'car_name': car_name,
    };
  }

  factory Cars.fromMap(Map<String, dynamic> map) {
    return Cars(
      id: map['id'] as int,
      car_name: map['car_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cars.fromJson(String source) => Cars.fromMap(json.decode(source) as Map<String, dynamic>);
}
