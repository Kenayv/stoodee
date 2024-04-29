import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternetConectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  // Iterate through the list and check each item
  for (var result in connectivityResult) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true; // Device has internet connection
    }
  }
  return false; // Device does not have internet connection
}
