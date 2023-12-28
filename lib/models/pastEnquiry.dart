import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PastEnquiry {
  int id;
  String address;
  String axel;
  String offeredPrice;
  String status;
  String carName;
  String company;
  String imageUrl;
  String state;

  PastEnquiry({
    required this.id,
    required this.address,
    required this.status,
    required this.carName,
    required this.company,
    required this.imageUrl,
    required this.state,
    required this.axel,
    required this.offeredPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'axel': axel,
      'status': status,
      'company': company,
      'car_name': carName,
      'image_url': imageUrl,
      'state': state,
      'offered_price': offeredPrice,
    };
  }

  factory PastEnquiry.fromMap(Map<String, dynamic> map) {
    return PastEnquiry(
      id: map['id'] as int,
      company: map['company'] as String,
      imageUrl: map['url'] as String,
      state: map['state'] as String,
      address: map['address'] as String,
      axel: map['axel'] != null ? map['axel'] as String : '',
      offeredPrice: map['offered_price'] != null ? map['offered_price'] as String : '',
      status: map['status'] as String,
      carName: map['car_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PastEnquiry.fromJson(String source) => PastEnquiry.fromMap(json.decode(source) as Map<String, dynamic>);
}
