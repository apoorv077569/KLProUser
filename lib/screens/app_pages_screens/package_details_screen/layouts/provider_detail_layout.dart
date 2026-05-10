import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class ProviderDetailLayout extends StatelessWidget {
  final String? name,image,rate,star;
  const ProviderDetailLayout({super.key,this.image,this.rate,this.name,this.star});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            image != null
                ? CachedNetworkImage(
                imageUrl: image!,
                imageBuilder: (context, imageProvider) => Container(
                    height: Sizes.s40,
                    width: Sizes.s40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider))),
                errorWidget: (context, url, error) => Container(
                    height: Sizes.s40,
                    width: Sizes.s40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(eImageAssets.noImageFound3)))))
                : Container(
                height: Sizes.s40,
                width: Sizes.s40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage(eImageAssets.noImageFound3)))),
            const HSpace(Sizes.s12),
            Text(name!,
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).darkText))
          ]),
          Row(children: [
            SvgPicture.asset(star!),
            const HSpace(Sizes.s4),
            Text(rate!,
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).darkText))
          ])
        ]).paddingSymmetric(horizontal: Insets.i15),
      ],
    );
  }
}