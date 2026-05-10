import 'package:dotted_border/dotted_border.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class SelectServicemanLayout extends StatelessWidget {
  final GestureTapCallback? onTap;
  const SelectServicemanLayout({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<SlotBookingProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language(context, translations!.selectServicemen),
            style:
                appCss.dmDenseMedium14.textColor(appColor(context).darkText)),
        const VSpace(Sizes.s4),
        const VSpace(Sizes.s10),
        DottedBorder(
                color: appColor(context).primary,
                borderType: BorderType.RRect,
                radius: const Radius.circular(AppRadius.r10),
                child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.r8)),
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        color: appColor(context).primary.withOpacity(0.1),
                        child: Text(
                                "+ ${language(context, translations!.selectServicemen)}",
                                style: appCss.dmDenseMedium14
                                    .textColor(appColor(context).primary))
                            .paddingSymmetric(vertical: Insets.i26))))
            .inkWell(onTap: onTap),
      ],
    );
  }
}
