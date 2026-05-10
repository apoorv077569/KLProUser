import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../config.dart';

class TimeSlotLayout extends StatelessWidget {
  final String? title;
  final GestureTapCallback? onTap;
  const TimeSlotLayout({super.key, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(language(context, title!),
          style: appCss.dmDenseMedium14.textColor(appColor(context).darkText)),
      const VSpace(Sizes.s6),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(language(context, translations!.selectDateTime),
            style:
                appCss.dmDenseMedium14.textColor(appColor(context).lightText)),
        SvgPicture.asset(eSvgAssets.calendar)
      ])
          .paddingAll(Insets.i15)
          .boxShapeExtension(color: appColor(context).whiteBg)
          .inkWell(onTap: onTap /*value.onProviderDateTimeSelect(context)*/)
    ])
        .paddingAll(AppRadius.r15)
        .boxShapeExtension(color: appColor(context).fieldCardBg);
  }
}
