import 'package:figma_squircle/figma_squircle.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../config.dart';

class ServiceButtonCommon extends StatelessWidget {
  final String? icon;
  final Color? color;
  final GestureTapCallback? onTap;
  const ServiceButtonCommon({super.key,this.icon,this.color,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: color ?? appColor(context).primary,
          shape: SmoothRectangleBorder(
              borderRadius:
              SmoothBorderRadius(cornerRadius: 6, cornerSmoothing: 1))),
      child: Text(icon!,style: appCss.dmDenseSemiBold10.textColor(appColor(context).whiteBg))
    ).inkWell(onTap: onTap);
  }
}
