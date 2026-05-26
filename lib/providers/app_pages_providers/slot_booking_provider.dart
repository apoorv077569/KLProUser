import 'dart:convert';
import 'dart:developer';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:collection/collection.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:klpro_user/models/step2model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/layouts/custom_date_bottom_sheet.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/layouts/date_range_picker_layout.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/layouts/week_bottom_sheet.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/layouts/year_dialog.dart';
import 'package:klpro_user/users_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../config.dart';
import '../../models/is_valid_time_slot_model.dart';
import '../../models/time_slot_model.dart';
import '../../screens/app_pages_screens/slot_booking_screen/layouts/provider_time_slot_layout.dart';
import '../../utils/date_time_picker.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class SlotBookingProvider with ChangeNotifier {
  Services? servicesCart;
  int selectIndex = 0;
  bool isStep2 = false, isPackage = false, isBottom = true;
  PrimaryAddress? address;
  int selectProviderIndex = 0;
  List timeSlot = [];
  List newTimeSlot = [];
  String _slotChosenValue = "";
  String get slotChosenValue => _slotChosenValue;

  set slotChosenValue(String value) {
    _slotChosenValue = value;
    notifyListeners();
  }

  String _selectedHour = "12";
  String _selectedMinute = "00";
  String _selectedPeriod = "PM";

  /// ======================================
  /// CAROUSEL CONTROLLERS
  /// ======================================

  CarouselSliderController hourController = CarouselSliderController();

  CarouselSliderController minuteController = CarouselSliderController();

  CarouselSliderController amPmController = CarouselSliderController();

  /// ======================================
  /// HOUR LIST
  /// ======================================

  List<String> hourList = List.generate(
    12,

    (index) => (index + 1).toString().padLeft(2, '0'),
  );

  /// ======================================
  /// MINUTE LIST
  /// ======================================

  List<String> minuteList = List.generate(
    60,

    (index) => index.toString().padLeft(2, '0'),
  );

  /// ======================================
  /// AM PM LIST
  /// ======================================

  List<String> amPmList = ["AM", "PM"];

  String get selectedHour => _selectedHour;
  set selectedHour(String value) {
    _selectedHour = value;
  }

  String get selectedMinute => _selectedMinute;
  set selectedMinute(String value) {
    _selectedMinute = value;
  }

  String get selectedPeriod => _selectedPeriod;
  set selectedPeriod(String value) {
    _selectedPeriod = value;
  }

  int selectAmPm = 0;
  int demoInt = 0;
  dynamic chosenValue;
  DateTime? selectedDay;
  DateTime selectedYear = DateTime.now();
  DateTime currentDate = DateTime.now();
  List<String> newWeekDayList = [];
  //ServicesDetailsProvider
  TextEditingController startDateCtrl = TextEditingController();
  TextEditingController endDateCtrl = TextEditingController();
  ScrollController scrollController = ScrollController();
  final ValueNotifier<DateTime> focusedDay = ValueNotifier(DateTime.now());
  dynamic slotTime;
  DateTime? slotSelectedDay;
  DateTime slotSelectedYear = DateTime.now();
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime? rangeStart;
  DateTime? rangeEnd;
  List<DateTime> selectedDateList = [];
  List<DateTime> customSelectedDates = []; // For custom frequency

  int selectedIndex = 0;
  int scrollDayIndex = 0;
  int scrollMinIndex = 0;
  int scrollHourIndex = 0;
  String? bookingFrequency;
  String showYear = 'Select Year';
  TimeSlotModel? timeSlotModel;
  PageController pageController = PageController();
  CalendarFormat calendarFormat = CalendarFormat.week;
  CalendarFormat calendarFormatMonth = CalendarFormat.month;
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final CarouselSliderController carouselController1 =
      CarouselSliderController();
  final CarouselSliderController carouselController2 =
      CarouselSliderController();
  final ValueNotifier<DateTime> focuseDay = ValueNotifier(DateTime.now());
  IsValidTimeSlotModel? isValidTimeSlotModel;
  List<AvailableProvider> availableProviders = [];
  final FocusNode noteFocus = FocusNode();
  final FocusNode startDateFocus = FocusNode();
  final FocusNode endDateFocus = FocusNode();
  bool visible = true;
  int val = 1;
  double loginWidth = 100.0;
  TextEditingController txtNote = TextEditingController();
  int? amIndex;

  int? timeIndex;
  bool isVisible = false;

  bool isPositionedRight = false;
  bool isAnimateOver = false;
  AnimationController? controller;
  Animation<Offset>? offsetAnimation;

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    noteFocus.dispose();
    txtNote.clear();
    controller?.dispose();
    super.dispose();
  }

  void updateSlotDateTime(String valueData) {
    slotChosenValue = valueData;

    notifyListeners();
  }

  onChangeWeekDay(String day) {
    if (!newWeekDayList.contains(day)) {
      newWeekDayList.add(day);
    } else {
      newWeekDayList.remove(day);
    }
    calculateSelectedDays();
    notifyListeners();
  }

  // Custom date selection methods
  onCustomDateToggle(DateTime date) {
    // Normalize date to remove time component
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final index = customSelectedDates.indexWhere(
      (d) =>
          d.year == normalizedDate.year &&
          d.month == normalizedDate.month &&
          d.day == normalizedDate.day,
    );

    if (index >= 0) {
      customSelectedDates.removeAt(index);
    } else {
      customSelectedDates.add(normalizedDate);
    }

    // Sort dates chronologically
    customSelectedDates.sort((a, b) => a.compareTo(b));

    // Update selectedDateList for custom frequency
    if (bookingFrequency == 'custom') {
      selectedDateList = List.from(customSelectedDates);
    }

    notifyListeners();
  }

  onCustomDateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const CustomDateBottomSheet();
      },
    );
  }

  clearCustomDates() {
    customSelectedDates.clear();
    if (bookingFrequency == 'custom') {
      selectedDateList.clear();
    }
    notifyListeners();
  }

  bool? isTap = false;
  onWeekBottomSheet(context) async {
    isTap = true;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const WeekBottomSheet();
      },
    ).then((value) {
      isTap = false;
      notifyListeners();
    });
  }

  addNewLoc(context) {
    route.pushNamed(context, routeName.addNewLocation).then((e) {
      debugPrint("APPU_DEBUG BACK FROM LOCATION SCREEN");

      /// SET LOCATION IN SLOT1

      if (userPrimaryAddress != null) {
        address = userPrimaryAddress;

        debugPrint("APPU_DEBUG LOCATION VALUE SET IN SLOT1");

        notifyListeners();
      }
    });
  }

  onChangeBookingFrequency(val) {
    bookingFrequency = val;
    calculateSelectedDays();
    notifyListeners();
  }

  void initBookingFrequency() {
    if (bookingFrequency == null && appArray.bookingFrequencyList.isNotEmpty) {
      bookingFrequency = appArray.bookingFrequencyList.first;
      notifyListeners();
    }
  }

  onDateSelect(context, date, {isStart = true}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Consumer<SlotBookingProvider>(
            builder: (context, value, child) {
              return const DateRangePickerLayout();
            },
          );
        },
      ),
    );
  }

  // date selection button and go to back
  onSelect(context) {
    route.pop(context);
    if (rangeEnd != null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 500),
          content: Text(
            "opps!! you have not select date yet.",
            style: appCss.dmDenseMedium12.textColor(
              appColor(context).whiteColor,
            ),
          ),
          backgroundColor: appColor(context).red,
        ),
      );
    }
    notifyListeners();
  }

  //select year
  selectYear(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context3) {
        return const YearAlertDialog();
      },
    );
  }

  onRangeSelect(start, end, focusedDay) {
    selectedDay = null;
    currentDate = focusedDay;
    rangeStart = start;
    rangeEnd = end;
    log("STTT :$start");
    log("STTT :$rangeStart");
    log("STTT :$rangeEnd");
    rangeSelectionMode = RangeSelectionMode.toggledOn;
    startDateCtrl.text = DateFormat("dd-MM-yyyy").format(rangeStart!);
    endDateCtrl.text = rangeEnd != null
        ? DateFormat("dd-MM-yyyy").format(rangeEnd!)
        : "";
    calculateSelectedDays();
    notifyListeners();
  }

  void calculateSelectedDays() {
    selectedDateList.clear();
    if (rangeStart != null && rangeEnd != null) {
      DateTime tempDate = rangeStart!;
      if (bookingFrequency == 'daily') {
        while (tempDate.isBefore(rangeEnd!) ||
            tempDate.isAtSameMomentAs(rangeEnd!)) {
          String weekdayName = DateFormat('EEEE').format(tempDate);
          if (newWeekDayList.contains(weekdayName)) {
            selectedDateList.add(tempDate);
          }
          tempDate = tempDate.add(const Duration(days: 1));
        }
      } else if (bookingFrequency == 'weekly') {
        while (tempDate.isBefore(rangeEnd!) ||
            tempDate.isAtSameMomentAs(rangeEnd!)) {
          selectedDateList.add(tempDate);
          tempDate = tempDate.add(const Duration(days: 7));
        }
      } else if (bookingFrequency == 'monthly') {
        while (tempDate.isBefore(rangeEnd!) ||
            tempDate.isAtSameMomentAs(rangeEnd!)) {
          selectedDateList.add(tempDate);
          tempDate = DateTime(tempDate.year, tempDate.month + 1, tempDate.day);
        }
      } else if (bookingFrequency == 'yearly') {
        while (tempDate.isBefore(rangeEnd!) ||
            tempDate.isAtSameMomentAs(rangeEnd!)) {
          selectedDateList.add(tempDate);
          tempDate = DateTime(tempDate.year + 1, tempDate.month, tempDate.day);
        }
      } else {
        selectedDateList.add(rangeStart!);
        if (rangeEnd != null && !isSameDay(rangeStart, rangeEnd)) {}
      }
    }
    log("Selected dates count: ${selectedDateList.length}");
  }

  Future<void> fetchTimeSlots() async {
    debugPrint("APPU_DEBUG TIME SLOT API DISABLED");

    DateTime now = DateTime.now();

    /// USER CAN BOOK AFTER 10 MINUTES
    DateTime minBookingTime = now.add(const Duration(minutes: 10));

    timeSlot.clear();

    /// GENERATE 30 MIN SLOT
    for (int i = 0; i < 48; i++) {
      DateTime slot = DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
      ).add(Duration(minutes: i * 30));

      /// ONLY FUTURE SLOT
      if (slot.isAfter(minBookingTime)) {
        timeSlot.add(DateFormat("hh:mm a").format(slot));

        debugPrint("APPU_DEBUG SLOT => $slot");
      }
    }

    notifyListeners();
  }

  Future<bool> checkServiceAvailability(context) async {
    debugPrint("APPU_DEBUG SERVICE AVAILABILITY DISABLED");

    return true;
  }

  deleteJobRequestConfirmation(context, sync, index) {
    animateDesign(sync);
    showDialog(
      context: context,
      builder: (context1) {
        return StatefulBuilder(
          builder: (context2, setState) {
            return Consumer<SlotBookingProvider>(
              builder: (context3, value, child) {
                return AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  insetPadding: const EdgeInsets.symmetric(
                    horizontal: Insets.i20,
                  ),
                  shape: const SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.all(
                      SmoothRadius(
                        cornerRadius: AppRadius.r14,
                        cornerSmoothing: 1,
                      ),
                    ),
                  ),
                  backgroundColor: appColor(context).whiteBg,
                  content: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Gif
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                          height: Sizes.s208,
                                          width: Sizes.s150,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            curve: isPositionedRight
                                                ? Curves.bounceIn
                                                : Curves.bounceOut,
                                            alignment: isPositionedRight
                                                ? Alignment.center
                                                : Alignment.topCenter,
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              height: 40,
                                              child: Image.asset(
                                                eImageAssets.removeAddOn,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          eImageAssets.dustbin,
                                          height: Sizes.s88,
                                          width: Sizes.s88,
                                        ).paddingOnly(bottom: Insets.i24),
                                      ],
                                    ),
                                  ).decorated(
                                    color: appColor(context).fieldCardBg,
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r10,
                                    ),
                                  ),
                                ],
                              ),
                              if (offsetAnimation != null)
                                SlideTransition(
                                  position: offsetAnimation!,
                                  child:
                                      (offsetAnimation != null &&
                                          isAnimateOver == true)
                                      ? Image.asset(
                                          eImageAssets.dustbinCover,
                                          height: 38,
                                        )
                                      : const SizedBox(),
                                ),
                            ],
                          ),
                          // Sub text
                          const VSpace(Sizes.s15),
                          Text(
                            language(context, translations!.removeAddOnsDes),
                            textAlign: TextAlign.center,
                            style: appCss.dmDenseRegular14
                                .textColor(appColor(context).lightText)
                                .textHeight(1.6),
                          ).paddingSymmetric(horizontal: Sizes.s56),
                          const VSpace(Sizes.s25),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonCommon(
                                  onTap: () => route.pop(context),
                                  title:
                                      translations?.no ??
                                      language(context, appFonts.no),
                                  borderColor: appColor(context).primary,
                                  color: appColor(context).whiteBg,
                                  style: appCss.dmDenseSemiBold16.textColor(
                                    appColor(context).primary,
                                  ),
                                ),
                              ),
                              const HSpace(Sizes.s15),
                              Expanded(
                                child: ButtonCommon(
                                  color: appColor(context).primary,
                                  onTap: () {
                                    servicesCart!.selectedAdditionalServices!
                                        .removeAt(index);
                                    notifyListeners();
                                    route.pop(context);
                                  },
                                  style: appCss.dmDenseSemiBold16.textColor(
                                    appColor(context).whiteColor,
                                  ),
                                  title:
                                      translations?.yes ??
                                      language(context, appFonts.yes),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).padding(
                        horizontal: Insets.i20,
                        top: Insets.i60,
                        bottom: Insets.i20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Text(
                            language(context, translations!.removeAddOns),
                            style: appCss.dmDenseExtraBold18.textColor(
                              appColor(context).darkText,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.multiply,
                            size: Sizes.s20,
                            color: appColor(context).darkText,
                          ).inkWell(onTap: () => route.pop(context)),
                        ],
                      ).paddingAll(Insets.i20),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).then((value) {
      isPositionedRight = false;
      isAnimateOver = false;
      notifyListeners();
    });
  }

  animateDesign(TickerProvider sync) {
    Future.delayed(DurationClass.s1)
        .then((value) {
          isPositionedRight = true;
          notifyListeners();
        })
        .then((value) {
          Future.delayed(DurationClass.ms150)
              .then((value) {
                isAnimateOver = true;
                notifyListeners();
              })
              .then((value) {
                controller = AnimationController(
                  vsync: sync,
                  duration: const Duration(seconds: 2),
                )..forward();
                offsetAnimation =
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: const Offset(0, 1.6),
                    ).animate(
                      CurvedAnimation(
                        parent: controller!,
                        curve: Curves.elasticOut,
                      ),
                    );
                notifyListeners();
              });
        });

    notifyListeners();
  }

  bool isNextLoading = false;
  List? selectedAddons;
  Future<void> onTapNext(BuildContext context) async {
    isNextLoading = true;

    notifyListeners();

    /// CHECK SERVICE AVAILABILITY

    bool isAvailable = await checkServiceAvailability(context);

    if (!isAvailable) {
      isNextLoading = false;

      notifyListeners();

      return;
    }

    /// RESET SERVICEMAN

    if (servicesCart != null) {
      servicesCart!.selectedServiceMan = null;
    }

    /// CHECK DATE SELECTION

    bool isScheduled =
        servicesCart?.type == 'scheduled' || servicesCart?.type == 'schedule';

    bool isDateSelected = isScheduled
        ? selectedDateList.isNotEmpty
        : servicesCart?.serviceDate != null;

    if (!isDateSelected) {
      isNextLoading = false;

      notifyListeners();

      Fluttertoast.showToast(
        msg: "Please Select the Date & Time Slot",

        backgroundColor: Colors.red,
      );

      return;
    }

    /// PACKAGE FLOW

    if (isPackage) {
      log("selectProviderIndex :$selectProviderIndex");

      servicePackageList[selectProviderIndex] = servicesCart!;

      servicePackageList[selectProviderIndex].selectedServiceNote =
          txtNote.text;

      servicesCart!.serviceDate = focusedDay.value;

      servicesCart!.selectedDateTimeFormat = DateFormat(
        "aa",
      ).format(focusedDay.value);

      servicePackageList[selectProviderIndex].serviceDate = focusedDay.value;

      servicePackageList[selectProviderIndex].selectServiceManType =
          "app_choose";

      isNextLoading = false;

      notifyListeners();

      route.pop(context);
    } else {
      /// LOCATION VALIDATION

      if (address == null) {
        isNextLoading = false;

        notifyListeners();

        Fluttertoast.showToast(
          msg: "Please Select the Location",

          backgroundColor: Colors.red,
        );

        return;
      }

      /// SAVE NOTE

      servicesCart!.selectedServiceNote = txtNote.text;

      /// SERVICE MAN TYPE

      servicesCart!.selectServiceManType = "app_choose";

      /// DUMMY BOOKING DATA

      Map<String, dynamic> bookingData = {
        "location": currentAddress,

        "date": servicesCart?.serviceDate.toString(),

        "note": txtNote.text,

        "serviceId": servicesCart?.id,

        "providerId": servicesCart?.userId,
      };

      debugPrint("APPU_DEBUG BOOKING DATA => $bookingData");
      servicesCart?.price = 299;

      servicesCart?.requiredServicemen = 1;

      servicesCart?.selectedRequiredServiceMan = 1;

      servicesCart?.tax = "0";

      debugPrint("APPU_DEBUG DUMMY PRICE SET");

      isStep2 = true;

      debugPrint("APPU_DEBUG STEP2 OPENED");

      /// STOP LOADING

      isNextLoading = false;

      notifyListeners();

      debugPrint("APPU_DEBUG REDIRECT TO PENDING BOOKING");
    }
  }

  onChangeSlot(index) {
    timeIndex = index;
    notifyListeners();
    checkSlotAvailable();
  }

  void onAmPmChange(BuildContext context, int index) {
    scrollDayIndex = index;
    amIndex = index;
    _selectedPeriod = amPmList[index]; // Period string sync kiye rakhne ke liye
    notifyListeners();
    filterSlotByAmPm(context);
  }

  Future<void> filterSlotByAmPm(BuildContext context) async {
    showLoading(context);
    notifyListeners();

    try {
      if (timeSlotModel?.timeSlots == null) {
        hideLoading(context);
        return;
      }

      String day = DateFormat('EEEE').format(focusedDay.value).toUpperCase();
      List<TimeSlots> dayWeek = timeSlotModel!.timeSlots;
      int index = dayWeek.indexWhere(
        (element) => element.day.toLowerCase() == day.toLowerCase(),
      );

      // Temporary list banayi taaki direct manipulation crash na kare
      List<String> tempFilteredSlots = [];

      if (index >= 0 && dayWeek[index].isActive == "1" ||
          dayWeek[index].isActive == 1) {
        List<dynamic> rawSlots = dayWeek[index].slots;
        bool isToday = isSameDay(focusedDay.value, DateTime.now());
        DateTime now = DateTime.now();

        for (var rawSlot in rawSlots) {
          String slot = rawSlot.toString();
          List<String> parts = slot.split(":");
          if (parts.length < 2) continue;

          int hour = int.tryParse(parts[0]) ?? 0;
          int slotMinute = int.tryParse(parts[1]) ?? 0;

          // 1. AM/PM Basic Separation Filter
          bool isAmSlot = hour < 12;
          if (scrollDayIndex == 0 && !isAmSlot)
            continue; // AM screen par PM data skip karo
          if (scrollDayIndex == 1 && isAmSlot)
            continue; // PM screen par AM data skip karo

          // 2. Real-time Past Filter (Agar aaj ka din selected hai)
          if (isToday) {
            if (scrollDayIndex == 0 && now.hour >= 12) {
              continue; // Agar dophar ke 12 baj chuke hain toh AM slots display mat karo
            }
            if (hour < now.hour ||
                (hour == now.hour && slotMinute < now.minute)) {
              continue; // Beeta hua time filter karke skip karo
            }
          }

          tempFilteredSlots.add(slot);
        }
      }

      // Safe update assignment bina internal loop breaks ke
      timeSlot = tempFilteredSlots;
      timeIndex = null;
    } catch (e) {
      debugPrint("APPU_DEBUG_FILTER_CRASH => $e");
    } finally {
      // Kisi bhi haal me yahan loader band hoga hi hoga!
      hideLoading(context);
      notifyListeners();
    }
  }

  onChangeLocation(context, PrimaryAddress primaryAddress) async {
    final loc = Provider.of<LocationProvider>(context, listen: false);
    await loc.getLocationList(context);
    address = primaryAddress;
    if (isPackage) {
      final packageCtrl = Provider.of<SelectServicemanProvider>(
        context,
        listen: false,
      );
      servicePackageList[selectProviderIndex].primaryAddress = address;
      packageCtrl.notifyListeners();
    } else {
      servicesCart!.primaryAddress = address;
    }

    notifyListeners();
  }

  void onDaySelected(DateTime selectDay, DateTime fDay, BuildContext context) {
    if (!isSameDay(selectedDay, selectDay)) {
      selectedDay = selectDay;
      focusedDay.value = fDay;
      scrollDayIndex =
          isSameDay(selectDay, DateTime.now()) && DateTime.now().hour >= 12
          ? 1
          : 0;
      amIndex = scrollDayIndex;
      timeIndex = null;
      log(">>> onDaySelected: $selectDay");
      log(">>> Weekday: ${DateFormat('EEEE').format(selectDay)}");

      // Refresh time slot list (if applicable)
      updateTimeSlotsForSelectedDay(context: context);

      // 🔥 Add this line
      notifyListeners();
    }
  }

  void onProviderDaySelected(
    DateTime selectDay,
    DateTime fDay,
    BuildContext context,
  ) {
    if (!isSameDay(selectedDay, selectDay)) {
      selectedDay = selectDay;
      focusedDay.value = fDay;
      scrollDayIndex =
          isSameDay(selectDay, DateTime.now()) && DateTime.now().hour >= 12
          ? 1
          : 0;
      amIndex = scrollDayIndex;
      timeIndex = null;
      // carouselController2.jumpToPage(scrollDayIndex);
      updateTimeSlotsForSelectedDay(context: context);
    }
  }

  int count = 0;
  void onInit(
    BuildContext context, {
    bool? isPackage,
    int? index,
    Services? service,
    bool isProviderTimeSlot = false,
  }) async {
    this.isPackage = isPackage ?? false;
    selectProviderIndex = index ?? 0;
    servicesCart = service;

    DateTime now = DateTime.now();
    DateTime bufferTime = now.add(const Duration(minutes: 30));
    onDaySelect(focusedDay.value, focusedDay.value);

    DateTime timeToAssign = (servicesCart?.serviceDate != null)
        ? servicesCart!.serviceDate!
        : bufferTime;

    focusedDay.value = timeToAssign;
    selectedDay = timeToAssign;

    int currentRawHour = timeToAssign.hour;
    int displayHour = currentRawHour % 12 == 0 ? 12 : currentRawHour % 12;
    String rawPeriod = currentRawHour >= 12 ? "PM" : "AM";
    String minuteString = timeToAssign.minute.toString().padLeft(2, '0');
    String hourString = displayHour.toString().padLeft(2, '0');

    _selectedHour = hourString;

    _selectedMinute = minuteString;
    _selectedPeriod = rawPeriod;
    slotChosenValue = "$_selectedHour:$_selectedMinute $_selectedPeriod";

    // Safe lookup structure framework
    var hoursSource = hourList;
    var minutesSource = minuteList;

    scrollHourIndex = hoursSource.indexWhere(
      (element) => int.tryParse(element) == displayHour,
    );
    scrollMinIndex = minutesSource.indexWhere(
      (element) => element == minuteString,
    );

    amIndex = rawPeriod == "PM" ? 1 : 0;
    scrollDayIndex = amIndex!;

    if (scrollHourIndex == -1) scrollHourIndex = 0;
    if (scrollMinIndex == -1) scrollMinIndex = 0;

    // Frame complete hone ke baad carousel slots jump kar jayenge safely
    // Frame completely render hone ke baad 200ms rukenge taaki
    // BottomSheet ke andar ke Carousels safely attach ho sakein
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        try {
          hourController.jumpToPage(scrollHourIndex);
          minuteController.jumpToPage(scrollMinIndex);
          amPmController.jumpToPage(scrollDayIndex);
          debugPrint("APPU_DEBUG_CAROUSEL => Carousels jumped successfully!");
        } catch (e) {
          debugPrint("APPU_DEBUG_CAROUSEL_ERROR => Catch handled safely: $e");
        }
      });
    });

    try {
      int monthIndex = appArray.monthList.indexWhere(
        (element) => element['index'] == focusedDay.value.month,
      );
      if (monthIndex != -1) {
        chosenValue = appArray.monthList[monthIndex];
      }
    } catch (_) {}

    calendarFormat = servicesCart?.type == 'scheduled'
        ? CalendarFormat.month
        : CalendarFormat.week;

    notifyListeners();
  }

  void onDaySelect(DateTime selectDay, DateTime fDay) {
    notifyListeners();
    focusedDay.value = selectDay;
  }

  Future<void> fetchSlotTime(BuildContext context) async {
    // timeSlot = [];
    showLoading(context);
    notifyListeners();
    try {
      final response = await apiServices.getApi(
        "${api.providerTimeSlot}/${servicesCart?.userId ?? 3}",
        [],
        isData: true,
        isToken: true,
      );
      log("CALLA :${response.data}");
      if (response.isSuccess == true) {
        timeSlotModel = TimeSlotModel.fromJson(response.data);
        updateTimeSlotsForSelectedDay();
      } else {
        log("GET API failed: ${response.message}");
        // Fluttertoast.showToast(
        //     msg: response.message, backgroundColor: Colors.red);
      }
    } catch (e) {
      log("EEEE fetchSlotTime: $e");
      // Fluttertoast.showToast(
      //     msg: "Failed to fetch time slots", backgroundColor: Colors.red);
    } finally {
      hideLoading(context);
      notifyListeners();
    }
  }

  void updateTimeSlotsForSelectedDay({BuildContext? context}) {
    if (timeSlotModel?.timeSlots == null) {
      timeSlot = [];
      timeIndex = null;
      notifyListeners();
      return;
    }
    final day = DateFormat('EEEE').format(focusedDay.value).toUpperCase();
    final slot = timeSlotModel!.timeSlots.firstWhereOrNull(
      (element) => element.day.toUpperCase() == day,
    );
    timeSlot = (slot != null && slot.isActive == 1) ? slot.slots : [];
    timeIndex = null; // Reset selected slot
    notifyListeners();
    // Trigger AM/PM filtering if amIndex is set and context is provided
    if (amIndex != null && context != null) {
      filterSlotByAmPm(context);
    }
  }

  Future<void> checkSlotAvailable({
    bool isEdit = false,
    BuildContext? context,
  }) async {
    if (context == null ||
        servicesCart?.user?.id == null ||
        timeIndex == null ||
        timeSlot.isEmpty) {
      timeIndex = null;
      if (context != null) {
        Fluttertoast.showToast(
          msg: "Please select a time slot",
          backgroundColor: Colors.red,
        );
      }
      notifyListeners();
      return;
    }
    try {
      showLoading(context);
      final pref = await SharedPreferences.getInstance();
      String? zoneIds = pref.getString(session.zoneIds);
      final selectedTime = timeSlot[timeIndex!];
      focusedDay.value = DateTime.utc(
        focusedDay.value.year,
        focusedDay.value.month,
        focusedDay.value.day,
        int.parse(selectedTime.split(":")[0]),
        int.parse(selectedTime.split(":")[1]),
      );
      final data = {
        // "provider_id": servicesCart!.user!.id, // Commented: Not sending provider_id to isValidTimeSlot
        "service_id": servicesCart?.id,
        "zone_id": zoneIds, // Using zone_id from session
        "dateTime": DateFormat("dd-MMM-yyyy,hh:mm aa").format(focusedDay.value),
      };
      final response = await apiServices.getApi(
        api.isValidTimeSlot,
        data,
        isData: true,
        isToken: true,
      );
      if (response.isSuccess == true) {
        isValidTimeSlotModel = IsValidTimeSlotModel.fromJson(response.data);
        if (isValidTimeSlotModel?.isValidTimeSlot == true) {
          availableProviders = isValidTimeSlotModel?.data ?? [];
        } else {
          timeIndex = null;
          availableProviders = [];
          Fluttertoast.showToast(
            msg: response.message.isNotEmpty
                ? response.message
                : "Slot not available",
            backgroundColor: Colors.red,
          );
        }
      } else {
        timeIndex = null;
        availableProviders = [];
        Fluttertoast.showToast(
          msg: response.message.isNotEmpty
              ? response.message
              : "Slot not available",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      log("Error checking slot: $e");
      timeIndex = null;
      Fluttertoast.showToast(
        msg: "Error validating slot",
        backgroundColor: Colors.red,
      );
    } finally {
      hideLoading(context);
      notifyListeners();
    }
  }

  bool isLoading = false;

  Future<void> checkSlotAvailableForAppChoose({
    required BuildContext context,
    bool isEdit = false,
    bool isService = false,
  }) async {
    isLoading = true;
    showLoading(context);
    notifyListeners();

    try {
      // Ensure amIndex is valid
      if (amIndex == null && amIndex! < 0 && amIndex! > 1) {
        isLoading = false;
        hideLoading(context);
        Fluttertoast.showToast(
          msg: "Invalid AM/PM selection. Please try again.",
          backgroundColor: Colors.red,
        );
        notifyListeners();
        return;
      }

      // Adjust hour for 12-hour format with AM/PM
      int hour = int.parse(appArray.hourList[scrollHourIndex]);
      String amPm = appArray.amPmList[amIndex!]; // "AM" or "PM"
      if (amPm == "PM" && hour != 12) {
        hour += 12; // Convert PM hours to 24-hour format (e.g., 1 PM -> 13)
      } else if (amPm == "AM" && hour == 12) {
        hour = 0; // Convert 12 AM to midnight
      } else if (amPm == "PM" && hour == 12) {
        hour = 12; // Convert 12 PM to noon
      }

      // Construct selected DateTime in local time
      final selectedDateTime = DateTime(
        focusedDay.value.year,
        focusedDay.value.month,
        focusedDay.value.day,
        hour,
        int.parse(appArray.minList[scrollMinIndex]),
      );

      // Debugging log
      log(
        "Selected DateTime: $selectedDateTime, AM/PM: $amPm, Hour: $hour, Minute: ${appArray.minList[scrollMinIndex]}",
      );

      // Get current time for validation (local time)
      final now = DateTime.now();
      final minAllowedTime = now.add(
        const Duration(minutes: 5),
      ); // Minimum 5 minutes from now

      // Debugging log for validation
      log("Current Time: $now, Min Allowed Time: $minAllowedTime");

      // Validation 1: Check for current date
      final today = DateTime(now.year, now.month, now.day);
      final selectedDate = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
      );
      if (selectedDate.isAtSameMomentAs(today)) {
        // Validation 2: Prevent past, current, or within 5-minute time on current date
        if (selectedDateTime.isBefore(minAllowedTime) ||
            selectedDateTime.isAtSameMomentAs(now)) {
          isLoading = false;
          hideLoading(context);
          Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg:
                "Please select a time at least 5 minutes from now on the current date.",
          );
          notifyListeners();
          return;
        }
      }

      // Update focusedDay.value with validated time
      focusedDay.value = selectedDateTime;

      // Prepare API data
      final pref = await SharedPreferences.getInstance();
      String? zoneIds = pref.getString(session.zoneIds);
      var data = {
        // "provider_id": servicesCart!.userId, // Commented: Not sending provider_id
        "service_id": servicesCart?.id,
        "zone_id": zoneIds, // Using actual zone_id from session
        "dateTime":
            "${DateFormat("dd-MMM-yyy,hh:mm").format(focusedDay.value)} ${amPm.toLowerCase()}",
      };

      // Debugging log
      log("API Data: $data");

      // Make API call to check time slot availability
      await apiServices
          .getApi(api.isValidTimeSlot, data, isData: true, isToken: true)
          .then((value) async {
            hideLoading(context);
            if (value.isSuccess!) {
              isValidTimeSlotModel = IsValidTimeSlotModel.fromJson(value.data);
              if (isValidTimeSlotModel?.isValidTimeSlot == true) {
                availableProviders = isValidTimeSlotModel?.data ?? [];
                dateTimeSelect(context, isService, isEdit: isEdit);
              } else {
                timeIndex = null;
                timeSlot = [];
                availableProviders = [];
                Fluttertoast.showToast(
                  msg: value.message,
                  backgroundColor: Colors.red,
                );
              }
            }
          });
    } catch (e) {
      log("Error: $e");
      hideLoading(context);
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        backgroundColor: Colors.red,
      );
    }

    isLoading = false;
    notifyListeners();
  }

  onMinDecrement() {
    if (scrollMinIndex > 0) {
      scrollMinIndex--;
    }
    carouselController1.jumpToPage(scrollMinIndex);
    notifyListeners();
  }

  onMinIncrement() {
    if (scrollMinIndex < appArray.minList.length - 1) {
      scrollMinIndex++;
    }
    notifyListeners();
    carouselController1.jumpToPage(scrollMinIndex);
    notifyListeners();
  }

  onDayDecrement() {
    if (scrollDayIndex > 0) {
      scrollDayIndex--;
    }
    notifyListeners();
    carouselController2.jumpToPage(scrollDayIndex);
    notifyListeners();
  }

  onDayIncrement() {
    if (scrollDayIndex < appArray.dayList.length) {
      scrollDayIndex++;
    }
    notifyListeners();
    carouselController2.jumpToPage(scrollDayIndex);
    notifyListeners();
  }

  onDropDownChange(choseVal, context) async {
    notifyListeners();

    int index = choseVal['index'];
    log("chosenValue : $index");

    DateTime now = DateTime.utc(
      focusedDay.value.year,
      index,
      focusedDay.value.day,
    );
    log("HHHHHHH :$now ${focusedDay.value}");
    log(
      "HHHHHHH :$now ${now.isAfter(focusedDay.value) || DateFormat('MMMM-yyyy').format(now) == DateFormat('MMMM-yyyy').format(focusedDay.value)}",
    );
    if (now.isAfter(DateTime.now()) ||
        DateFormat('MMMM-yyyy').format(now) ==
            DateFormat('MMMM-yyyy').format(focusedDay.value)) {
      chosenValue = choseVal;

      notifyListeners();
      focusedDay.value = DateTime.utc(
        focusedDay.value.year,
        index,
        focusedDay.value.day + 0,
      );
      onDaySelected(focusedDay.value, focusedDay.value, context);
      log("choseVal : $choseVal");
      String day = DateFormat('EEEE').format(focusedDay.value);

      if (timeSlotModel != null) {
        List<TimeSlots> dayWeek = timeSlotModel!.timeSlots;
        int listIndex = dayWeek.indexWhere(
          (element) => element.day.toLowerCase() == day.toLowerCase(),
        );

        if (listIndex >= 0) {
          if (dayWeek[listIndex].isActive == 1) {
            [];
          } else {
            timeSlot = [];
            notifyListeners();
          }
        } else {
          timeSlot = [];
          notifyListeners();
        }
      }
    } else {
      if (DateFormat('MMMM-yyyy').format(now) ==
          DateFormat('MMMM-yyyy').format(DateTime.now())) {
        focusedDay.value = DateTime.utc(
          focusedDay.value.year,
          index,
          focusedDay.value.day + 0,
        );
        onDaySelected(focusedDay.value, focusedDay.value, context);
        log("choseVal : $choseVal");
        String day = DateFormat('EEEE').format(focusedDay.value);
        if (timeSlotModel != null) {
          List<TimeSlots> dayWeek = timeSlotModel!.timeSlots;
          int listIndex = dayWeek.indexWhere(
            (element) => element.day.toLowerCase() == day.toLowerCase(),
          );

          if (listIndex >= 0) {
            if (dayWeek[listIndex].isActive == 1) {
            } else {
              timeSlot = [];
              notifyListeners();
            }
          } else {
            timeSlot = [];
            notifyListeners();
          }
        }
      } else {
        log("ERROR");
        isVisible = true;
        notifyListeners();
        await Future.delayed(DurationClass.s3);

        isVisible = false;
        notifyListeners();
      }
    }
  }

  onPageCtrl(dayFocused) {
    focusedDay.value = dayFocused;
    demoInt = dayFocused.year;
    log("dayFocused :: $demoInt");
    notifyListeners();
  }

  onHourScroll(index) {
    scrollHourIndex = index;
    notifyListeners();
  }

  // Updated onHourTap method
  void onHourTap(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: appColor(context).primary,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: appColor(context).whiteBg,
              hourMinuteColor: appColor(context).stroke,
              dialTextStyle: TextStyle(color: appColor(context).primary),
              dayPeriodColor: appColor(context).primary.withOpacity(.6),
              hourMinuteTextColor: appColor(context).primary,
              dayPeriodTextColor: appColor(context).primary,
              dayPeriodBorderSide: BorderSide(color: appColor(context).primary),
              dialHandColor: appColor(context).primary,
              dialTextColor: appColor(context).darkText,
              dialBackgroundColor: appColor(context).fieldCardBg,
              entryModeIconColor: appColor(context).primary,
              helpTextStyle: TextStyle(color: appColor(context).whiteBg),
              cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  appColor(context).primary,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  appColor(context).whiteBg,
                ),
              ),
              confirmButtonStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  appColor(context).primary,
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  appColor(context).whiteBg,
                ),
              ),
              hourMinuteTextStyle: const TextStyle(fontSize: 30),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      // Convert to 12-hour format
      int hour = time.hourOfPeriod;
      if (hour == 0) hour = 12; // Handle midnight/noon

      // Set scrollHourIndex
      scrollHourIndex = appArray.hourList.indexWhere(
        (element) => element == hour.toString(),
      );
      if (scrollHourIndex == -1) scrollHourIndex = 0; // Fallback

      // Set minute
      String paddedMinute = time.minute.toString().padLeft(2, '0');
      scrollMinIndex = appArray.minList.indexWhere(
        (element) => element == paddedMinute,
      );
      if (scrollMinIndex == -1) scrollMinIndex = 0; // Fallback

      // Set AM/PM
      amIndex = time.period == DayPeriod.am ? 1 : 0;
      scrollDayIndex = amIndex!;

      // Animate to selected positions
      carouselController.animateToPage(scrollHourIndex);
      carouselController1.animateToPage(scrollMinIndex);
      carouselController2.animateToPage(amIndex!);

      // Update focusedDay with selected time
      focusedDay.value = DateTime(
        focusedDay.value.year,
        focusedDay.value.month,
        focusedDay.value.day,
        time.hour, // Use 24-hour format for internal storage
        time.minute,
      );

      notifyListeners();
    }
  }

  onMinScroll(index) {
    scrollMinIndex = index;
    notifyListeners();
  }

  onDayScroll(index) {
    scrollDayIndex = index;
    amIndex = index;
    notifyListeners();
  }

  onCalendarCreate(controller) {
    log("controller : $controller");
    pageController = controller;
  }

  onLeftArrow() async {
    DateTime now = DateTime.now();
    if (DateFormat('MM-yyyy').format(focusedDay.value) !=
        DateFormat('MM-yyyy').format(now)) {
      pageController.previousPage(
        duration: const Duration(microseconds: 200),
        curve: Curves.bounceIn,
      );
      final newMonth = DateTime(
        focusedDay.value.year,
        focusedDay.value.month - 1,
        1, // First day of previous month
      );
      focusedDay.value = newMonth;
      int index = appArray.monthList.indexWhere(
        (element) => element['index'] == focusedDay.value.month,
      );
      chosenValue = appArray.monthList[index];
      selectedYear = DateTime.utc(
        focusedDay.value.year,
        focusedDay.value.month,
        focusedDay.value.day + 0,
      );
      notifyListeners();
    } else {
      isVisible = true;
      notifyListeners();
      await Future.delayed(DurationClass.s3);

      isVisible = false;
      notifyListeners();
    }
    log("FFF : $focusedDay");
  }

  onRightArrow() {
    pageController.nextPage(
      duration: const Duration(microseconds: 200),
      curve: Curves.bounceIn,
    );
    final newMonth = DateTime(
      focusedDay.value.year,
      focusedDay.value.month + 1,
      1, // First day of next month
    );
    focusedDay.value = newMonth;
    int index = appArray.monthList.indexWhere(
      (element) => element['index'] == focusedDay.value.month,
    );
    chosenValue = appArray.monthList[index];
    selectedYear = DateTime.utc(
      focusedDay.value.year,
      focusedDay.value.month,
      focusedDay.value.day + 0,
    );
    notifyListeners();
    log("hbfbfdbf::::::$newMonth");
  }

  void listen() {
    if (scrollController.position.pixels >= 200) {
      hide();
    } else {
      show();
    }
    notifyListeners();
  }

  void show() {
    if (!isBottom) {
      isBottom = true;
      notifyListeners();
    }
  }

  void hide() {
    if (isBottom) {
      isBottom = false;
      notifyListeners();
    }
  }

  void onReady(BuildContext context, {Map? argData}) {
    isStep2 = false; // Always reset to step 1

    try {
      final Map<String, dynamic>? data =
          (argData ?? ModalRoute.of(context)?.settings.arguments)
              as Map<String, dynamic>?;

      if (data == null) {
        log("Error: SlotBookingProvider.onReady received null arguments");
        // Ensure UI at least unlocks even on error
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
        return;
      }

      servicesCart = data['selectServicesCart'];
      if (servicesCart == null) {
        log("Error: servicesCart is null in onReady arguments");
        WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
        return;
      }

      // Populate core fields immediately
      servicesCart!.selectedRequiredServiceMan ??= 1;
      isPackage = data['isPackage'] ?? false;
      selectProviderIndex = data['selectProviderIndex'] ?? 0;

      // Initialize booking frequency for scheduled services
      initBookingFrequency();

      // Finish secondary initialization in the next frame to avoid build cycle conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          scrollController.addListener(listen);

          final locationCtrl = Provider.of<LocationProvider>(
            context,
            listen: false,
          );

          if (locationCtrl.addressList.isNotEmpty) {
            address = locationCtrl.addressList.firstWhere(
              (e) => e.isPrimary == 1,
              orElse: () => locationCtrl.addressList.first,
            );
          }

          if (isPackage) {
            if (servicePackageList.length > selectProviderIndex) {
              servicePackageList[selectProviderIndex].primaryAddress = address;
            }
            Provider.of<SelectServicemanProvider>(
              context,
              listen: false,
            ).notifyListeners();
          } else {
            servicesCart!.primaryAddress = address;
          }

          final dateTime = DateTime.now();
          selectedHour =
              (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour)
                  .toString()
                  .padLeft(2, '0');

          selectedMinute = dateTime.minute.toString().padLeft(2, '0');

          selectedPeriod = dateTime.hour >= 12 ? "PM" : "AM";
          selectAmPm = dateTime.hour >= 12 ? 1 : 0;
          if (appArray.monthList.isNotEmpty) {
            final index = appArray.monthList.indexWhere(
              (e) => e['index'] == dateTime.month,
            );
            chosenValue = index >= 0
                ? appArray.monthList[index]
                : appArray.monthList.first;
          }
        } catch (e, s) {
          log("Error in onReady post-frame logic: $e\n$s");
        } finally {
          notifyListeners(); // Final UI update
        }
      });
    } catch (e, s) {
      log("Error in SlotBookingProvider.onReady core: $e\n$s");
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  void onAmpmTap(int index) {
    selectAmPm = index;
    selectedPeriod = appArray.amPmList[index];
    notifyListeners();
  }

  setAddress(context) {
    if (isPackage) {
      final packageCtrl = Provider.of<SelectServicemanProvider>(
        context,
        listen: false,
      );
      servicePackageList[selectProviderIndex].primaryAddress = address;
      packageCtrl.notifyListeners();
      notifyListeners();
    }
  }

  onRemoveService(context) {
    if ((servicesCart!.selectedRequiredServiceMan!) == 1) {
      route.pop(context);
    } else {
      servicesCart!.selectedRequiredServiceMan =
          ((servicesCart!.selectedRequiredServiceMan!) - 1);
    }
    notifyListeners();
  }

  onAdd() {
    int count = (servicesCart!.selectedRequiredServiceMan!);
    count++;
    log("count::$count");
    servicesCart!.selectedRequiredServiceMan = count;

    notifyListeners();
  }

  void saveSlotDateTime() {
    if (selectedDay == null) {
      return;
    }

    slotChosenValue =
        "${selectedDay!.day.toString().padLeft(2, '0')}/"
        "${selectedDay!.month.toString().padLeft(2, '0')}/"
        "${selectedDay!.year} "
        "$selectedHour:"
        "$selectedMinute "
        "$selectedPeriod";

    debugPrint(
      "APPU_DEBUG_SLOT => "
      "$slotChosenValue",
    );

    notifyListeners();
  }

  onDateTimeSelect(context, index) {
    selectIndex = index;
    notifyListeners();
  }

  onProviderDateTimeSelect(context) async {
    log("SSS : $selectProviderIndex ");

    if (selectIndex == 0) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context3) {
          return DateTimePicker(
            isWeek: false,
            isService: isPackage,
            selectProviderIndex: selectProviderIndex,
            service: servicesCart,
          );
        },
      ).then((value) {
        log("VVVS :#$value");
        if (value != null) {
          if (value is DateTime) {
            servicesCart!.serviceDate = value;
            amIndex = value.hour >= 12 ? 0 : 1;
            scrollDayIndex = amIndex!;
          } else if (value is Map) {
            servicesCart!.serviceDate = value['date'] as DateTime?;
            servicesCart!.selectedDateTimeFormat = value['format'] as String?;
            amIndex = servicesCart!.selectedDateTimeFormat == "AM" ? 1 : 0;
            scrollDayIndex = amIndex!;
          } else if (value is Services) {
            servicesCart!.serviceDate = value.serviceDate;
            servicesCart!.selectedDateTimeFormat = value.selectedDateTimeFormat;
            amIndex = servicesCart!.selectedDateTimeFormat == "AM" ? 1 : 0;
            scrollDayIndex = amIndex ?? 1;
          }
          if (isPackage) {
            final packageCtrl = Provider.of<SelectServicemanProvider>(
              context,
              listen: false,
            );
            if (servicePackageList.isNotEmpty) {
              servicePackageList[selectProviderIndex].serviceDate =
                  servicesCart!.serviceDate;
              servicePackageList[selectProviderIndex].selectDateTimeOption =
                  selectIndex == 0 ? "custom" : "timeSlot";
              servicePackageList[selectProviderIndex].selectedDateTimeFormat =
                  servicesCart!.selectedDateTimeFormat;
            }
            notifyListeners();
            packageCtrl.notifyListeners();
          }
          // checkSlotAvailable(context: context);
        }
      });
      notifyListeners();
    } else {
      await fetchSlotTime(context);
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context3) {
          return Consumer<SlotBookingProvider>(
            builder: (context1, value, child) {
              return StatefulBuilder(
                builder: (context2, setState) {
                  return CustomDateBottomSheet();
                },
              );
            },
          );
        },
      ).then((value) {
        log("VVVS : $value");
        if (value == null) {
          focusedDay.value = DateTime.now();
          notifyListeners();
        } else {
          checkSlotAvailable(context: context);
        }
        amIndex = null;
        timeSlot = [];
        notifyListeners();
        if (isPackage) {
          final packageCtrl = Provider.of<SelectServicemanProvider>(
            context,
            listen: false,
          );
          if (servicePackageList.isNotEmpty) {
            servicePackageList[selectProviderIndex] = servicesCart!;
            servicePackageList[selectProviderIndex].serviceDate =
                servicesCart!.serviceDate;
            servicePackageList[selectProviderIndex].selectDateTimeOption =
                selectIndex == 0 ? "custom" : "timeSlot";
            servicePackageList[selectProviderIndex].selectedDateTimeFormat =
                servicesCart!.selectedDateTimeFormat;
          }
          notifyListeners();
          packageCtrl.notifyListeners();
          if (servicePackageList.isNotEmpty) {
            log(
              "packageCtrl.servicePackageList[selectProviderIndex].serviceDate :${servicePackageList[selectProviderIndex].serviceDate}",
            );
          }
        }
      });
    }
    notifyListeners();
  }

  String getWeekday(String rawDate) {
    try {
      final parsedDate = DateTime.parse(
        rawDate,
      ); // Make sure date is "yyyy-MM-dd"
      return DateFormat('E').format(parsedDate); // Output: Mon, Tue, etc.
    } catch (e) {
      return rawDate; // fallback if format fails
    }
  }

  dateTimeSelect(context, isService, {isEdit = false}) {
    log("isService: $servicesCart");
    // Removed reassignment of focusedDay.value since checkSlotAvailableForAppChoose
    // already computed the proper local 24-hour time based on AM/PM selection.

    notifyListeners();

    if (isEdit) {
      route.pop(
        context,
        arg: {
          "date": focusedDay.value,
          "time": appArray.amPmList[scrollDayIndex],
        },
      );
    } else {
      servicesCart!.serviceDate = focusedDay.value;
      servicesCart!.selectedDateTimeFormat = appArray.amPmList[scrollDayIndex];
      notifyListeners();
      if (isService) {
        final packageCtrl = Provider.of<SelectServicemanProvider>(
          context,
          listen: false,
        );
        packageCtrl.notifyListeners();
      }
      log("isService: ${servicesCart!.selectedDateTimeFormat}");
      route.pop(context, arg: isService ? servicesCart : focusedDay.value);
    }
  }

  void provideTimeSlotSelect(BuildContext context) async {
    log("timeIndex : $timeIndex");

    if (timeIndex != null) {
      final selectedDate = selectedDay ?? focusedDay.value;
      final selectedWeekday = DateFormat(
        'EEEE',
      ).format(selectedDate).toUpperCase();

      // Match the day slot
      final matchedDaySlot = timeSlotModel!.timeSlots.firstWhere(
        (e) => e.day == selectedWeekday && e.isActive == true,
        orElse: () =>
            TimeSlots(day: selectedWeekday, slots: [], isActive: false),
      );

      // Get the selected slot time
      final selectedSlot = matchedDaySlot.slots[timeIndex!];

      log("Selected slot: $selectedSlot");

      // Now parse the selected slot time
      final hour = int.parse(selectedSlot.split(":")[0]);
      final minute = int.parse(selectedSlot.split(":")[1]);

      // Construct final DateTime
      focusedDay.value = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      servicesCart!.serviceDate = focusedDay.value;
      servicesCart!.selectedDateTimeFormat = DateFormat(
        "aa",
      ).format(focusedDay.value);

      notifyListeners();

      log("DOC: $isPackage ///${servicesCart!.serviceDate}");

      if (isPackage) {
        final packageCtrl = Provider.of<SelectServicemanProvider>(
          context,
          listen: false,
        );

        servicePackageList[selectProviderIndex] = servicesCart!;
        servicePackageList[selectProviderIndex].serviceDate =
            servicesCart!.serviceDate;
        servicePackageList[selectProviderIndex].selectDateTimeOption =
            selectIndex == 0 ? "custom" : "timeSlot";
        servicePackageList[selectProviderIndex].selectedDateTimeFormat =
            servicesCart!.selectedDateTimeFormat;

        packageCtrl.notifyListeners();
        log("DOC:sss $isPackage ///${servicesCart!.serviceDate}");
      }

      route.pop(context, arg: isPackage ? servicesCart : focusedDay.value);
    } else {
      Fluttertoast.showToast(
        msg: "Please select time slot",
        backgroundColor: Colors.red,
      );
    }
  }

  String buttonName(context) {
    String name = translations?.next ?? language(context, appFonts.next);
    log("isPackage ::$isPackage");
    if (isPackage) {
      final packageCtrl = Provider.of<SelectServicemanProvider>(
        context,
        listen: false,
      );
      if (servicePackageList.length == 1) {
        name = translations?.submit ?? language(context, appFonts.submit);
        return name;
      } else {
        log("IMDD:${selectProviderIndex + 1} //$selectProviderIndex");
        if (selectProviderIndex + 1 < servicePackageList.length) {
          name = translations?.submit ?? language(context, appFonts.submit);
        } else {
          name = translations?.next ?? language(context, appFonts.next);
        }

        return name;
      }
    } else {
      return translations?.next ?? language(context, appFonts.next);
    }
  }

  onBack(context) {
    log("WOEK ");
    if (isStep2) {
      isStep2 = false;
    } else {
      isStep2 = false;
      route.pop(context);
      txtNote.text = "";
    }
    if (servicesCart != null) {
      servicesCart!.serviceDate = null;
      servicesCart!.selectDateTimeOption = null;
      if (isPackage) {
        final packageCtrl = Provider.of<SelectServicemanProvider>(
          context,
          listen: false,
        );
        servicePackageList[selectProviderIndex].serviceDate = null;
        servicePackageList[selectProviderIndex].selectDateTimeOption = null;
      }
      amIndex = null;
    }
    notifyListeners();
  }

  addToCart(context) async {
    servicesCart!.primaryAddress = address;

    // Populate schedule booking data if it's a scheduled service
    if (servicesCart?.type == 'scheduled' && selectedDateList.isNotEmpty) {
      servicesCart?.isScheduledBooking = 1;
      servicesCart?.scheduleStartDate = rangeStart;
      servicesCart?.scheduleEndDate = rangeEnd;
      servicesCart?.scheduleTime =
          "${appArray.hourList[scrollHourIndex]}:${appArray.minList[scrollMinIndex]} ${appArray.amPmList[amIndex ?? 0]}";
      servicesCart?.bookingFrequency = bookingFrequency;
      servicesCart?.scheduledDatesJson = List.from(selectedDateList);
      servicesCart?.scheduledServicesCount = selectedDateList.length;
      if (bookingFrequency == 'daily') {
        servicesCart?.selectedWeekdays = List.from(newWeekDayList);
      }
    }

    notifyListeners();
    Provider.of<CommonApiProvider>(context, listen: false).selfApi(context);
    final cartCtrl = Provider.of<CartProvider>(context, listen: false);
    log("SERVI :${servicesCart?.selectedAdditionalServices}");
    int index = cartCtrl.cartList.indexWhere(
      (element) =>
          element.isPackage == false &&
          element.serviceList != null &&
          element.serviceList?.id == servicesCart?.id,
    );
    log("ADDD :${servicesCart?.primaryAddress}");

    if (index >= 0) {
      log("message is true");
      cartCtrl.cartList[index].serviceList = servicesCart;

      cartCtrl.notifyListeners();
    } else {
      log("message is false");
      CartModel cartModel = CartModel(
        isPackage: false,
        serviceList: servicesCart,
      );
      cartCtrl.cartList.add(cartModel);
      cartCtrl.notifyListeners();
    }

    cartCtrl.notifyListeners();

    if (cartCtrl.isEditing) {
      CartModel updatedCartItem = CartModel(
        isPackage: false,
        serviceList: servicesCart,
      );
      await cartCtrl.updateCartItemApi(context, updatedCartItem);
    } else {
      cartCtrl.syncCartWithApi(context);
      cartCtrl.checkout(context);
    }
    isStep2 = false;
    selectIndex = 0;
    txtNote.text = "";
    servicesCart = null;
    final selectOption = Provider.of<SelectServicemanProvider>(
      context,
      listen: false,
    );
    final providerDetail = Provider.of<ProviderDetailsProvider>(
      context,
      listen: false,
    );
    selectOption.servicePackageModel = null;
    providerDetail.selectProviderIndex = 0;
    providerDetail.selectIndex = 0;
    focusedDay.value = DateTime.now();
    notifyListeners();

    route.pushNamed(context, routeName.cartScreen);
  }

  Step2Model? step2Data;

  Future<void> callBookingApi(
    int? serviceId,
    int? requiredServicemen,
    additionalServices,
  ) async {
    log("Query Params: $additionalServices");
    Map<String, dynamic> queryParams = {
      "service_id": serviceId,
      "required_servicemen": requiredServicemen,
      "additional_services": additionalServices,
    };

    // if (servicesCart?.type == 'scheduled' || servicesCart?.type == 'schedule') {
    //     queryParams['type'] = servicesCart?.type;
    //     queryParams['booking_frequency'] = bookingFrequency;
    //     if(rangeStart != null) queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(rangeStart!);
    //     if(rangeEnd != null) queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(rangeEnd!);

    //     String time = "${appArray.hourList[scrollHourIndex]}:${appArray.minList[scrollMinIndex]} ${appArray.amPmList[amIndex ?? 0]}";
    //     queryParams['time'] = time;
    // }

    notifyListeners();
    log("Query Params: $queryParams");
    // log("Full URL: ${Uri.parse(api.step2Booking).replace(queryParameters: queryParams)}");

    try {
      await apiServices
          .getApi(api.step2Booking, queryParams, isToken: true, isData: true)
          .then((value) {
            if (value.isSuccess!) {
              step2Data = Step2Model.fromJson(value.data);

              log("message-=-=-=-=-=-=-=-=-=-=-=-=-=258${value.data}");
            } else {
              log("message-=-=-=-=-=-=-=-=-=-=-=-=-=${value.message}");
            }

            notifyListeners();
          });
    } catch (e, s) {
      print("API Error: $e\nStackTrace: $s");
    }
  }

  void _updateCombinedSlotTime() {
    slotChosenValue = "$_selectedHour:$_selectedMinute $_selectedPeriod";

    int hour = int.parse(_selectedHour);
    int minute = int.parse(_selectedMinute);

    if (_selectedPeriod == "PM" && hour < 12) {
      hour += 12;
    } else if (_selectedPeriod == "AM" && hour == 12) {
      hour = 0;
    }

    DateTime baseDate = selectedDay ?? DateTime.now();
    DateTime updatedDateTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );

    focusedDay.value = updatedDateTime;
    if (servicesCart != null) {
      servicesCart!.serviceDate = updatedDateTime;
      servicesCart!.selectedDateTimeFormat = _selectedPeriod;
    }

    notifyListeners();
  }

  void updateHour(String newValue) {
    _selectedHour = newValue;
    _updateCombinedSlotTime();
  }

  void updateMinute(String newValue) {
    _selectedMinute = newValue;
    _updateCombinedSlotTime();
  }

  void updatePeriod(String newValue) {
    _selectedPeriod = newValue;
    _updateCombinedSlotTime();
  }
}
