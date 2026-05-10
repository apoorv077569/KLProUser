import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/config.dart';
import 'package:provider/provider.dart';
import '../provider_details_screen/layouts/language_layout.dart';

class ServicemanDetailScreen extends StatelessWidget {
  const ServicemanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicemanDetailProvider>(builder: (context, value, child) {
      return StatefulWrapper(
        onInit: () => Future.delayed(DurationClass.ms50)
            .then((_) => value.onReady(context)),
        child: LoadingComponent(
          child: Scaffold(
            appBar: AppBarCommon(title: translations!.providerDetails),
            body: value.provider != null
                ? SingleChildScrollView(
                    padding: EdgeInsets.all(Insets.i20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        Row(
                          children: [
                            CommonImageLayout(
                              image: value.provider!.media != null && value.provider!.media!.isNotEmpty
                                  ? value.provider!.media![0].originalUrl
                                  : eImageAssets.noImageFound1,
                              height: Sizes.s80,
                              width: Sizes.s80,
                              radius: AppRadius.r10,
                            ),
                            const HSpace(Sizes.s20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.provider!.name ?? "",
                                    style: appCss.dmDenseSemiBold18.textColor(appColor(context).darkText),
                                  ),
                                  const VSpace(Sizes.s5),
                                  Text(
                                    "${value.provider!.experienceDuration ?? 0} ${capitalizeFirstLetter(value.provider!.experienceInterval ?? "Years")} Experience",
                                    style: appCss.dmDenseMedium14.textColor(appColor(context).lightText),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const VSpace(Sizes.s25),

                        // About Section
                        if (value.provider!.description != null && value.provider!.description!.isNotEmpty) ...[
                          Text(language(context, translations!.description), style: appCss.dmDenseSemiBold16.textColor(appColor(context).darkText)),
                          const VSpace(Sizes.s10),
                          Text(
                            value.provider!.description!,
                            style: appCss.dmDenseRegular14.textColor(appColor(context).lightText),
                          ),
                          const VSpace(Sizes.s25),
                        ],

                        // Contact Information
                        Text(language(context, translations!.contactUs), style: appCss.dmDenseSemiBold16.textColor(appColor(context).darkText)),
                        const VSpace(Sizes.s15),
                        // if (value.provider!.email != null && value.provider!.email!.isNotEmpty)
                        //   _infoTile(context, Icons.email_outlined, value.provider!.email!),
                        // if (value.provider!.phone != null)
                        //   _infoTile(context, Icons.phone_android_outlined, "+${value.provider!.code ?? "91"} ${value.provider!.phone}"),
                        if (value.provider!.primaryAddress != null)
                          _infoTile(context, Icons.location_on_outlined, 
                            [
                              // if (value.provider!.primaryAddress?.address != null && value.provider!.primaryAddress!.address!.isNotEmpty) value.provider!.primaryAddress!.address,
                              if (value.provider!.primaryAddress?.city != null && value.provider!.primaryAddress!.city!.isNotEmpty) value.provider!.primaryAddress!.city else value.provider!.primaryAddress!.address,
                              // if (value.provider!.primaryAddress?.state?.name != null && value.provider!.primaryAddress!.state!.name!.isNotEmpty) value.provider!.primaryAddress!.state!.name,
                            ].join(", ")
                          ),
                        const VSpace(Sizes.s25),

                        // Known Languages
                        if (value.provider!.knownLanguages != null && value.provider!.knownLanguages!.isNotEmpty) ...[
                          Text(language(context, translations!.knowLanguage), style: appCss.dmDenseSemiBold16.textColor(appColor(context).darkText)),
                          const VSpace(Sizes.s15),
                          Wrap(
                            spacing: Sizes.s10,
                            children: value.provider!.knownLanguages!.map((l) => LanguageLayout(title: l.key)).toList(),
                          ),
                          const VSpace(Sizes.s25),
                        ],

                        // Featured Services (Expertise)
                        if (value.provider!.expertise != null && value.provider!.expertise!.isNotEmpty) ...[
                          Text(language(context, translations!.expertiseIn), style: appCss.dmDenseSemiBold16.textColor(appColor(context).darkText)),
                          const VSpace(Sizes.s15),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.provider!.expertise!.length,
                            itemBuilder: (context, index) {
                              final service = value.provider!.expertise![index];
                              return Container(
                                margin: EdgeInsets.only(bottom: Insets.i15),
                                padding: EdgeInsets.all(Insets.i10),
                                decoration: BoxDecoration(
                                  color: appColor(context).fieldCardBg,
                                  borderRadius: BorderRadius.circular(AppRadius.r10),
                                ),
                                child: Row(
                                  children: [
                                    CommonImageLayout(
                                      image: service.media != null && service.media!.isNotEmpty
                                          ? service.media![0].originalUrl
                                          : eImageAssets.noImageFound1,
                                      height: Sizes.s60,
                                      width: Sizes.s60,
                                      radius: AppRadius.r5,
                                    ),
                                    const HSpace(Sizes.s15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(service.title ?? "", style: appCss.dmDenseMedium14.textColor(appColor(context).darkText)),
                                          const VSpace(Sizes.s5),
                                          Text(
                                            "${getSymbol(context)}${service.price}",
                                            style: appCss.dmDenseSemiBold14.textColor(appColor(context).primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${service.duration} ${service.durationUnit}",
                                      style: appCss.dmDenseMedium12.textColor(appColor(context).lightText),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
      );
    });
  }

  Widget _infoTile(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.i15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Sizes.s20, color: appColor(context).primary),
          const HSpace(Sizes.s15),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appCss.dmDenseMedium14.textColor(appColor(context).darkText),
            ),
          ),
        ],
      ),
    );
  }
}
