
import 'package:klpro_user/config.dart';

class SpecialOffersLayout extends StatelessWidget {
  const SpecialOffersLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<ServicesDetailsProvider, CommonApiProvider,
            DashboardProvider>(
        builder: (context, serviceDetails, commonApi, dash, child) {
      final advertisements = commonApi.dashboardModel2?.homeServicesAdvertisements;
      if (advertisements == null || advertisements.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
              children: [
                HeadingRowCommon(
                        title: language(context, translations?.specialOffers),
                        isTextSize: true,
                        isViewAll: false,
                        onTap: () {}
                        )
                    .padding(bottom: Sizes.s16, horizontal: Insets.i20),
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: advertisements.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final ad = advertisements[index];
                        final services = ad.services;
                        if (services == null || services.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final service = services[0];

                        return Container(
                                width: Sizes.s205,
                                margin: const EdgeInsets.all(Insets.i10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          if (service.media != null && service.media!.isNotEmpty)
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Insets.i7),
                                              child: CommonImageLayout(
                                                tlRadius: 0,
                                                tRRadius: 0,
                                                blRadius: 0,
                                                bRRadius: 0,
                                                isAllBorderRadius: false,
                                                image: service.media![0].originalUrl ?? '',
                                                boxFit: BoxFit.cover,
                                                height: Sizes.s110,
                                                assetImage: eImageAssets
                                                    .noImageFound2,
                                              ),
                                            )
                                          else
                                            CommonCachedImage(
                                              tlRadius: 0,
                                              tRRadius: 0,
                                              blRadius: 0,
                                              bRRadius: 0,
                                              isAllBorderRadius: false,
                                              height: Sizes.s110,
                                              image:
                                                  eImageAssets.noImageFound2,
                                            ),

                                          if (service.discount != null && service.discount != 0)
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Text(
                                                    "${service.discountDisplay}%",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const VSpace(Sizes.s10),
                                      Text(
                                          textAlign: TextAlign.start,
                                          service.title ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          style: appCss.dmDenseSemiBold15
                                              .textColor(appColor(context)
                                                  .darkText)),
                                      const VSpace(Sizes.s5),
                                      IntrinsicHeight(
                                          child: Row(children: [
                                        SvgPicture.asset(eSvgAssets.clock),
                                        const HSpace(Sizes.s5),
                                        Text(
                                            "${service.duration ?? ""} ${service.durationUnit != null ? capitalizeFirstLetter(service.durationUnit.toString().split('.').last.toLowerCase()) : ""}",
                                            style: appCss.dmDenseSemiBold12
                                                .textColor(appColor(context)
                                                    .online)),
                                      ])),
                                      const VSpace(Sizes.s5),
                                      IntrinsicHeight(
                                          child: Row(children: [
                                        Text(
                                            symbolPosition
                                                ? "${getSymbol(context)}${(currency(context).currencyVal * (service.price ?? 0)).round()}"
                                                : "${(currency(context).currencyVal * (service.price ?? 0)).round()}${getSymbol(context)}",
                                            style: appCss.dmDenseRegular11
                                                .textColor(appColor(context)
                                                    .lightText)
                                                .lineThrough),
                                        const HSpace(Sizes.s5),
                                        Text(
                                            symbolPosition
                                                ? "${getSymbol(context)}${((currency(context).currencyVal * (service.serviceRate ?? 0)).toStringAsFixed(2))}"
                                                : "${((currency(context).currencyVal * (service.serviceRate ?? 0)).toStringAsFixed(2))}${getSymbol(context)}",
                                            style: appCss.dmDenseBold14
                                                .textColor(appColor(context)
                                                    .darkText)),
                                        const Spacer(),
                                        AddButtonCommon(onTap: () {
                                          dash.onFeatured(
                                              context,
                                              service,
                                              index,
                                              inCart: isInCart(
                                                  context,
                                                  service.id));
                                        })
                                      ]))
                                    ]))
                            .inkWell(
                              onTap: () {
                                final serviceId = service.id;
                                serviceDetails.getServiceById(
                                    context, serviceId);
                                route.pushNamed(
                                    context, routeName.servicesDetailsScreen,
                                    arg: {
                                      'serviceId': serviceId,
                                    });
                              },
                            )
                            .decorated(
                                color: appColor(context).whiteBg,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                      color: appColor(context)
                                          .darkText
                                          .withOpacity(0.06))
                                ],
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r8),
                                border: Border.all(
                                    color: appColor(context).stroke))
                            .padding(left: Insets.i15);
                      }),
                ),
              ],
            );

    });
  }
}
