import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../../config.dart';

class ServiceImage extends StatelessWidget {
  final XFile? imageFile;

  const ServiceImage({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        color: appColor(context).stroke,
        borderType: BorderType.RRect,
        radius: const Radius.circular(AppRadius.r10),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.r8)),
            child: imageFile != null
                ? ClipSmoothRect(
                    radius: SmoothBorderRadius(
                        cornerRadius: 10, cornerSmoothing: 1),
                    child: Image.file(File(imageFile!.path),
                        height: Sizes.s70, width: Sizes.s70, fit: BoxFit.cover))
                : Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    color: appColor(context).whiteBg,
                    child: Column(
                      children: [
                        SvgPicture.asset(eSvgAssets.address),
                        const VSpace(Sizes.s6),
                        Text(language(context, translations!.uploadLogoImage),
                            style: appCss.dmDenseMedium12
                                .textColor(appColor(context).lightText))
                      ],
                    ).paddingSymmetric(vertical: Insets.i15))));
  }
}
