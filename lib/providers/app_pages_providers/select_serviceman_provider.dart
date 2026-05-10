import 'dart:convert';
import 'dart:developer';

import 'package:klpro_user/common_tap.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/users_services.dart';
import 'package:provider/provider.dart';

class SelectServicemanProvider with ChangeNotifier {
  ServicePackageModel? servicePackageModel;

  ProviderModel? providerModel;

  onReady(context) {
    servicePackageList = [];
    notifyListeners();
    /* appArray.servicePackageList.asMap().entries.forEach((element) {
      if(!servicePackageList.contains(SelectServicePackageModel.fromJson(element.value))) {
        servicePackageList.add(SelectServicePackageModel.fromJson(element.value));
      }
    });*/
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    // log("data : $data");
    servicePackageModel = data['services'];
    servicePackageList = servicePackageModel!.services!;
    providerModel = servicePackageModel!.user;

    notifyListeners();
  }

  /*onBook(context, index, {final GestureTapCallback? minusTap, addTap}) {

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context1) {
        return StatefulBuilder(builder: (context2, setState) {
          return Consumer<SelectServicemanProvider>(
              builder: (context3, value, child) {
            return BookYourServiceLayout(
              services: servicePackageList[index],
              isPackage: true,
              price: servicePackageList[index].price!,
              packageServiceId: index,
              style: appCss.dmDenseSemiBold18
                  .textColor(appColor(context).primary),
              providerModel: providerModel,
              requiredServiceMan: (
                  servicePackageList[index].selectedRequiredServiceMan ?? "1"),
              addTap: addTap,
              minusTap: minusTap,
            );
          });
        });
      },
    ).then((value) {
      log("dsdfdfg :$value");

      if (value == null) {
        servicePackageList.asMap().entries.forEach((element) {
          element.value.selectedRequiredServiceMan =
              element.value.requiredServicemen;
          notifyListeners();
        });
      } else {
        servicePackageList[index] = value;
      }
      notifyListeners();
    });
  }*/

  onTapBook(context,
      {service,
      ProviderModel? providerModel,
      index,
      selectProviderIndex,
      providerId,
      isPackage = false}) async {
    log("service:$service");
    isOpen = false;
    notifyListeners();
// route.pop(context);
    Services selectServicesCart = Services(
      id: service.id != null ? int.parse(service.id.toString()) : null,
// categories: service.categories,
      title: service.title,
      description: service.description,
      duration: service.duration,
      durationUnit: service.durationUnit,
      isFeatured: service.isFeatured != null
          ? int.parse(service.isFeatured.toString())
          : null,
// isMultipleServiceman: service.isMultipleServiceman,
      media: service.media,
      discount: service.discount != null
          ? double.tryParse(service.discount.toString())
          : null,
      discountAmount: service.discountAmount ?? "0",
      tax: service.tax,
      taxes: service.taxes != null
          ? (service.taxes as List)
              .map((e) => Tax(
                  id: e.id != null ? int.tryParse(e.id.toString()) : null,
                  name: e.name,
                  rate: e.rate != null ? double.tryParse(e.rate.toString()) : null,
                  amount: e.amount))
              .toList()
          : [],
      video: service.video,
      faqs: service.faqs ?? [],
// metaDescription: service.metaDescription,
      price: service.price,
// ratingCount: service.ratingCount,
      status: service.status != null
          ? int.tryParse(service.status.toString())
          : null,
      serviceRate: service.serviceRate,
      userId: providerId,
      type: service.type.toString(),
      requiredServicemen: service.requiredServicemen != null
          ? int.tryParse(service.requiredServicemen.toString())
          : null,
      advancePaymentEnabled: service.advancePaymentEnabled ?? false,
      advancePaymentPercentage: service.advancePaymentPercentage,
      selectServiceManType:
          selectProviderIndex == 0 ? "app_choose" : "as_per_my_choice",
// serviceDate: service.serviceDate,
      // reviewRatings: service.reviewRatings,
      // relatedServices: service.relatedServices,
      // selectedDateTimeFormat: service.selectedDateTimeFormat,
      user: providerModel /* ?? */ /* service.user */,
      selectDateTimeOption: "custom",
// reviews: service.reviews,
      selectedRequiredServiceMan: service.requiredServicemen != null
          ? int.tryParse(service.requiredServicemen.toString())
          : null,
      selectedAdditionalServices: service.selectedAdditionalServices,
      /* primaryAddress: service.primaryAddress*/
    );

    log("widget.isService :${selectServicesCart.selectedAdditionalServices}");

/* bool isAvailable = selectServicesList.where((element) => element.id == id).isNotEmpty;

   if(isAvailable){
   int index = selectServicesList.indexWhere((element) => element.id == id);
   selectServicesList.removeAt(index);
   selectServicesList.add(selectServicesCart);
   }else{
   selectServicesList.add(selectServicesCart);
   }*/

    notifyListeners();
    log("PACKAGE: $index");
    if (selectProviderIndex == 0) {
      route.pushNamed(context, routeName.slotBookingScreen, arg: {
        "selectServicesCart": selectServicesCart,
        "isPackage": isPackage,
        "selectProviderIndex": selectProviderIndex // Pass the actual user selection (0 = app_choose)
      }).then((e) {
        route.pop(context);
        if (e != null) {
          if (isPackage && index != null) {
            Services services = e;
            notifyListeners();

            servicePackageList[index].selectServiceManType =
                services.selectServiceManType;
            servicePackageList[index].selectedServiceMan = null;
            notifyListeners();
          }
          notifyListeners();
        }
        notifyListeners();
      });
    } else {
      route.pushNamed(context, routeName.serviceSelectedUserScreen, arg: {
        "selectServicesCart": selectServicesCart,
        "isPackage": isPackage,
        "selectProviderIndex": selectProviderIndex // Pass the actual user selection (1 = as_per_my_choice)
      }).then((e) {
        route.pop(context);
        selectProviderIndex = 0;
        notifyListeners();
        if (e != null) {
          if (isPackage && index != null) {
            Services services = e;
            servicePackageList[index].selectServiceManType =
                services.selectServiceManType;
            notifyListeners();
          }
        }
      });
      notifyListeners();
    }
  }

  onRemoveService(context, index) async {
    if ((servicePackageList[index].selectedRequiredServiceMan!) == 1) {
      route.pop(context);
      isAlert = false;
      notifyListeners();
    } else {
      if ((servicePackageList[index].requiredServicemen!) ==
          (servicePackageList[index].selectedRequiredServiceMan!)) {
        isAlert = true;
        notifyListeners();
        await Future.delayed(DurationClass.s3);
        isAlert = false;
        notifyListeners();
      } else {
        isAlert = false;
        notifyListeners();
        servicePackageList[index].selectedRequiredServiceMan =
            ((servicePackageList[index].selectedRequiredServiceMan!) - 1);
      }
    }
    notifyListeners();
  }

  onAdd(index) {
    isAlert = false;
    notifyListeners();
    int count = (servicePackageList[index].selectedRequiredServiceMan!);
    count++;
    servicePackageList[index].selectedRequiredServiceMan = count;

    notifyListeners();
  }

  bool buttonVisible(context) {
    int count = 0;

    servicePackageList.asMap().entries.forEach((element) {
      if (element.value.serviceDate != null) {
        count++;
      }
    });

    return count == servicePackageList.length ? true : false;
  }

  onBack() async {
    servicePackageList.asMap().entries.forEach((element) {
      element.value.selectedRequiredServiceMan =
          element.value.requiredServicemen;
      element.value.serviceDate = null;
      element.value.selectedDateTimeFormat = null;
      element.value.selectedServiceMan = null;
      element.value.selectDateTimeOption = null;
      element.value.selectServiceManType = null;
      notifyListeners();
    });
  }

  addToCart(context) async {
    final cartCtrl = Provider.of<CartProvider>(context, listen: false);

    servicePackageModel!.services = servicePackageList;
    notifyListeners();

    int index = cartCtrl.cartList.indexWhere((element) =>
        element.isPackage == true &&
        element.servicePackageList != null &&
        element.servicePackageList!.id == servicePackageModel!.id);
    log("index :$index");
    if (index >= 0) {
      //snackBarMessengers(context, message: "Package Already Added");
    } else {
      CartModel cartModel =
          CartModel(isPackage: true, servicePackageList: servicePackageModel);
      cartCtrl.cartList.add(cartModel);
      cartCtrl.notifyListeners();
    }
    notifyListeners();
    log("CART: ${cartCtrl.cartList.map((e) => e.toString()).toList()}");

    cartCtrl.notifyListeners();

    if (cartCtrl.isEditing) {
      CartModel updatedCartItem =
          CartModel(isPackage: true, servicePackageList: servicePackageModel);
      await cartCtrl.updateCartItemApi(context, updatedCartItem);
    } else {
      cartCtrl.syncCartWithApi(context);
      cartCtrl.checkout(context);
      route.pushNamed(context, routeName.cartScreen);
    }
  }
}
