import 'package:flutter/material.dart';
import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/services/garagesService.dart';
import 'package:loginuicolors/services/subAdminService.dart';
import 'package:loginuicolors/utils/Globals.dart';

class CreateInventory extends StatefulWidget {
  const CreateInventory({super.key});

  @override
  State<CreateInventory> createState() => _CreateInventoryState();
}

class _CreateInventoryState extends State<CreateInventory> {
  String? _selectedCompany;
  String? _selectedCar;
  int? _carId;
  bool isLocation = false;
  double lat = 0;
  double long = 0;
  String address = '';
  bool companySelected = false;
  bool carSelected = false;
  TextEditingController leftPrice = TextEditingController();
  TextEditingController leftInventory = TextEditingController();
  TextEditingController rightprice = TextEditingController();
  TextEditingController rightInventory = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  createInventory() {
    if (_formKey.currentState!.validate()) {
      SubAdminService.createInventory(
          _selectedCar.toString(),
          Globals.subAdminId.toString(),
          leftPrice.text,
          leftInventory.text,
          rightprice.text,
          rightInventory.text,
          context);
    }
  }

  @override
  void initState() {
    super.initState();
    leftPrice.text = Globals.leftAxlePrice;
    rightprice.text = Globals.rightAxlePrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Company',
              ),
              value: _selectedCompany,
              items: [
                for (Companies company in Globals.allCompanies)
                  DropdownMenuItem(
                      value: company.company, child: Text("${company.company}"))
              ],
              hint: const Text('Select an option'),
              onChanged: (value) async {
                List<Cars> cars =
                    await GaragesService.getAllCars(value.toString());
                Globals.allCars = cars;
                setState(() {
                  _selectedCompany = value.toString();
                  companySelected = true;
                  carSelected = false;
                  _selectedCar = null;
                  _carId = null;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            if (companySelected)
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Car',
                ),
                value: _carId,
                items: [
                  for (Cars car in Globals.allCars)
                    DropdownMenuItem(value: car.id, child: Text(car.carName))
                ],
                hint: const Text('Select an option'),
                onChanged: (value) async {
                  setState(() {
                    _selectedCar = Globals.allCars
                        .firstWhere((element) => element.id == value)
                        .carName;
                    _carId = value as int;
                    print(_carId.runtimeType);
                    carSelected = true;
                  });
                  await SubAdminService.getInventry(_carId!,context);
                  setState(() {
                    leftPrice.text = Globals.leftAxlePrice;
                    rightprice.text = Globals.rightAxlePrice;
                  });
                },
              ),
            SizedBox(
              height: 30,
            ),
            if (carSelected)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      validator: (value) {
                        if (value!.length > 1)
                          return null;
                        else
                          return "Enter the value";
                      },
                      controller: leftPrice,
                      decoration: InputDecoration(
                          labelText: 'Left Axel Price',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.length > 1)
                          return null;
                        else
                          return "Enter the value";
                      },
                      controller: leftInventory,
                      decoration: InputDecoration(
                          labelText: 'Left Axel Inventory',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      validator: (value) {
                        if (value!.length > 1)
                          return null;
                        else
                          return "Enter the value";
                      },
                      controller: rightprice,
                      decoration: InputDecoration(
                          labelText: 'Right Axel Price',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.length > 1)
                          return null;
                        else
                          return "Enter the value";
                      },
                      controller: rightInventory,
                      decoration: InputDecoration(
                          labelText: 'Right Axel Inventory',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () => createInventory(),
                      child: Text("Submit"),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    ));
  }
}
