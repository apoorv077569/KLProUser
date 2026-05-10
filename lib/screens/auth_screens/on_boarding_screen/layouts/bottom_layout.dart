import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class BottomLayout extends StatelessWidget {
  final String? title, subText;
  const BottomLayout({super.key, this.title, this.subText});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(title ?? '',
          style:
              appCss.dmDenseSemiBold20.textColor(appColor(context).darkText)),
      const VSpace(Sizes.s15),
      Text(subText ?? '',
              textAlign: TextAlign.center,
              style: appCss.dmDenseRegular16
                  .textColor(appColor(context).lightText)
                  .textHeight(1.3))
          .paddingSymmetric(horizontal: Insets.i15),
    ]);
  }
}
