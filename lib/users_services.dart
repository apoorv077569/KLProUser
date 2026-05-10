import 'package:klpro_user/config.dart';
import 'package:klpro_user/models/appernce_model.dart';
import 'package:klpro_user/models/category_advertisement_model.dart';

import 'models/app_setting_model.dart';

UserModel? userModel;

PrimaryAddress? userPrimaryAddress;

String? currentAddress, street;

LatLng? position;

String zoneIds = "";

int? setPrimaryAddress;

List<Services> servicePackageList = [];

List<CategoryModel> allCategoryList = [];

List<CategoryModel> homeCategoryList = [];
List<CategoryModel> homeHasSubCategoryList = [];
List<ServicePackageModel> homeServicePackagesList = [];
List<ProviderModel> homeProvider = [];
List<BlogModel> homeBlog = [];
List<Services> homeFeaturedService = [];
List<Services> homeServicesAdvertisements = [];
// AppearanceModel? appearanceList;
AppearanceModel? appearance;
CategoryAdvertisementModel? fetchBannerAds;
List<OnboardingModel> onboardingScreens = [];

bool? isGuest;

// Check if the current user is a Play Store Reviewer/Tester or Guest
Future<bool> isTesterMode() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool isGuestUser = pref.getBool(session.isContinueAsGuest) ?? false;
  List<String> testerEmails = ["demouser@gmail.com","nitin.softfix@gmail.com", "tester@gmail.com", "test@gmail.com"];
  
  if (isGuestUser) return true;
  if (userModel != null && testerEmails.contains(userModel!.email)) return true;
  
  return false;
}
