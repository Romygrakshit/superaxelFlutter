import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PastEnquiry {
  int id;
  int garage_id;
  String address;
  String lat;
  String lng;
  int company_id;
  int car_id;
  String axel;
  String offered_price;
  String date_time;
  String status;
  String image_id;
  String delivery_boy;
  String? name;
  String? mobile_number;
  String company;
  String car_name;
  int deleted;
  PastEnquiry({
    required this.id,
    required this.garage_id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.company_id,
    required this.car_id,
    required this.axel,
    required this.offered_price,
    required this.date_time,
    required this.status,
    required this.image_id,
    required this.delivery_boy,
    this.name,
    this.mobile_number,
    required this.company,
    required this.car_name,
    required this.deleted,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'garage_id': garage_id,
      'address': address,
      'lat': lat,
      'lng': lng,
      'company_id': company_id,
      'car_id': car_id,
      'axel': axel,
      'offered_price': offered_price,
      'date_time': date_time,
      'status': status,
      'image_id': image_id,
      'delivery_boy': delivery_boy,
      'name': name,
      'mobile_number': mobile_number,
      'company': company,
      'car_name': car_name,
      'deleted': deleted,
    };
  }

  factory PastEnquiry.fromMap(Map<String, dynamic> map) {
    return PastEnquiry(
      id: map['id'] as int,
      garage_id: map['garage_id'] as int,
      address: map['address'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
      company_id: map['company_id'] as int,
      car_id: map['car_id'] as int,
      axel: map['axel'] as String,
      offered_price: map['offered_price'] as String,
      date_time: map['date_time'] as String,
      status: map['status'] as String,
      image_id: map['image_id'] as String,
      delivery_boy: map['delivery_boy'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      mobile_number: map['mobile_number'] != null ? map['mobile_number'] as String : null,
      company: map['company'] as String,
      car_name: map['car_name'] as String,
      deleted: map['deleted'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PastEnquiry.fromJson(String source) => PastEnquiry.fromMap(json.decode(source) as Map<String, dynamic>);
}
