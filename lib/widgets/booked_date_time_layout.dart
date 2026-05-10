import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../config.dart';

class BookedDateTimeLayout extends StatelessWidget {
  final String? date, time;
  final GestureTapCallback? onTap;
  const BookedDateTimeLayout({super.key, this.date, this.time, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: SvgPicture.asset(eSvgAssets.calendar,
                    colorFilter: ColorFilter.mode(
                        appColor(context).darkText, BlendMode.srcIn),
                    fit: BoxFit.scaleDown)
                .paddingAll(Insets.i10)
                .boxShapeExtension(color: appColor(context).fieldCardBg),
            title: Text(language(context, date!),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).darkText)),
            subtitle: Text(language(context, time!),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).lightText)),
            trailing: SvgPicture.asset(eSvgAssets.edit,
                    color: appColor(context).primary,
                    height: Sizes.s24,
                    width: Sizes.s24)
                .inkWell(onTap: onTap))
        .paddingSymmetric(horizontal: Insets.i15)
        .boxBorderExtension(context);
  }
}
