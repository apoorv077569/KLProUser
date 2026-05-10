import 'dart:developer';

import 'package:klpro_user/config.dart';

class DubaiServices extends StatelessWidget {
  const DubaiServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ServicesDetailsProvider, DashboardProvider,
            ChatHistoryProvider>(
        builder: (context, serviceCtrl, dash, chat, child) {
      return Column(children: [
        if (homeFeaturedService.isNotEmpty)
          HeadingRowCommon(
              title: translations?.featuredService ?? "",
              isTextSize: true,
              onTap: () {
                // Navigate immediately — screen's fetchData handles API + shimmer
                dash.featuredServiceList = [];
                dash.notifyListeners();
                route.pushNamed(context, routeName.featuredServiceScreen);
              }).paddingSymmetric(horizontal: Insets.i20),
        const VSpace(Sizes.s15),
        GridView.builder(
            padding: EdgeInsets.zero,
            itemCount: homeFeaturedService.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260,
                mainAxisSpacing: Sizes.s10,
                crossAxisSpacing: Sizes.s10),
            itemBuilder: (context, index) {
              final service = homeFeaturedService[index];
              return Container(
                  margin: const EdgeInsets.all(Insets.i10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          service.media != null &&
                                  service.media!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Insets.i7),
                                  child: CommonImageLayout(
                                      tlRadius: 0,
                                      tRRadius: 0,
                                      blRadius: 0,
                                      bRRadius: 0,
                                      isAllBorderRadius: false,
                                      image: service
                                          .media
                                          ?.first
                                          .originalUrl,
                                      boxFit: BoxFit.cover,
                                      height: Sizes.s100,
                                      assetImage: eImageAssets.noImageFound2))
                              : CommonCachedImage(
                                  tlRadius: 0,
                                  tRRadius: 0,
                                  blRadius: 0,
                                  bRRadius: 0,
                                  isAllBorderRadius: false,
                                  height: Sizes.s100,
                                  image: eImageAssets.noImageFound2),
                          if (service.discount != null &&
                              service.discount! > 0)
                            Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                        "${service.discountDisplay}%",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))))
                        ]),
                        const VSpace(Sizes.s10),
                        Text(
                            capitalizeFirstLetter(
                                service.title ?? ""),
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseSemiBold15
                                .textColor(appColor(context).darkText)),
                        const VSpace(Sizes.s5),
                        IntrinsicHeight(
                            child: Row(children: [
                          SvgPicture.asset(eSvgAssets.clock),
                          const HSpace(Sizes.s5),
                          Text(
                              "${service.duration ?? ""} ${service.durationUnit != null ? capitalizeFirstLetter(service.durationUnit.toString().split('.').last.toLowerCase()) : ""}",
                              style: appCss.dmDenseSemiBold12
                                  .textColor(appColor(context).online)),
                        ])),
                        const VSpace(Sizes.s5),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              if (service.discount != null &&
                                  service.discount! > 0)
                                Text(
                                    symbolPosition
                                        ? "${getSymbol(context)}${(currency(context).currencyVal * (service.price ?? 0)).round()}"
                                        : "${(currency(context).currencyVal * (service.price ?? 0)).round()}${getSymbol(context)}",
                                    style: appCss.dmDenseRegular11
                                        .textColor(appColor(context).lightText)
                                        .lineThrough),
                              const HSpace(Sizes.s5),
                              Text(
                                  symbolPosition
                                      ? "${getSymbol(context)}${((currency(context).currencyVal * (service.serviceRate ?? 0)).toStringAsFixed(2))}"
                                      : "${((currency(context).currencyVal * (service.serviceRate ?? 0)).toStringAsFixed(2))}${getSymbol(context)}",
                                  style: appCss.dmDenseBold14
                                      .textColor(appColor(context).darkText)),
                            ],
                          ),
                        ),
                        const VSpace(Sizes.s10),
                        Row(
                          children: [
                            Visibility(
                              visible: false,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                             child: CommonArrow(
                                  arrow: eSvgAssets.chat,
                                  svgColor: appColor(context).primary,
                                  color: appColor(context)
                                      .primary
                                      .withValues(alpha: 0.15),
                                  onTap: () {
                                    serviceCtrl.onHomeChatTap(context,
                                        user: service.user);
                                  }),
                           ),
                            const HSpace(Sizes.s5),
                            Expanded(
                                child: Container(
                                    decoration: ShapeDecoration(
                                        color: appColor(context).primary,
                                        shape: SmoothRectangleBorder(
                                            side: BorderSide(
                                                color:
                                                    appColor(context).primary),
                                            borderRadius: SmoothBorderRadius(
                                                cornerRadius: AppRadius.r8,
                                                cornerSmoothing: 1))),
                                    child: SizedBox(
                                      child: Center(
                                        child: Text(
                                                "+ ${language(context, translations!.add)}",
                                                overflow: TextOverflow.clip,
                                                style: appCss.dmDenseBold14
                                                    .textColor(appColor(context)
                                                        .whiteColor))
                                            .padding(
                                                horizontal: Insets.i12,
                                                vertical: Insets.i8),
                                      ),
                                    )).inkWell(onTap: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              if (pref.getBool(session.isContinueAsGuest) ==
                                  true) {
                                route.pushNamedAndRemoveUntil(
                                    context, routeName.login);
                              } else {
                                log("index::$index");
                                dash.onFeatured(
                                    context, service, index,
                                    inCart: isInCart(context,
                                        service.id));
                              }
                            })),
                          ],
                        ).padding(bottom: Insets.i5)
                      ])).inkWell(onTap: () {
                serviceCtrl.getServiceById(
                    context, service.id);
                route.pushNamed(context, routeName.servicesDetailsScreen, arg: {
                  'serviceId': service.id,
                });
              }
                   ).decorated(
                  color: appColor(context).whiteBg,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 3,
                        spreadRadius: 2,
                        color: appColor(context).darkText.withOpacity(0.06))
                  ],
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  border: Border.all(color: appColor(context).stroke));
            }).paddingSymmetric(horizontal: Insets.i15)
      ]);
    });
  }
}
