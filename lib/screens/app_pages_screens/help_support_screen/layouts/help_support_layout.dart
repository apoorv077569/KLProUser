import 'package:dotted_border/dotted_border.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config.dart';

class ContactUsLayout extends StatelessWidget {
  const ContactUsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
        color: appColor(context).stroke,
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Insets.i25),
          decoration: BoxDecoration(
            color: appColor(context).fieldCardBg,
            borderRadius: BorderRadius.circular(AppRadius.r13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Contact
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact",
                    style: appCss.dmDenseBold20.textColor(appColor(context).darkText),
                  ),
                  const VSpace(Sizes.s4),
                  Container(
                    height: 2.5,
                    width: Sizes.s45,
                    decoration: BoxDecoration(
                      color: const Color(0xffFF7456), // Orange accent from image
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              const VSpace(Sizes.s30),

              // Email
              GestureDetector(
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'info@klproind.com',
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  "info@klproind.com",
                  style: appCss.dmDenseRegular18.textColor(appColor(context).darkText),
                ),
              ),
              const VSpace(Sizes.s15),

              // Phone
              GestureDetector(
                onTap: () async {
                  final Uri telLaunchUri = Uri(
                    scheme: 'tel',
                    path: '+918287266266',
                  );
                  if (await canLaunchUrl(telLaunchUri)) {
                    await launchUrl(telLaunchUri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  "+91 8287 266266",
                  style: appCss.dmDenseBold20.textColor(const Color(0xffFF7456)),
                ),
              ),
              
              // Social Icons (Commented as requested)
              /*
              const VSpace(Sizes.s25),
              Row(
                children: [
                  socialIcon(context, text: "f"),
                  const HSpace(Sizes.s15),
                  socialIcon(context, text: "X"),
                  const HSpace(Sizes.s15),
                  socialIcon(context, text: "in"),
                  const HSpace(Sizes.s15),
                  socialIcon(context, icon: Icons.camera_alt_outlined),
                ],
              ),
              */
            ],
          ),
        ));
  }

  /*
  Widget socialIcon(BuildContext context, {String? text, IconData? icon}) {
    return Container(
      height: Sizes.s40,
      width: Sizes.s40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xffFF7456), width: 1.5),
      ),
      alignment: Alignment.center,
      child: text != null
          ? Text(text,
              style: appCss.dmDenseBold16.textColor(appColor(context).darkText))
          : Icon(icon, color: appColor(context).darkText, size: Sizes.s20),
    ).inkWell(onTap: () {});
  }
  */
}
