import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Enquiry {
  int id;
  String address;
  String? lat;
  String? lng;
  String Glat;
  String Glng;
  int companyId;
  int carId;
  String? company;
  String? carName;
  String? garageName;
  String? mobileNumber;
  String axel;
  String offeredPrice;
  String? dateTime;
  String status;
  String state;
  String? deliveryBoy;
  String? name;
  List<String> imagesUrls;
  List<String>? imagesUrlsEnquiry;
  Enquiry({
    required this.id,
    required this.address,
    this.lng,
    this.lat,
    required this.Glng,
    required this.Glat,
    required this.companyId,
    required this.carId,
    required this.axel,
    required this.offeredPrice,
    this.dateTime,
    required this.status,
    this.deliveryBoy,
    required this.state,
    this.name,
    this.mobileNumber,
    this.company,
    this.carName,
    required this.imagesUrls,
    this.imagesUrlsEnquiry,
    this.garageName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'lat': lat,
      'lng': lng,
      'Glat': Glat,
      'Glng': Glng,
      'company_id': companyId,
      'car_id': carId,
      'axel': axel,
      'offered_price': offeredPrice,
      'date_time': dateTime,
      'status': status,
      'delivery_boy': deliveryBoy,
      'state': state,
      'name': name,
      'mobile_number': mobileNumber,
      'company': company,
      'car_name': carName,
      'garage_image': imagesUrls,
      'image_urls': imagesUrlsEnquiry,
    };
  }

  factory Enquiry.fromMap(Map<String, dynamic> map) {
    return Enquiry(
      id: map['id'] as int,
      address: map['address'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
      Glat: map['Glat'] as String,
      Glng: map['Glng'] as String,
      companyId: map['company_id'] as int,
      carId: map['car_id'] as int,
      axel: map['axel'] as String,
      offeredPrice: map['offered_price'] as String,
      dateTime: map['date_time'] as String,
      status: map['status'] as String,
      state: map['state'] as String,
      mobileNumber:
          map['mobile_number'] != null ? map['mobile_number'] as String : null,
      company: map['company'] != null ? map['company'] as String : null,
      carName: map['car_name'] != null ? map['car_name'] as String : null,
      imagesUrls: map['garage_image'] != null
          ? map['garage_image'].toString().split(',')
          : [],
      imagesUrlsEnquiry: map['image_urls'] != null
          ? (map['image_urls'] as List<dynamic>).cast<String>()
          : [],
      garageName:
          map['garage_name'] != null ? map['garage_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Enquiry.fromJson(String source) =>
      Enquiry.fromMap(json.decode(source) as Map<String, dynamic>);
}
