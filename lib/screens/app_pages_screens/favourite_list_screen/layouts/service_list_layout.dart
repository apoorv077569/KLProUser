import 'dart:developer';


import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class ServiceListLayout extends StatelessWidget {
  final data;
  final bool isFav, isWidth;
  final Function(bool)? favTap;
  final GestureTapCallback? onTap;

  const ServiceListLayout(
      {super.key,
      this.data,
      this.isFav = false,
      this.favTap,
      this.onTap,
      this.isWidth = false});

  @override
  Widget build(BuildContext context) {
    log("message :${data?.isFavourite}");
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: isWidth
            ? Sizes.s223
            : constraints.hasBoundedWidth
                ? null
                : Sizes.s223,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(alignment: Alignment.topRight, children: [
            data?.media != null && data!.media!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: data!.media![0].originalUrl!,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r6),
                        child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            height: Sizes.s106,
                            width: double.infinity)),
                    placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r6),
                        child: Image.asset(eImageAssets.noImageFound2,
                            fit: BoxFit.fill,
                            height: Sizes.s106,
                            width: double.infinity)),
                    errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.r6),
                        child: Image.asset(eImageAssets.noImageFound2,
                            fit: BoxFit.fill,
                            height: Sizes.s106,
                            width: double.infinity)))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r6),
                    child: Image.asset(eImageAssets.noImageFound2,
                        fit: BoxFit.cover,
                        height: Sizes.s106,
                        width: double.infinity)),
            /*SvgPicture.asset(eSvgAssets.heart).paddingAll(Insets.i8)*/
            /* value.provider != null
                ? value.provider?.isFavourite == 1
                ? SvgPicture.asset(eSvgAssets.heart)
                .inkWell(
                onTap: () => {
                  value.provider?.isFavourite = 0,
                  favCtrl.deleteFav(
                      context,value:value,
                      isFavId: value.provider!.isFavouriteId,id:value.provider?.id),
                })
                .paddingOnly(right: Insets.i20)
                : CommonArrow(
                arrow: eSvgAssets.like,
                svgColor: appColor(context).primary,
                color: appColor(context)
                    .primary
                    .withValues(alpha: 0.15),
                onTap: () =>
                {
                  value.provider?.isFavourite = 1,
                  favCtrl.addFav("provider", context, value.provider!.id)
                })
                .paddingOnly(right: Insets.i20)
                : Container()*/
            isFav || data!.isFavourite == 1
                ? SvgPicture.asset(eSvgAssets.heart,
                        height: Sizes.s30, width: Sizes.s30)
                    .paddingAll(Insets.i8)
                    .inkWell(onTap: () => favTap!(false))
                : CommonArrow(
                        arrow: eSvgAssets.like, onTap: () => favTap!(true))
                    /* .paddingAll(Insets.i8) */

                    /*  SvgPicture.asset(
              isFav ? eSvgAssets.heart : eSvgAssets.like,
              height: isWidth ? Sizes.s40 : Sizes.s25,
              width: isWidth ? Sizes.s40 : Sizes.s25,
            ) */
                    .paddingAll(Insets.i8)
                    .inkWell(onTap: () => favTap!(isFav ? false : true))
          ]),
          const VSpace(Sizes.s12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(data?.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appCss.dmDenseSemiBold13
                        .textColor(appColor(context).darkText)),
              ),
              /* data?.ratingCount != null
                  ? Row(
                      children: [
                        SvgPicture.asset(eSvgAssets.star),
                        const HSpace(Sizes.s3),
                        Text(
                          data?.ratingCount.toString() ??
                              "0" */ /*  != null
                              ? data!.ratingCount.toString()
                              : "0" */ /*
                          ,
                          style: appCss.dmDenseMedium14
                              .textColor(appColor(context).darkText),
                        )
                      ],
                    )
                  : Container()*/
            ],
          ),
          const VSpace(Sizes.s5),
          Text(
              data?.categories != null && data!.categories.isNotEmpty
                  ? "\u2022 ${data.categories.first.title}"
                  : "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appCss.dmDenseMedium13
                  .textColor(appColor(context).lightText)),
          const VSpace(Sizes.s10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              // Text(
              //     "${getSymbol(context)}${(currency(context).currencyVal * data!.price!).toStringAsFixed(2)}",
              //     style: appCss.dmDenseRegular14
              //         .textColor(appColor(context).lightText)
              //         .lineThrough),
              // const HSpace(Sizes.s5),
              Text(
                  symbolPosition
                      ? "${getSymbol(context)}${(currency(context).currencyVal * (data!.serviceRate ?? 0)).toStringAsFixed(2)}"
                      : "${(currency(context).currencyVal * (data!.serviceRate ?? 0)).toStringAsFixed(2)}${getSymbol(context)}",
                  style: appCss.dmDenseBold12
                      .textColor(appColor(context).darkText))
            ]),
            AddButtonCommon(
              onTap: onTap,
            )
          ])
        ]).paddingAll(Insets.i12).boxBorderExtension(context));
    });
  }
}
