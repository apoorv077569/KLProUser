import 'dart:developer';

import 'package:klpro_user/models/service_details_model.dart'
    show ServiceDetailsModel;
import 'package:klpro_user/models/service_model.dart';
import 'package:klpro_user/models/service_package_model.dart';

import '../config.dart';
// import your ServiceDetailsModel

class CartModel {
  int? id;
  bool? isPackage;
  List<ServicemanList>? servicemanList;
  dynamic serviceList; // currently dynamic, keep it for backward compatibility
  ServicePackageModel? servicePackageList;

  // Add new field for detailed service model (optional)
  ServiceDetailsModel? serviceDetailsModel;

  CartModel(
      {this.id,
      this.isPackage,
      this.servicemanList,
      this.servicePackageList,
      this.serviceList,
      this.serviceDetailsModel});

  CartModel.fromJson(Map<String, dynamic> json) {
    log("SSSS: $json");
    id = json['id'];
    isPackage = json['isPackage'] ?? false;

    if (json['servicemanList'] != null) {
      servicemanList = <ServicemanList>[];
      json['servicemanList'].forEach((v) {
        servicemanList!.add(ServicemanList.fromJson(v));
      });
    }

    if (json['serviceList'] != null) {
      serviceList = Services.fromJson(json['serviceList']);
    }

    if (json['servicePackageList'] != null) {
      servicePackageList = ServicePackageModel.fromJson(json['servicePackageList']);
      isPackage = true;
    }

    serviceDetailsModel = json['serviceDetailsModel'] != null
        ? ServiceDetailsModel.fromJson(json['serviceDetailsModel'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isPackage'] = isPackage;

    if (servicemanList != null) {
      data['servicemanList'] = servicemanList!.map((v) => v.toJson()).toList();
    }

    if (serviceList != null) {
      data['serviceList'] = serviceList!.toJson();
    }

    // New: include serviceDetailsModel if not null
    if (serviceDetailsModel != null) {
      data['serviceDetailsModel'] = serviceDetailsModel!.toJson();
    }

    if (servicePackageList != null) {
      data['servicePackageList'] = servicePackageList!.toJson();
    }

    return data;
  }

  static Map<String, dynamic> toMap(CartModel music) => {
        'isPackage': music.isPackage,
        'serviceList': music.serviceList,
        'servicePackageList': music.servicePackageList,
        'serviceDetailsModel': music.serviceDetailsModel,
      };
}

class ServicemanList {
  String? image;
  String? name;
  String? rating;

  ServicemanList({this.image, this.name, this.rating});

  ServicemanList.fromJson(Map<String, dynamic> json) {
    // OLD FORMAT Fallback
    // image = json['image'];
    // name = json['name'];
    // rating = json['rating'];

    // Support both formats (Old keys vs New API keys)
    name = json['name']?.toString();
    
    // Handle Image: Old 'image' key OR API 'media' list
    if (json['image'] != null) {
      image = json['image'];
    } else if (json['media'] != null && (json['media'] as List).isNotEmpty) {
      image = json['media'][0]['original_url'];
    }

    // Handle Rating: Old 'rating' key OR API 'serviceman_review_ratings'
    if (json['rating'] != null) {
      rating = json['rating'].toString();
    } else if (json['serviceman_review_ratings'] != null) {
      rating = json['serviceman_review_ratings'].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['rating'] = rating;
    return data;
  }
}

// import 'dart:developer';
//
// import 'package:fixit_user/models/service_details_model.dart';
//
// import '../config.dart';
//
// class CartModel {
//   bool? isPackage;
//   List<ServicemanList>? servicemanList;
//   dynamic serviceList;
//   ServicePackageModel? servicePackageList;
//
//   CartModel(
//       {this.isPackage,
//       this.servicemanList,
//       this.servicePackageList,
//       this.serviceList});
//
//   CartModel.fromJson(Map<String, dynamic> json) {
//     log("SSSS: $json");
//     isPackage = json['isPackage'];
//
//     if (json['servicemanList'] != null) {
//       servicemanList = <ServicemanList>[];
//       json['servicemanList'].forEach((v) {
//         servicemanList!.add(ServicemanList.fromJson(v));
//       });
//     }
//     json['serviceList'] != null ? Services.fromJson(json['serviceList']) : null;
//     json['servicePackageList'] != null
//         ? ServicePackageModel.fromJson(json['servicePackageList'])
//         : null;
//     log("ABC : ${json['servicePackageList']}");
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['isPackage'] = isPackage;
//
//     if (servicemanList != null) {
//       data['servicemanList'] = servicemanList!.map((v) => v.toJson()).toList();
//     }
//     if (serviceList != null) {
//       data['serviceList'] = serviceList!.toJson();
//     }
//     if (servicePackageList != null) {
//       data['servicePackageList'] = servicePackageList!.toJson();
//     }
//     return data;
//   }
//
//   static Map<String, dynamic> toMap(CartModel music) => {
//         'isPackage': music.isPackage,
//         'serviceList': music.serviceList?.toJson(), // FIX: add .toJson()
//         'servicePackageList':
//             music.servicePackageList?.toJson(), // FIX: add .toJson()
//       };
// }
//
// class ServicemanList {
//   String? image;
//   String? name;
//   String? rating;
//
//   ServicemanList({this.image, this.name, this.rating});
//
//   ServicemanList.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//     name = json['name'];
//     rating = json['rating'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['image'] = image;
//     data['name'] = name;
//     data['rating'] = rating;
//     return data;
//   }
// }
