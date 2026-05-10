import 'dart:convert';

IsValidTimeSlotModel isValidTimeSlotModelFromJson(String str) => IsValidTimeSlotModel.fromJson(json.decode(str));

String isValidTimeSlotModelToJson(IsValidTimeSlotModel data) => json.encode(data.toJson());

class IsValidTimeSlotModel {
    bool? success;
    bool? isValidTimeSlot;
    List<AvailableProvider>? data;

    IsValidTimeSlotModel({
        this.success,
        this.isValidTimeSlot,
        this.data,
    });

    factory IsValidTimeSlotModel.fromJson(Map<String, dynamic> json) => IsValidTimeSlotModel(
        success: json["success"],
        isValidTimeSlot: json["isValidTimeSlot"],
        data: json["data"] == null ? [] : List<AvailableProvider>.from(json["data"]!.map((x) => AvailableProvider.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "isValidTimeSlot": isValidTimeSlot,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class AvailableProvider {
    int? id;
    String? name;
    num? reviewRatings;
    String? profileImage;

    AvailableProvider({
        this.id,
        this.name,
        this.reviewRatings,
        this.profileImage,
    });

    factory AvailableProvider.fromJson(Map<String, dynamic> json) => AvailableProvider(
        id: json["id"],
        name: json["name"],
        reviewRatings: json["review_ratings"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "review_ratings": reviewRatings,
        "profile_image": profileImage,
    };
}
