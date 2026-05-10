import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  List placePredictions = [];
  FocusNode focusNode = FocusNode();
  TextEditingController search = TextEditingController();
  Timer? _debounce;
  bool isLoading = false;

  placeAutoComplete(query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          placePredictions = [];
          isLoading = false;
        });
        return;
      }

      if (appSettingModel?.firebase?.googleMapApiKey == null ||
          appSettingModel!.firebase!.googleMapApiKey!.isEmpty) {
        log("Google Map API Key is missing in app settings.");
        return;
      }

      setState(() {
        isLoading = true;
      });

      String api =
          "https://places.googleapis.com/v1/places:autocomplete";
      
      try {
        var res = await http.post(
          Uri.parse(api),
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": appSettingModel!.firebase!.googleMapApiKey!,
          },
          body: jsonEncode({"input": query}),
        );

        if (res.statusCode == 200) {
          var data = jsonDecode(res.body);
          if (data['suggestions'] != null) {
            setState(() {
              placePredictions = data['suggestions'];
              isLoading = false;
            });
          } else {
            log("Places API (v1) No suggestions returned");
            setState(() {
              isLoading = false;
            });
          }
        } else {
          log("HTTP Error (v1): ${res.statusCode} - ${res.body}");
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        log("Error fetching place autocomplete (v1): $e");
        setState(() {
          isLoading = false;
        });
      }
    });

    setState(() {});
  }

  findCord(context, String placeID) async {
    if (appSettingModel?.firebase?.googleMapApiKey == null ||
        appSettingModel!.firebase!.googleMapApiKey!.isEmpty) {
      log("Google Map API Key is missing for place details.");
      return;
    }

    String request =
        "https://places.googleapis.com/v1/places/$placeID";

    try {
      var res = await http.get(
        Uri.parse(request),
        headers: {
          "X-Goog-Api-Key": appSettingModel!.firebase!.googleMapApiKey!,
          "X-Goog-FieldMask": "location,displayName",
        },
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data['location'] != null) {
          var location = data['location'];
          route.pop(context, arg: LatLng(location['latitude'], location['longitude']));
        } else {
          log("Place Details (v1) Error: No location data found");
        }
      } else {
        log("HTTP Error (v1): ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      log("Error fetching place details (v1): $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCommon(title: language(context, translations!.location)),
        body: ListView(
          children: [
            TextFieldCommon(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: appColor(context).stroke)),
                    focusNode: focusNode,
                    onChanged: (v) => placeAutoComplete(v),
                    controller: search,
                    hintText: language(context, translations!.searchHere),
                    prefixIcon: eSvgAssets.location)
                .paddingSymmetric(horizontal: Insets.i20),
            const VSpace(Sizes.s20),
            Divider(color: appColor(context).stroke, height: 0),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ).paddingSymmetric(vertical: Sizes.s20),
            if (placePredictions.isNotEmpty) const VSpace(Sizes.s20),
            ButtonCommon(
                margin: 20,
                onTap: () => route.pop(context),
                title: language(context, translations!.useCurrentLocation),
                icon: SvgPicture.asset(eSvgAssets.zipcode,
                    colorFilter: ColorFilter.mode(
                        appColor(context).whiteBg, BlendMode.srcIn))),
            const VSpace(Sizes.s20),
            ...placePredictions.asMap().entries.map((e) => LocationListTile(
                loc: e.value['placePrediction']['text']['text'],
                onTap: () {
                  log("dvghh:${e.value}");
                  findCord(context, e.value['placePrediction']['placeId']);
                })),
            if (placePredictions.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Powered by Google",
                  style: appCss.dmDenseRegular12
                      .textColor(appColor(context).lightText),
                ).paddingSymmetric(horizontal: Insets.i20, vertical: Insets.i10),
              ),
          ],
        ));
  }
}

class LocationListTile extends StatelessWidget {
  final String? loc;
  final GestureTapCallback? onTap;

  const LocationListTile({super.key, this.loc, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(eSvgAssets.location),
            const HSpace(Sizes.s10),
            Expanded(child: Text(loc ?? "")),
          ],
        ).inkWell(onTap: onTap),
        Divider(
          color: appColor(context).stroke,
          height: 0,
        ).paddingSymmetric(vertical: Sizes.s15)
      ],
    ).paddingSymmetric(horizontal: Sizes.s20);
  }
}
