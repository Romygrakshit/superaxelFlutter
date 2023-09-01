import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PastEnquiry {
  int id;
  // int garage_id;
  String address;
  // String lat;
  // String lng;
  // int company_id;
  // int car_id;
  String axel;
  String offeredPrice;
  // String date_time;
  String status;
  // String images_id;
  // String delivery_boy;
  // String? name;
  // String? mobile_number;
  // String company;
  String car_name;
  // int deleted;

  // new data
  String company;
  String imageUrl;
  String state;

  PastEnquiry({
    // this.name,
    // this.mobile_number,
    required this.id,
    required this.address,
    required this.status,
    required this.car_name,
    required this.company,
    required this.imageUrl,
    required this.state,
    required this.axel,
    required this.offeredPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      // 'garage_id': garage_id,
      // 'address': address,
      // 'lat': lat,
      // 'lng': lng,
      // 'company_id': company_id,
      // 'car_id': car_id,
      'axel': axel,
      // 'offered_price': offered_price,
      // 'date_time': date_time,
      'status': status,
      // 'images_id': images_id,
      // 'delivery_boy': delivery_boy,
      // 'name': name,
      // 'mobile_number': mobile_number,
      'company': company,
      'car_name': car_name,
      // 'deleted': deleted,
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
      // garage_id: map['garage_id'] as int,
      address: map['address'] as String,
      // lat: map['lat'] as String,
      // lng: map['lng'] as String,
      // company_id: map['company_id'] as int,
      // car_id: map['car_id'] as int,
      axel: map['axel'] != null ? map['axel'] as String : '',
      offeredPrice: map['offered_price'] != null ? map['offered_price'] as String : '',
      // date_time: map['date_time'] as String,
      status: map['status'] as String,
      // images_id: map['images_id'] as String,
      // delivery_boy: map['delivery_boy'] != null ? map['delivery_boy'] as String : "",
      // name: map['name'] != null ? map['name'] as String : null,
      // mobile_number: map['mobile_number'] != null ? map['mobile_number'] as String : null,
      // company: map['company'] as String,
      car_name: map['car_name'] as String,
      // deleted: map['deleted'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PastEnquiry.fromJson(String source) => PastEnquiry.fromMap(json.decode(source) as Map<String, dynamic>);
}
