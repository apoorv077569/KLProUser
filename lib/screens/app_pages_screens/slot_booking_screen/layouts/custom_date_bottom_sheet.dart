import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../config.dart';

class CustomDateBottomSheet extends StatelessWidget {
  const CustomDateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Consumer<SlotBookingProvider>(
          builder: (context1, value, child) {
            /// MAX BOOKING DAYS

            int maxBookingDays = 365;

            if (appSettingModel?.defaultCreationLimits?.maxBookingDays !=
                null) {
              maxBookingDays =
                  int.tryParse(
                    appSettingModel!.defaultCreationLimits!.maxBookingDays!,
                  ) ??
                  365;
            }

            /// DATE RANGE

            final DateTime maxBookingDate = DateTime.now().add(
              Duration(days: maxBookingDays),
            );

            final DateTime today = DateTime.now();

            /// VALID FOCUSED DAY

            DateTime validFocusedDay = value.focusedDay.value;

            if (validFocusedDay.isBefore(today)) {
              validFocusedDay = today;
            } else if (validFocusedDay.isAfter(maxBookingDate)) {
              validFocusedDay = maxBookingDate;
            }

            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),

              child: DraggableScrollableSheet(
                initialChildSize: 0.7,

                maxChildSize: 0.95,

                minChildSize: 0.4,

                expand: false,

                builder: (BuildContext context, ScrollController scrollController) {
                  return Stack(
                    children: [
                      /// MAIN CONTENT
                      ListView(
                        controller: scrollController,

                        padding: const EdgeInsets.symmetric(
                          vertical: Insets.i20,
                        ),

                        children: [
                          /// HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                language(context, translations!.selectDateOnly),

                                style: appCss.dmDenseMedium18.textColor(
                                  appColor(context).darkText,
                                ),
                              ),

                              const Icon(CupertinoIcons.multiply).inkWell(
                                onTap: () {
                                  debugPrint("APPU_DEBUG CLOSE BUTTON CLICKED");

                                  route.pop(context);
                                },
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Insets.i20),

                          const VSpace(Sizes.s15),

                          /// CALENDAR
                          TableCalendar(
                            rowHeight: 55,

                            headerVisible: true,

                            daysOfWeekVisible: true,

                            focusedDay: validFocusedDay,

                            firstDay: today,

                            lastDay: maxBookingDate,

                            calendarFormat: CalendarFormat.month,

                            startingDayOfWeek: StartingDayOfWeek.monday,

                            /// SELECTED DATE CHECK
                            selectedDayPredicate: (day) {
                              return value.customSelectedDates.any(
                                (selectedDate) =>
                                    selectedDate.year == day.year &&
                                    selectedDate.month == day.month &&
                                    selectedDate.day == day.day,
                              );
                            },

                            /// ENABLE DATE RANGE
                            enabledDayPredicate: (day) {
                              final todayStart = DateTime(
                                today.year,
                                today.month,
                                today.day,
                              );

                              final dayStart = DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );

                              final maxDate = DateTime(
                                maxBookingDate.year,
                                maxBookingDate.month,
                                maxBookingDate.day,
                              );

                              return (dayStart.isAtSameMomentAs(todayStart) ||
                                      dayStart.isAfter(todayStart)) &&
                                  (dayStart.isBefore(maxDate) ||
                                      dayStart.isAtSameMomentAs(maxDate));
                            },

                            /// DATE CLICK
                            onDaySelected: (selectedDay, focusedDay) {
                              debugPrint(
                                "APPU_DEBUG DATE CLICKED => $selectedDay",
                              );

                              value.onCustomDateToggle(selectedDay);

                              debugPrint(
                                "APPU_DEBUG TOTAL SELECTED DATES => ${value.customSelectedDates.length}",
                              );
                            },

                            /// HEADER STYLE
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,

                              titleCentered: true,

                              titleTextStyle: appCss.dmDenseMedium16.textColor(
                                appColor(context).darkText,
                              ),
                            ),

                            /// DAYS STYLE
                            daysOfWeekStyle: DaysOfWeekStyle(
                              dowTextFormatter: (date, locale) =>
                                  DateFormat.E(locale).format(date)[0],

                              weekdayStyle: appCss.dmDenseBold14.textColor(
                                appColor(context).primary,
                              ),

                              weekendStyle: appCss.dmDenseBold14.textColor(
                                appColor(context).primary,
                              ),
                            ),

                            /// CALENDAR STYLE
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                color: appColor(context).primary,

                                shape: BoxShape.circle,
                              ),

                              selectedTextStyle: appCss.dmDenseMedium14
                                  .textColor(appColor(context).whiteColor),

                              todayDecoration: BoxDecoration(
                                color: appColor(
                                  context,
                                ).primary.withOpacity(0.3),

                                shape: BoxShape.circle,
                              ),

                              todayTextStyle: appCss.dmDenseMedium14.textColor(
                                appColor(context).darkText,
                              ),

                              defaultTextStyle: appCss.dmDenseLight14.textColor(
                                appColor(context).darkText,
                              ),

                              weekendTextStyle: appCss.dmDenseLight14.textColor(
                                appColor(context).darkText,
                              ),

                              disabledTextStyle: appCss.dmDenseLight14
                                  .textColor(appColor(context).lightText),
                            ),
                          ).paddingAll(Insets.i20),

                          const VSpace(Sizes.s15),

                          /// SELECTED DATE COUNT
                          if (value.customSelectedDates.isNotEmpty)
                            Text(
                              "${value.customSelectedDates.length} Dates Selected",

                              textAlign: TextAlign.center,

                              style: appCss.dmDenseMedium14.textColor(
                                appColor(context).primary,
                              ),
                            ).paddingSymmetric(horizontal: Insets.i20),

                          const VSpace(Sizes.s100),
                        ],
                      ),

                      /// BOTTOM BUTTONS
                      Align(
                        alignment: Alignment.bottomCenter,

                        child: Container(
                          padding: const EdgeInsets.only(
                            left: Sizes.s20,
                            right: Sizes.s20,
                            bottom: Sizes.s20,
                            top: Sizes.s10,
                          ),

                          color: appColor(context).whiteBg,

                          child: Row(
                            children: [
                              /// CLEAR BUTTON
                              Expanded(
                                child: SizedBox(
                                  height: 52,

                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: appColor(context).primary,
                                      ),

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),

                                    onPressed: () {
                                      debugPrint(
                                        "APPU_DEBUG CLEAR BUTTON CLICKED",
                                      );

                                      value.clearCustomDates();

                                      debugPrint(
                                        "APPU_DEBUG ALL DATES CLEARED",
                                      );
                                    },

                                    child: Text(
                                      "Clear All",

                                      style: appCss.dmDenseMedium16.textColor(
                                        appColor(context).primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const HSpace(Sizes.s15),

                              /// APPLY BUTTON
                              Expanded(
                                child: SizedBox(
                                  height: 52,

                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: appColor(
                                        context,
                                      ).primary,

                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),

                                    onPressed: () {
                                      debugPrint(
                                        "APPU_DEBUG ADD DATE & TIME BUTTON CLICKED",
                                      );

                                      /// CHECK DATE

                                      if (value.customSelectedDates.isEmpty) {
                                        debugPrint(
                                          "APPU_DEBUG NO DATE SELECTED",
                                        );

                                        Fluttertoast.showToast(
                                          msg: "Please select date",
                                        );

                                        return;
                                      }

                                      /// SELECTED DATE

                                      final selectedDate =
                                          value.customSelectedDates.first;

                                      /// GET TIME VALUES

                                      String hour = appArray
                                          .hourList[value.scrollHourIndex];

                                      String minute = appArray
                                          .minList[value.scrollMinIndex];

                                      String amPm =
                                          appArray.amPmList[value.amIndex ?? 0];

                                      debugPrint(
                                        "APPU_DEBUG TIME => $hour:$minute $amPm",
                                      );

                                      /// CREATE FULL DATETIME

                                      DateTime finalDateTime =
                                          DateFormat(
                                            "dd-MM-yyyy hh:mm a",
                                          ).parse(
                                            "${DateFormat("dd-MM-yyyy").format(selectedDate)} "
                                            "$hour:$minute $amPm",
                                          );

                                      debugPrint(
                                        "APPU_DEBUG FINAL DATETIME => $finalDateTime",
                                      );

                                      /// =====================================
                                      /// SLOT BOOKING PROVIDER UPDATE
                                      /// =====================================

                                      value.servicesCart?.serviceDate =
                                          finalDateTime;

                                      value
                                              .servicesCart
                                              ?.selectedDateTimeFormat =
                                          amPm;

                                      /// SAVE IN SELECTED LIST

                                      value.selectedDateList.clear();

                                      value.selectedDateList.add(selectedDate);

                                      debugPrint(
                                        "APPU_DEBUG SLOT BOOKING DATE SAVED",
                                      );

                                      value.notifyListeners();

                                      /// =====================================
                                      /// SERVICE SELECT PROVIDER UPDATE
                                      /// =====================================

                                      final serviceProvider =
                                          Provider.of<ServiceSelectProvider>(
                                            context,
                                            listen: false,
                                          );

                                      serviceProvider
                                              .servicesCart
                                              ?.serviceDate =
                                          finalDateTime;

                                      serviceProvider
                                              .servicesCart
                                              ?.selectedDateTimeFormat =
                                          amPm;

                                      debugPrint(
                                        "APPU_DEBUG SERVICE SELECT DATE SAVED",
                                      );

                                      serviceProvider.notifyListeners();

                                      /// =====================================
                                      /// CLOSE BOTTOM SHEET
                                      /// =====================================

                                      Navigator.of(context).pop();

                                      debugPrint(
                                        "APPU_DEBUG BOTTOM SHEET CLOSED",
                                      );
                                    },
                                    child: Text(
                                      "Add Date & Time",

                                      style: appCss.dmDenseMedium16.textColor(
                                        appColor(context).whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).bottomSheetExtension(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
