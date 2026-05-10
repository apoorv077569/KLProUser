import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../config.dart';

class BookingStatusLayout extends StatelessWidget {
  final String? title;
  final Color? color;
  const BookingStatusLayout({super.key,this.title,this.color});

  @override
  Widget build(BuildContext context) {
    return Text(capitalizeFirstLetter(language(context, title!)),style: appCss.dmDenseMedium11.textColor(appColor(context).whiteColor)).paddingSymmetric(vertical: Insets.i4,horizontal: Insets.i12).decorated(
        color: color ?? appColor(context).online,
        borderRadius: BorderRadius.circular(AppRadius.r50)
    );
  }
}
