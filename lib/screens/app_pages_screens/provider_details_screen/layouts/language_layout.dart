import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class LanguageLayout extends StatelessWidget {
  final String? title;
  const LanguageLayout({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Text(language(context, title.toString()),
            style: appCss.dmDenseMedium12.textColor(appColor(context).darkText))
        .paddingSymmetric(vertical: Insets.i8, horizontal: Insets.i14)
        .boxShapeExtension(color: appColor(context).fieldCardBg)
        .paddingOnly(right: Insets.i10);
  }
}
