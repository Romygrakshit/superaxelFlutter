import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/category.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/statesDecode.dart';

class Globals {
  static const restApiUrl = "http://139.59.77.55:3000";
  // static const restApiUrl = "https://superaxlecompany.in";
  static List<StateDecode> allStates = [];
  static List<dynamic> allCity = [];
  static String garageName = '';
  static String garageAddress = '';
  static String garageFcmtoken = '';
  static int garageId = 0;
  static List<Cars> allCars = [];
  static List<CategoryItems> allCategoryItems = [];
  static List<Companies> allCompanies = [];
  static int subAdminId = 0;
  static String subAdminName = '';
  static String subAdminState = '';
  static String subAdminDeviceToken = '';
  static String subAdminMobileNumber = '';

  // Inventry values by car_id
  static String leftAxlePrice = "";
  static String rightAxlePrice = "";
}
