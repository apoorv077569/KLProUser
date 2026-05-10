import 'package:klpro_user/common/assets/index.dart';

import '../config.dart';

class CommonImageLayout extends StatelessWidget {
  final double? height, width, radius, tlRadius, tRRadius, blRadius, bRRadius;
  final String? image, assetImage;
  final bool isCircle, isBorder, isAllBorderRadius;
  final BoxFit? boxFit;

  const CommonImageLayout(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.image,
      this.isCircle = false,
      this.boxFit,
      this.isBorder = false,
      this.isAllBorderRadius = true,
      this.assetImage,
      this.tlRadius,
      this.tRRadius,
      this.blRadius,
      this.bRRadius});

  @override
  Widget build(BuildContext context) {
    return image != null
        ? CachedNetworkImage(
            imageUrl: image!,
            imageBuilder: (context, imageProvider) => CommonCachedNetworkImage(
                height: height,
                width: width,
                isCircle: isCircle,
                image: imageProvider,
                isAllBorderRadius: isAllBorderRadius,
                radius: radius,
                boxFit: boxFit,
                isBorder: isBorder,
                tlRadius: tlRadius,
                blRadius: blRadius,
                bRRadius: bRRadius,
                tRRadius: tRRadius),
            placeholder: (context, url) => CommonCachedImage(
                height: height,
                width: width,
                assetImage: assetImage ?? eImageAssets.noImageFound1,
                image: assetImage ?? eImageAssets.noImageFound1,
                isCircle: isCircle,
                isBorder: isBorder,
                boxFit: boxFit,
                radius: radius,
                isAllBorderRadius: isAllBorderRadius,
                tlRadius: tlRadius,
                blRadius: blRadius,
                bRRadius: bRRadius,
                tRRadius: tRRadius),
            errorWidget: (context, url, error) => CommonCachedImage(
                height: height,
                width: width,
                assetImage: assetImage ?? eImageAssets.noImageFound1,
                isAllBorderRadius: isAllBorderRadius,
                image: assetImage ?? eImageAssets.noImageFound1,
                boxFit: boxFit,
                radius: radius,
                isCircle: isCircle,
                tlRadius: tlRadius,
                blRadius: blRadius,
                bRRadius: bRRadius,
                tRRadius: tRRadius))
        : CommonCachedImage(
            height: height,
            width: width,
            assetImage: assetImage ?? eImageAssets.noImageFound1,
            isAllBorderRadius: isAllBorderRadius,
            image: assetImage ?? eImageAssets.noImageFound1,
            boxFit: boxFit,
            isCircle: isCircle,
            tlRadius: tlRadius,
            blRadius: blRadius,
            bRRadius: bRRadius,
            tRRadius: tRRadius);
  }
}
