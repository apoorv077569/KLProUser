import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/county_drop_down.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/state_drop_down.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class LocationTextFieldLayout extends StatelessWidget {
  const LocationTextFieldLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewLocationProvider>(
      builder: (context2, value, child) {
        return Consumer<LocationProvider>(
          builder: (context2, locationCtrl, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textCommon.dmSensMediumDark14(
                  context,
                  text: translations!.street,
                ),
                const VSpace(Sizes.s8),
                TextFieldCommon(
                  validator: (add) =>
                      validation.addressValidation(context, add),
                  controller: value.streetCtrl,
                  onChanged: (v) {
                    if (v.trim().length >= 3) {
                      value.placeAutoComplete(v, context);
                    }
                  },
                  hintText:
                      translations!.street ??
                      language(context, appFonts.street),
                  focusNode: value.streetFocus,
                  prefixIcon: eSvgAssets.address,
                ),
                if (value.isSearching)
                  const Center(
                    child: CircularProgressIndicator(),
                  ).paddingSymmetric(vertical: Sizes.s10),
                if (value.placePredictions.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: Sizes.s200),
                    margin: const EdgeInsets.only(top: Insets.i10),
                    decoration: BoxDecoration(
                      color: appColor(context).whiteBg,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      boxShadow: [
                        BoxShadow(
                          color: appColor(context).darkText.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(Insets.i10),
                      itemCount: value.placePredictions.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: appColor(context).stroke, height: 1),
                      itemBuilder: (context, index) {
                        var prediction = value.placePredictions[index];
                        return ListTile(
                          leading: SvgPicture.asset(
                            eSvgAssets.location,
                            colorFilter: ColorFilter.mode(
                              appColor(context).primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          title: Text(
                            prediction['placePrediction']?['text']?['text'] ??
                                "",
                            style: appCss.dmDenseRegular14.textColor(
                              appColor(context).darkText,
                            ),
                          ),
                          onTap: () => value.findCord(
                            context,
                            prediction['placePrediction']['placeId'],
                          ),
                        );
                      },
                    ),
                  ),
                if (value.placePredictions.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Powered by Google",
                      style: appCss.dmDenseRegular12.textColor(
                        appColor(context).lightText,
                      ),
                    ).paddingSymmetric(vertical: Insets.i5),
                  ),
                const VSpace(Sizes.s15),
                textCommon.dmSensMediumDark14(
                  context,
                  text: translations!.country,
                ),
                const VSpace(Sizes.s8),
                const CountryDropDown(),
                const VSpace(Sizes.s15),
                textCommon.dmSensMediumDark14(
                  context,
                  text: translations!.state,
                ),
                const VSpace(Sizes.s8),
                const StateDropDown(),
                const VSpace(Sizes.s18),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textCommon.dmSensMediumDark14(
                            context,
                            text: translations!.city,
                          ),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                            validator: (city) =>
                                validation.cityValidation(context, city),
                            controller: value.cityCtrl,
                            focusNode: value.cityFocus,
                            hintText:
                                translations!.city ??
                                language(context, appFonts.city),
                            prefixIcon: eSvgAssets.cityLoc,
                          ),
                        ],
                      ),
                    ),
                    const HSpace(Sizes.s18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textCommon.dmSensMediumDark14(
                            context,
                            text: translations!.zipCode,
                          ),
                          const VSpace(Sizes.s8),
                          TextFieldCommon(
                            validator: (zip) =>
                                validation.cityValidation(context, zip),
                            controller: value.zipCtrl,
                            focusNode: value.zipFocus,
                            hintText:
                                translations!.zipCode ??
                                language(context, appFonts.zipCode),
                            prefixIcon: eSvgAssets.zipcode,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const VSpace(Sizes.s15),
                textCommon.dmSensMediumDark14(
                  context,
                  text: translations!.personName,
                ),
                const VSpace(Sizes.s8),
                TextFieldCommon(
                  controller: value.nameCtrl,
                  /* validator:  (zip) => validation.nameValidation(context, zip), */
                  focusNode: value.nameFocus,
                  hintText:
                      translations!.personName ??
                      language(context, appFonts.personName),
                  prefixIcon: eSvgAssets.user,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
