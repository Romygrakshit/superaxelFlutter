import 'package:loginuicolors/models/cars.dart';
import 'package:loginuicolors/models/companies.dart';
import 'package:loginuicolors/models/statesDecode.dart';

class Globals {
  static const restApiUrl = "http://139.59.77.55:3000";
  // static const restApiUrl = "https://superaxlecompany.in";
  static List<StateDecode> allStates = [];
  static String garageName = '';
  static String garageAddress = '';
  static int garageId = 0;
  static List<Cars> allCars = [];
  static List<Companies> allCompanies = [];
  static int subAdminId = 0;
  static String subAdminName = '';
  static String subAdminState = '';
  static String subAdminMobileNumber = '';
}
