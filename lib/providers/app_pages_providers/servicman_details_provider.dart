import 'dart:developer';

import 'package:klpro_user/config.dart';

class ServicemanDetailProvider with ChangeNotifier {
  int providerId = 0;
  ProviderModel? provider;

  onReady(context) async {
    showLoading(context);
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    notifyListeners();
    log("idid : $data");
    getServicemanById(context, data);
  }

  getServicemanById(context, id) async {
    try {
      debugPrint("APPU_DEBUG SERVICEMAN DETAIL API DISABLED");

      provider = ProviderModel(
        id: 1,

        name: "Rahul Sharma",

        email: "rahul@gmail.com",

        phone: 9876543210,

        experienceDuration: 5,

        experienceInterval: "Years",

        reviewRatings: 4.8,

        reviewCount: 120,

        served: "2500",

        description:
            "Professional home service expert with multiple years of experience.",

        media: [Media(originalUrl: "https://i.pravatar.cc/300?img=1")],

        primaryAddress: PrimaryAddress(address: "Kanpur, Uttar Pradesh"),
      );

      hideLoading(context);

      notifyListeners();
    } catch (e) {
      hideLoading(context);

      debugPrint("APPU_DEBUG ERROR => $e");

      notifyListeners();
    }
  }
}
