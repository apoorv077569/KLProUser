import 'package:flutter/cupertino.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/drop_down_layout.dart';
import 'package:klpro_user/screens/app_pages_screens/search_screen/layouts/rating_bar_layout.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class ServiceFilterLayout extends StatelessWidget {
  const ServiceFilterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, ServicemanListProvider>(
        builder: (context1, lang, value, child) {
      return SizedBox(
          height: MediaQuery.of(context).size.height / 1.2,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    "${language(context, translations!.filterBy)} (${value.totalCountFilter()})",
                    style: appCss.dmDenseMedium18
                        .textColor(appColor(context).darkText)),
                const Icon(CupertinoIcons.multiply)
                    .inkWell(onTap: () => route.pop(context))
              ]).paddingSymmetric(horizontal: Insets.i20),
              Text(language(context, translations!.experience),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).lightText))
                  .padding(
                      horizontal: Insets.i20,
                      top: Insets.i10,
                      bottom: Insets.i15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(language(context, translations!.showServicemen),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText)),
                const VSpace(Sizes.s6),
                DropDownLayout(
                    icon: eSvgAssets.job,
                    val: value.yearValue,
                    isIcon: true,
                    isServiceManList: true,
                    categoryList: appArray.jobExperienceList,
                    onChanged: (val) => value.onTapYear(context, val))
              ])
                  .paddingAll(AppRadius.r15)
                  .boxShapeExtension(color: appColor(context).fieldCardBg)
                  .paddingSymmetric(horizontal: Insets.i20),
              Text(language(context, translations!.ratings),
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).lightText))
                  .padding(
                      horizontal: Insets.i20,
                      top: Insets.i10,
                      bottom: Insets.i15),
              ...appArray.ratingList.asMap().entries.map((e) => RatingBarLayout(
                  index: e.key,
                  data: e.value,
                  selectedIndex: value.selectedRates.contains(e.value["value"]),
                  onTap: () => value.onTapRating(e.value["value"]))),
              BottomSheetButtonCommon(
                  textOne: translations!.clearAll,
                  textTwo: translations!.apply,
                  applyTap: () => value.applyTap(context),
                  clearTap: () => value.clearTap(context))
            ]).paddingSymmetric(vertical: Insets.i20),
          )).bottomSheetExtension(context);
    });
  }
}
