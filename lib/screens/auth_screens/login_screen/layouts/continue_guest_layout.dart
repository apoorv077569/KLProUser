import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class ContinueGuestLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  const ContinueGuestLayout({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SvgPicture.asset(eSvgAssets.profile),
      VerticalDivider(color: appColor(context).stroke, width: 1, thickness: 1)
          .paddingSymmetric(horizontal: Insets.i10),
      Text(language(context, translations!.continueAsGuest),
          style: appCss.dmDenseMedium14.textColor(appColor(context).primary))
    ]).inkWell(onTap: onTap));
  }
}
