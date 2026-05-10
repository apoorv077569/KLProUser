import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../config.dart';

class BookingServiceStatusLayout extends StatelessWidget {
  final String? status, title;
  const BookingServiceStatusLayout({super.key, this.status, this.title});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: language(context,
                "${language(context, status ?? translations!.status)} : "),
            style: appCss.dmDenseSemiBold12.textColor(appColor(context).red),
            children: [
          TextSpan(
              text: language(
                  context,
                  language(
                      context,
                      title ??
                          language(context, translations!.theProviderHas))),
              style: appCss.dmDenseMedium12.textColor(appColor(context).red))
        ])).paddingAll(Insets.i15).width(double.infinity).boxShapeExtension(
        radius: AppRadius.r8,
        color: appColor(context).red.withValues(alpha: 0.1));
  }
}
