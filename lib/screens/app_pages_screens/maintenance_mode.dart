import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';

class MaintenanceMode extends StatelessWidget {
  const MaintenanceMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColor(context).whiteBg,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(eImageAssets.maintenance, height: Sizes.s347),
          const VSpace(Sizes.s25),
          Text(language(context, translations!.maintenanceMode),
              style:
                  appCss.dmDenseBold18.textColor(appColor(context).darkText)),
          const VSpace(Sizes.s8),
          Text(language(context, translations!.appIsUnderMaintenance),
                  textAlign: TextAlign.center,
                  style: appCss.dmDenseRegular14
                      .textColor(appColor(context).lightText))
              .paddingSymmetric(horizontal: Insets.i10)
        ]).paddingSymmetric(horizontal: Insets.i20));
  }
}
