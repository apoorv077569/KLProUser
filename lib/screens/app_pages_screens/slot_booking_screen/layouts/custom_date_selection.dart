import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:provider/provider.dart';
import '../../../../../config.dart';

class CustomDateSelectionLayout extends StatelessWidget {
  const CustomDateSelectionLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SlotBookingProvider>(
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.s15,
            vertical: Sizes.s10,
          ),
          decoration: ShapeDecoration(
            color: appColor(context).whiteBg,
            shape: SmoothRectangleBorder(
              side: BorderSide(color: appColor(context).stroke),
              borderRadius: SmoothBorderRadius(
                cornerRadius: 8,
                cornerSmoothing: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const HSpace(Sizes.s12),

                    /// Selected custom dates
                    if (value.customSelectedDates.isNotEmpty)
                      Expanded(
                        child: Wrap(
                          children: value.customSelectedDates
                              .asMap()
                              .entries
                              .map(
                                (e) => Container(
                                  margin: EdgeInsets.only(
                                    bottom:
                                        value.customSelectedDates.length - 1 !=
                                            e.key
                                        ? Sizes.s8
                                        : 0,
                                    right: Sizes.s5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.s9,
                                    vertical: Sizes.s5,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color.fromRGBO(
                                      84,
                                      101,
                                      255,
                                      0.1,
                                    ),
                                    shape: SmoothRectangleBorder(
                                      borderRadius: SmoothBorderRadius(
                                        cornerRadius: 8,
                                        cornerSmoothing: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        eSvgAssets.cross,
                                        height: 16,
                                        colorFilter: ColorFilter.mode(
                                          appColor(context).primary,
                                          BlendMode.srcIn,
                                        ),
                                      ).inkWell(
                                        onTap: () =>
                                            value.onCustomDateToggle(e.value),
                                      ),
                                      const HSpace(Sizes.s2),
                                      Text(
                                        DateFormat('dd MMM').format(e.value),
                                        style: appCss.dmDenseLight14.textColor(
                                          appColor(context).primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),

                    /// Placeholder
                    if (value.customSelectedDates.isEmpty)
                      Text(
                        language(context, translations!.selectDateOnly),
                        style: appCss.dmDenseMedium14.textColor(
                          appColor(context).lightText,
                        ),
                      ),
                  ],
                ),
              ),
              SvgPicture.asset(
                eSvgAssets.dropDown,
                colorFilter: ColorFilter.mode(
                  value.customSelectedDates.isNotEmpty
                      ? appColor(context).darkText
                      : appColor(context).lightText,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ).inkWell(
          onTap: () {
            debugPrint("APPU_DEBUG DATE SELECTION BUTTON CLICKED");

            debugPrint("APPU_DEBUG OPENING CUSTOM DATE BOTTOM SHEET");

            value.onCustomDateBottomSheet(context);

            debugPrint("APPU_DEBUG CUSTOM DATE BOTTOM SHEET OPENED");
          },
        );
      },
    );
  }
}
