// {
//   "success": true,
//   "data": [
//     {
//       "id": 1,
//       "garage_id": 82,
//       "category_id": 8,
//       "company_id": 8,
//       "car_id": 325,
//       "state": "Rajasthan",
//       "price": 1500
//     },
//     {
//       "id": 3,
//       "garage_id": 82,
//       "category_id": 8,
//       "company_id": 2,
//       "car_id": 326,
//       "state": "Rajasthan",
//       "price": 2600
//     }
//   ]
// }

class ProductSUbadmin {
  final int id;
  final String company;
  final String carName;
  final String garageName;
  // final int categoryId;
  // final int companyId;
  // final int carId;
  final String state;
  final int price;
  final String categoryName;

  ProductSUbadmin({
    required this.id,
    required this.company,
    required this.carName,
    required this.garageName,
    required this.categoryName,
    // required this.categoryId,
    // required this.companyId,
    // required this.carId,
    required this.state,
    required this.price,
  });

  factory ProductSUbadmin.fromMap(Map<String, dynamic> json) => ProductSUbadmin(
        id: json["id"],
        // garageId: json["garage_id"] != null ? json["garage_id"] : 0,
        // categoryId: json["category_id"],
        // companyId: json["company_id"] != null ? json["company_id"] : 0,
        // carId: json["car_id"] != null ? json["car_id"] : 0,
        state: json["state"],
        price: json["price"],

        company: json["company"],
        carName: json["car_name"],
        garageName: json["garage_name"],
        categoryName: json["category_name"],
      );

  // Map<String, dynamic> toMap() => {
  //       "id": id,
  //       "garage_id": garageId,
  //       "category_id": categoryId,
  //       "company_id": companyId,
  //       "car_id": carId,
  //       "state": state,
  //       "price": price,
  //     };
}
