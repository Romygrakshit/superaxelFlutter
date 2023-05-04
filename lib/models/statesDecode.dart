import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StateDecode {
  int id;
  String state; 
  StateDecode({
    required this.id,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'state': state,
    };
  }

  factory StateDecode.fromMap(Map<String, dynamic> map) {
    return StateDecode(
      id: map['id'] as int,
      state: map['state'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StateDecode.fromJson(String source) => StateDecode.fromMap(json.decode(source) as Map<String, dynamic>);
}
