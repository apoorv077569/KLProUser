import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/provider_details_screen/layouts/personal_detail_layout.dart';
import 'package:klpro_user/screens/app_pages_screens/service_review_screen/layouts/rating_layout.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class ProviderTopLayout extends StatelessWidget {
  const ProviderTopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderDetailsProvider>(
        builder: (context, providerCtrl, child) {
          log("providerCtrl::${providerCtrl.provider}");
          return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(isDark(context)
                          ? eImageAssets.providerBgDark
                          : eImageAssets.providerBg),
                      fit: BoxFit.fill)),
              child: providerCtrl.provider == null
                  ? const SizedBox()
                  : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfilePicCommon(
                      isProfile: false,
                      /* imageUrl: providerCtrl.provider!.media != null &&
                          providerCtrl.provider!.media!.isNotEmpty
                          ? "${providerCtrl.provider?.media?[0].originalUrl}"
                          : "", */
                      imageUrl: "",
                    ).alignment(Alignment.center),
                    const VSpace(Sizes.s8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              capitalizeFirstLetter(
                                  providerCtrl.provider?.name ?? ""),
                              style: appCss.dmDenseSemiBold14
                                  .textColor(appColor(context).darkText)),
                          const HSpace(Sizes.s6),
                          SvgPicture.asset(eSvgAssets.tick)
                        ]),
                    const VSpace(Sizes.s6),
                    IntrinsicHeight(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (providerCtrl.provider!.reviewRatings != null)
                                Column(children: [
                                  RatingLayout(
                                      initialRating:
                                      providerCtrl.provider!.reviewRatings !=
                                          null
                                          ? double.parse(providerCtrl
                                          .provider!.reviewRatings
                                          .toString())
                                          : 0.0,
                                      color: const Color(0xffFFC412)),
                                  Text(
                                      "${providerCtrl.provider!.reviewRatings ?? 0} ${language(context, translations!.reviews).toLowerCase()}",
                                      style: appCss.dmDenseMedium13
                                          .textColor(appColor(context).darkText))
                                ]).inkWell(onTap: () {
                                  final provider = Provider.of<MyReviewProvider>(
                                      context,
                                      listen: false);
                                  provider.getProviderReview(context,
                                      id: providerCtrl.provider?.id);

                                }),
                              if (providerCtrl.provider!.reviewRatings != null)
                                VerticalDivider(
                                    width: 1,
                                    color: appColor(context).stroke,
                                    indent: 3,
                                    endIndent: 3)
                                    .paddingSymmetric(horizontal: Insets.i10),
                              Text(
                                  "${providerCtrl.provider!.experienceDuration ?? 0} ${providerCtrl.provider!.experienceInterval != null ? capitalizeFirstLetter(providerCtrl.provider!.experienceInterval) : "Years"} ${translations!.of} ${language(context, translations!.experience)}",
                                  style: appCss.dmDenseMedium13
                                      .textColor(appColor(context).darkText))
                            ])),
                    const VSpace(Sizes.s20),
                    const DottedLines(),
                    const VSpace(Sizes.s10),
                    ServicesDeliveredLayout(
                        services: providerCtrl.provider?.served ?? "0"),
                    if (providerCtrl.provider!.description != null)
                      Text(language(context, translations!.detailsOfProvider),
                          style: appCss.dmDenseMedium12
                              .textColor(appColor(context).lightText))
                          .paddingOnly(top: Insets.i15, bottom: Insets.i8),
                    if (providerCtrl.provider!.description != null)
                      Text(providerCtrl.provider!.description ?? "",
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).darkText)),
                    Text(language(context, translations!.personalInfo),
                        style: appCss.dmDenseMedium12
                            .textColor(appColor(context).lightText))
                        .paddingOnly(top: Insets.i15, bottom: Insets.i8),
                    if (providerCtrl.provider!.phone != null ||
                        providerCtrl.provider!.email != null)
                      PersonalDetailLayout(
                        email: providerCtrl.provider!.email ?? "",
                        code: providerCtrl.provider!.code,
                        phone: providerCtrl.provider!.phone != null
                            ? "**********"
                            : "",
                        knownLanguage: providerCtrl.provider!.knownLanguages,
                      )
                  ]).paddingAll(Insets.i20));
        });
  }
}
