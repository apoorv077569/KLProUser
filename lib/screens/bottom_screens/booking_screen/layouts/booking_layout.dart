import 'package:figma_squircle/figma_squircle.dart';
import 'package:intl/intl.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/bottom_screens/booking_screen/layouts/service_provider_layout.dart';
import 'package:klpro_user/screens/bottom_screens/booking_screen/layouts/status_row.dart';
import 'package:provider/provider.dart';
import '../../../../config.dart';

class BookingLayout extends StatelessWidget {
  final BookingModel? data;
  final GestureTapCallback? onTap, editLocationTap, editDateTimeTap;
  final int? index;

  const BookingLayout(
      {super.key,
      this.data,
      this.onTap,
      this.index,
      this.editLocationTap,
      this.editDateTimeTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(builder: (context1, value, child) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    if (data?.servicePackageId != null) const VSpace(Sizes.s8),
                    if (data?.servicePackageId != null)
                      BookingStatusLayout(title: appFonts.package),
                    const VSpace(Sizes.s8),
                    Text(language(context, data?.service?.title ?? ''),
                        maxLines: 2,
                        style: appCss.dmDenseMedium16
                            .textColor(appColor(context).darkText)),
                    Row(children: [
                      data?.grandTotalWithExtras == 0
                          ? Text(
                              language(
                                  context,
                                  symbolPosition
                                      ? "${getSymbol(context)}${(data?.total ?? 0).toStringAsFixed(2)}"
                                      : "${(data?.total ?? 0).toStringAsFixed(2)}${getSymbol(context)}"),
                              style: appCss.dmDenseBold18
                                  .textColor(appColor(context).darkText))
                          : Text(
                              language(
                                  context,
                                  symbolPosition
                                      ? "${getSymbol(context)}${(data?.grandTotalWithExtras ?? 0).toStringAsFixed(2)}"
                                      : "${(data?.grandTotalWithExtras ?? 0).toStringAsFixed(2)}${getSymbol(context)}"),
                              style: appCss.dmDenseBold18
                                  .textColor(appColor(context).darkText)),
                      const HSpace(Sizes.s8),
                      if (data?.service?.discount != null && data?.service?.discount != 0)
                        Text(
                            language(context,
                                "(${data?.service?.discountDisplay ?? ''}% ${language(context, translations?.off ?? "Off")})"),
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).red))
                    ])
                  ])),
              data?.service?.media != null && data!.service!.media!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: data!.service!.media![0].originalUrl ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                          height: Sizes.s84,
                          width: Sizes.s84,
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                              shape: const SmoothRectangleBorder(
                                  borderRadius: SmoothBorderRadius.all(
                                      SmoothRadius(
                                          cornerRadius: AppRadius.r10,
                                          cornerSmoothing: 1))))),
                      placeholder: (context, url) => Container(
                          height: Sizes.s84,
                          width: Sizes.s84,
                          decoration: ShapeDecoration(
                              image: DecorationImage(
                                  image: AssetImage(eImageAssets.noImageFound1),
                                  fit: BoxFit.cover),
                              shape: const SmoothRectangleBorder(
                                  borderRadius:
                                      SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1))))),
                      errorWidget: (context, url, error) => Container(height: Sizes.s84, width: Sizes.s84, decoration: ShapeDecoration(image: DecorationImage(image: AssetImage(eImageAssets.noImageFound1), fit: BoxFit.cover), shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1)))))).padding(left: Sizes.s10)
                  : Container(height: Sizes.s84, width: Sizes.s84, decoration: ShapeDecoration(image: DecorationImage(image: AssetImage(eImageAssets.noImageFound1), fit: BoxFit.cover), shape: const SmoothRectangleBorder(borderRadius: SmoothBorderRadius.all(SmoothRadius(cornerRadius: AppRadius.r10, cornerSmoothing: 1)))))
            ]),
            Image.asset(eImageAssets.bulletDotted)
                .paddingSymmetric(vertical: Insets.i12),
            StatusRow(
              title: translations?.bookingStatus ?? "Booking Status",
              statusText: data?.bookingStatus?.name ?? '',
              statusId: data?.bookingStatusId,
            ),
            if (data?.dateTime != null)
              StatusRow(
                  statusText: data?.bookingStatus?.name ?? '',
                  statusId: data?.bookingStatusId,
                  title: translations?.dateTime ?? "Date & Time",
                  onTap: editDateTimeTap,
                  title2: () {
                    try {
                      return DateFormat("dd-MM-yyyy, hh:mm aa")
                        .format(DateTime.parse(data!.dateTime!));
                    } catch (e) {
                      return data?.dateTime ?? "";
                    }
                  }(),
                  isDateLocation:
                      data?.bookingStatus?.slug == translations?.pending
                          ? true
                          : false,
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).darkText)),
            if (data?.address != null || data?.addressId != null)
              StatusRow(
                  statusText: data?.bookingStatus?.name ?? '',
                  statusId: data?.bookingStatusId,
                  title: translations?.location ?? "Location",
                  onTap: editLocationTap,
                  title2: data?.address == null
                      ? getAddress(context, data?.addressId)
                      : "${data?.address?.address ?? ""}-${data?.address?.area ?? data?.address?.state?.name ?? ''}",
                  isDateLocation:
                      (data?.bookingStatus?.slug == translations?.pending &&
                          data?.bookingStatus?.slug != translations?.cancelled),
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).darkText)),
            StatusRow(
                  statusText: data?.bookingStatus?.name ?? '',
                  statusId: data?.bookingStatusId,
                  title: translations?.payment ?? "Payment",
                  title2: data?.paymentStatus != null
                      ? data?.paymentMethod == "cash"
                          ? data?.paymentStatus?.toLowerCase() == "completed"
                              ? data?.paymentStatus ?? ""
                              : language(context, translations?.notPaid ?? "Not Paid")
                                  .toUpperCase()
                          : data?.paymentStatus ?? ""
                      : data?.bookingStatus?.slug == translations?.completed
                          ? data?.paymentStatus == "COMPLETED"
                              ? language(context, translations?.paid ?? "Paid")
                              : language(context, translations?.notPaid ?? "Not Paid")
                          : data?.paymentMethod == "cash"
                              ? language(context, translations?.notPaid ?? "Not Paid")
                              : language(context, translations?.paid ?? "Paid"),
                  style: appCss.dmDenseMedium12
                      .textColor(appColor(context).online)),
            StatusRow(
                title: translations?.paymentMode ?? "Payment Mode",
                title2: data?.paymentMethod == "on_hand" ||
                        data?.paymentMethod == "cash"
                    ? language(context, translations?.cash ?? "Cash")
                    : capitalizeFirstLetter(data?.paymentMethod),
                style:
                    appCss.dmDenseMedium12.textColor(appColor(context).online)),
            const VSpace(Sizes.s15),
            if (data?.isExpand == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data?.provider != null)
                    ServiceProviderLayout(
                            title: language(context, translations?.provider ?? "Provider"),
                            image: (data?.provider?.media != null &&
                                    data!.provider!.media!.isNotEmpty)
                                ? data!.provider!.media![0].originalUrl
                                : null,
                            name: data?.provider?.name,
                            rate: data?.provider?.reviewRatings != null
                                ? data!.provider!.reviewRatings.toString()
                                : "0",
                            index: 0,
                            list: const [])
                        .paddingSymmetric(horizontal: Insets.i12)
                        .boxShapeExtension(
                            color: appColor(context).fieldCardBg,
                            radius: AppRadius.r15),
                  if (data?.servicemen != null && data!.servicemen!.isNotEmpty)
                    Image.asset(eImageAssets.bulletDotted)
                        .paddingSymmetric(vertical: Insets.i12),
                  Stack(alignment: Alignment.bottomCenter, children: [
                    Column(children: [
                      if (data?.servicemen != null &&
                          data!.servicemen!.isNotEmpty)
                        Column(
                            children:
                                data!.servicemen!.asMap().entries.map((s) {
                          return ServiceProviderLayout(
                              isProvider: false,
                              title: language(context, translations?.serviceman ?? "Serviceman")
                                  .capitalizeFirst(),
                              image: (s.value.media != null &&
                                      s.value.media!.isNotEmpty)
                                  ? s.value.media!.first.originalUrl
                                  : null,
                              name: s.value.name,
                              rate: s.value.reviewRatings ?? "0",
                              index: s.key,
                              list: data!.servicemen!);
                        }).toList())
                    ])
                        .paddingSymmetric(horizontal: Insets.i12)
                        .boxShapeExtension(
                            color: appColor(context).fieldCardBg,
                            radius: AppRadius.r15)
                        .paddingOnly(
                            bottom: (data?.servicemen != null &&
                                    data!.servicemen!.length > 1)
                                ? Insets.i15
                                : 0),
                  ])
                ],
              ),
          ])
              .paddingSymmetric(vertical: Insets.i15, horizontal: Insets.i15)
              .decorated(
                  color: appColor(context).whiteBg,
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  boxShadow: [
                    BoxShadow(
                        color: appColor(context).darkText.withOpacity(0.06),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 2)),
                  ],
                  border: Border.all(color: appColor(context).stroke))
              .padding(bottom: Insets.i20, horizontal: Sizes.s20)
              .inkWell(onTap: onTap),
          Transform.translate(
            offset: const Offset(0, -Insets.i10), // Moves the container upwards
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Insets.i10),
                color: appColor(context).primary,
              ),
              padding: const EdgeInsets.symmetric(
                  vertical: Sizes.s4, horizontal: Sizes.s10),
              child: Text(
                "#${data?.bookingNumber ?? ''}",
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).whiteColor),
              ),
            ),
          ).padding(horizontal: Sizes.s40),
        ],
      ).paddingOnly(top: Sizes.s10, bottom: Sizes.s8);
    });
  }
}
