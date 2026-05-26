import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/new_location_app_bar.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/select_category.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/layouts/text_field_layout.dart';
import 'package:klpro_user/screens/auth_screens/register_screen/layouts/register_widget_class.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';

class AddNewLocation extends StatefulWidget {
  const AddNewLocation({super.key});

  @override
  State<AddNewLocation> createState() => _AddNewLocationState();
}

class _AddNewLocationState extends State<AddNewLocation>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewLocationProvider>(
      builder: (context1, value, child) {
        return Consumer<LocationProvider>(
          builder: (context2, locationCtrl, child) {
            return StatefulWrapper(
              onInit: () => Future.delayed(
                const Duration(milliseconds: 150),
                () async {
                  debugPrint("APPU_DEBUG INIT STARTED");

                  final locationCtrl = Provider.of<LocationProvider>(
                    context,
                    listen: false,
                  );

                  /// LOAD COUNTRY & STATE DATA

                  await locationCtrl.getCountryState();

                  debugPrint(
                    "APPU_DEBUG COUNTRY COUNT => ${locationCtrl.countryStateList.length}",
                  );

                  /// NOW LOAD SCREEN DATA

                  value.getOnInitData(context);

                  debugPrint("APPU_DEBUG INIT COMPLETED");
                },
              ),
              child: Scaffold(
                appBar: NewLocationAppBar(sync: this),
                body: SingleChildScrollView(
                  child: Form(
                    key: value.locationFormKey,
                    child:
                        Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textCommon.dmSensMediumDark14(
                                  context,
                                  text: translations!.selectCategory,
                                ),
                                const VSpace(Sizes.s20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: value.categoryList
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => SelectCategory(
                                          onTap: () => value.onCategory(e.key),
                                          data: e.value,
                                          index: e.key,
                                          selectedIndex: value.selectIndex,
                                        ),
                                      )
                                      .toList(),
                                ),
                                const LocationTextFieldLayout()
                                    .paddingSymmetric(vertical: Insets.i15),
                                textCommon.dmSensMediumDark14(
                                  context,
                                  text: translations!.phoneNumber,
                                ),
                                const VSpace(Sizes.s8),
                                RegisterWidgetClass().phoneTextBox(
                                  context,
                                  hPadding: 00,
                                  dialCode: value.dialCode,
                                  value.numberCtrl,
                                  value.numberFocus,
                                  isValidator: false,
                                  onChanged: (CountryCodeCustom? code) =>
                                      value.changeDialCode(code!),
                                  onFieldSubmitted: (values) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                  },
                                ),
                                const VSpace(Sizes.s16),
                                Row(
                                  children: [
                                    CheckBoxCommon(
                                      isCheck: value.isCheck,
                                      onTap: () =>
                                          value.isCheckBoxCheck(!value.isCheck),
                                    ),
                                    const HSpace(Sizes.s10),
                                    Text(
                                      language(
                                        context,
                                        translations!.setAsPrimary,
                                      ),
                                      style: appCss.dmDenseMedium14.textColor(
                                        !value.isCheck
                                            ? appColor(
                                                context,
                                              ).primary.withValues(alpha: 0.5)
                                            : appColor(context).primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const VSpace(Sizes.s35),
                                ButtonCommon(
                                  isLoading: value.isLoading,
                                  title: value.isEdit
                                      ? translations!.updateLocation ??
                                            language(
                                              context,
                                              appFonts.updateLocation,
                                            )
                                      : translations!.addLocation ??
                                            language(
                                              context,
                                              appFonts.addLocation,
                                            ),
                                  onTap: () => value.onAddLocation(context),
                                ),
                              ],
                            )
                            .paddingAll(Insets.i20)
                            .boxShapeExtension(
                              color: appColor(context).fieldCardBg,
                              radius: AppRadius.r12,
                            )
                            .padding(
                              horizontal: Insets.i20,
                              vertical: Insets.i20,
                            ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
