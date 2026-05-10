import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';

class UserZoneServicemanLayout extends StatelessWidget {
  final ProviderModel data;
  final GestureTapCallback? onTap;

  const UserZoneServicemanLayout({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Insets.i15),
      padding: EdgeInsets.all(Insets.i15),
      decoration: BoxDecoration(
        color: appColor(context).fieldCardBg,
        borderRadius: BorderRadius.circular(AppRadius.r10),
        border: Border.all(color: appColor(context).stroke)
      ),
      child: Row(
        children: [
          SizedBox(
            width: Sizes.s70,
            child: data.media != null && data.media!.isNotEmpty
                ? CommonImageLayout(
                    image: data.media![0].originalUrl,
                    height: Sizes.s70,
                    width: Sizes.s70,
                    radius: AppRadius.r10,
                  )
                : CommonCachedImage(
                    image: eImageAssets.noImageFound1,
                    height: Sizes.s70,
                    width: Sizes.s70,
                  ),
          ),
          const HSpace(Sizes.s15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? "",
                  style: appCss.dmDenseMedium16.textColor(appColor(context).darkText),
                ),
                const VSpace(Sizes.s5),
                if (data.reviewRatings != null && data.reviewRatings! > 0)
                  Row(
                    children: [
                      SvgPicture.asset(eSvgAssets.star),
                      const HSpace(Sizes.s5),
                      Text(
                        data.reviewRatings?.toStringAsFixed(1) ?? "0.0",
                        style: appCss.dmDenseMedium14.textColor(appColor(context).darkText),
                      ),
                    ],
                  ),
                if (data.experienceDuration != null && data.experienceDuration! > 0)
                  Column(
                    children: [
                      const VSpace(Sizes.s5),
                      Text(
                        "${data.experienceDuration ?? 0} ${data.experienceInterval ?? "Years"} Experience",
                        style: appCss.dmDenseMedium14.textColor(appColor(context).lightText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: Sizes.s15, color: appColor(context).lightText)
        ],
      ),
    ).inkWell(onTap: onTap);
  }
}
