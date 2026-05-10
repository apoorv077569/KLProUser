import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class DotIndicatorLayout extends StatefulWidget {
  const DotIndicatorLayout({super.key});

  @override
  State<DotIndicatorLayout> createState() => _DotIndicatorLayoutState();
}

class _DotIndicatorLayoutState extends State<DotIndicatorLayout> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return  Consumer<OnBoardingProvider>(
      builder: (context,onBoardPro,child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              onBoardPro.selectIndex != 0
                  ? CommonArrow(
                  arrow: eSvgAssets.arrowLeft,
                  color: appColor(context).whiteBg,svgColor: appColor(context).lightText,
                  onTap: () => onBoardPro.onPageBack())
                  : Container(width: Sizes.s40),
               DotIndicator(
                   list: appArray.onBoardingList,
                   selectedIndex:onBoardPro.selectIndex),
              CommonArrow(
                  arrow: eSvgAssets.arrowRight,
                  svgColor: appColor(context).whiteColor,
                  color: appColor(context).primary,
                  onTap: () => onBoardPro.onPageSlide(context,this))
            ]).paddingSymmetric(horizontal: Insets.i20);
      }
    );
  }
}
