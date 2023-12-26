import 'dart:convert';

class Cars {
  int id;
  String carName;
  Cars({
    required this.id,
    required this.carName,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'car_name': carName,
    };
  }

  factory Cars.fromMap(Map<String, dynamic> map) {
    return Cars(
      id: map['id'] as int,
      carName: map['car_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cars.fromJson(String source) => Cars.fromMap(json.decode(source) as Map<String, dynamic>);
}
