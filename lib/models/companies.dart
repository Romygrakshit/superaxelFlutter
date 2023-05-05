import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Companies {
  int id;
  String company; 
  Companies({
    required this.id,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'company': company,
    };
  }

  factory Companies.fromMap(Map<String, dynamic> map) {
    return Companies(
      id: map['id'] as int,
      company: map['company'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Companies.fromJson(String source) => Companies.fromMap(json.decode(source) as Map<String, dynamic>);
}
