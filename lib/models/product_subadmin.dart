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
  final int garageId;
  final int categoryId;
  final int companyId;
  final int carId;
  final String state;
  final int price;

  ProductSUbadmin({
    required this.id,
    required this.garageId,
    required this.categoryId,
    required this.companyId,
    required this.carId,
    required this.state,
    required this.price,
  });

  factory ProductSUbadmin.fromMap(Map<String, dynamic> json) => ProductSUbadmin(
        id: json["id"],
        garageId: json["garage_id"],
        categoryId: json["category_id"],
        companyId: json["company_id"],
        carId: json["car_id"],
        state: json["state"],
        price: json["price"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "garage_id": garageId,
        "category_id": categoryId,
        "company_id": companyId,
        "car_id": carId,
        "state": state,
        "price": price,
      };
}
