import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class CompletedStatusLayout extends StatelessWidget {
  const CompletedStatusLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language(context, "${translations!.status}:"),
                style: appCss.dmDenseMedium14.textColor(appColor(context).red)),
            const HSpace(Sizes.s10),
            Expanded(
                child: Text(language(context, translations!.statusHasNotBeen),
                    overflow: TextOverflow.fade,
                    style: appCss.dmDenseRegular14
                        .textColor(appColor(context).red)))
          ]).paddingAll(Insets.i15),
    ).boxShapeExtension(color: appColor(context).red.withOpacity(0.1));
  }
}
