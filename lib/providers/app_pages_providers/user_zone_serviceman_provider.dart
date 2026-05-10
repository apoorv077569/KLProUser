import 'dart:developer';
import 'package:klpro_user/config.dart';

class UserZoneServicemanProvider with ChangeNotifier {
  List<ProviderModel> userZoneServicemanList = [];
  bool isLoading = true;

  // Get User Zone Servicemen
  Future<void> getUserZoneServicemen(context) async {
    isLoading = true;
    notifyListeners();
    try {
      await apiServices.getApi(api.userZoneServicemen, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          userZoneServicemanList = [];
          List data = value.data;
          for (var provider in data) {
            userZoneServicemanList.add(ProviderModel.fromJson(provider));
          }
          log("userZoneServicemanList count: ${userZoneServicemanList.length}");
        } else {
          log("Error fetching user zone servicemen: ${value.message}");
        }
        isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      log("Exception in getUserZoneServicemen: $e");
      notifyListeners();
    }
  }

  // Clear data
  void clearData() {
    userZoneServicemanList = [];
    isLoading = true;
    notifyListeners();
  }
}
