import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/provider_details_screen/layouts/language_layout.dart';

import '../../../../config.dart';

class PersonalDetailLayout extends StatelessWidget {
  final String? email, phone, code;
  final List<KnownLanguageModel>? knownLanguage;

  const PersonalDetailLayout(
      {super.key, this.email, this.phone, this.knownLanguage, this.code});

  @override
  Widget build(BuildContext context) {
    log("phone :${phone != null && phone != "null"}");
    log("phone :$phone");
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // PersonalInfoRowLayout(
      //         icon: eSvgAssets.mail, title: translations!.mail, content: email)
      //     .inkWell(onTap: () => commonUrlTap(context, email!)),
      // if (phone != null && phone != '')
      //   PersonalInfoRowLayout(
      //     icon: eSvgAssets.phone1,
      //     title: translations!.call,
      //     content: "+$code $phone",
      //   ).paddingSymmetric(vertical: Insets.i20),
      if (knownLanguage != null && knownLanguage!.isNotEmpty)
        Row(children: [
          SvgPicture.asset(eSvgAssets.country,
              colorFilter: ColorFilter.mode(
                  appColor(context).lightText, BlendMode.srcIn)),
          const HSpace(Sizes.s6),
          Text(language(context, translations!.knowLanguage),
              style:
                  appCss.dmDenseMedium12.textColor(appColor(context).lightText))
        ]),
      const VSpace(Sizes.s7),
      if (knownLanguage != null && knownLanguage!.isNotEmpty)
        Wrap(
            direction: Axis.horizontal,
            children: knownLanguage!
                .asMap()
                .entries
                .map((e) =>
                    LanguageLayout(title: e.value.key).paddingOnly(bottom: 10))
                .toList())
    ])
        .paddingAll(Insets.i12)
        .boxShapeExtension(color: appColor(context).whiteBg);
  }
}
