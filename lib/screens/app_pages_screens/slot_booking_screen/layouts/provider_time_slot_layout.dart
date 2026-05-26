import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class TimeSlotLayout extends StatelessWidget {
  final String? title;

  final String? dateTime;

  final GestureTapCallback? onTap;

  const TimeSlotLayout({super.key, this.title, this.dateTime, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<SlotBookingProvider>(
      builder: (context, value, child) {
        List<String> slots = [
          "00:00",
          "01:00",
          "02:00",
          "03:00",
          "04:00",
          "05:00",
          "06:00",
          "07:00",
          "08:00",
          "09:00",
          "10:00",
          "11:00",
          "12:00",
          "13:00",
          "14:00",
          "15:00",
          "16:00",
          "17:00",
          "18:00",
          "19:00",
          "20:00",
          "21:00",
          "22:00",
          "23:00",
        ];

        return Container(
          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      dateTime != null ? dateTime! : "Select Date & Time",

                      overflow: TextOverflow.ellipsis,

                      style: appCss.dmDenseMedium14.textColor(
                        dateTime != null
                            ? appColor(context).darkText
                            : appColor(context).lightText,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// DATE TEXT
                Text(
                  value.selectedDay == null
                      ? DateFormat("dd MMM yyyy").format(DateTime.now())
                      : DateFormat("dd MMM yyyy").format(value.selectedDay!),

                  style: TextStyle(
                    fontSize: 22,

                    color: appColor(context).primary,

                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 25),

                /// DATE LIST
                SizedBox(
                  height: 90,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: 7,

                    itemBuilder: (context, index) {
                      final date = DateTime.now().add(Duration(days: index));

                      final isSelected =
                          value.selectedDay != null &&
                          value.selectedDay!.day == date.day;

                      return InkWell(
                        onTap: () {
                          value.selectedDay = date;

                          value.notifyListeners();
                        },

                        child: Container(
                          width: 80,

                          margin: const EdgeInsets.only(right: 12),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? appColor(context).primary
                                : Colors.white,

                            borderRadius: BorderRadius.circular(18),

                            border: Border.all(
                              color: isSelected
                                  ? appColor(context).primary
                                  : Colors.grey.shade300,
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                DateFormat('E').format(date),

                                style: TextStyle(
                                  fontSize: 16,

                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                DateFormat('dd').format(date),

                                style: TextStyle(
                                  fontSize: 26,

                                  fontWeight: FontWeight.bold,

                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                /// TIME TITLE
                const Text(
                  "Time",

                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// TIME GRID
                Container(
                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: const Color(0xffF7F7FF),

                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: GridView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: slots.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,

                          crossAxisSpacing: 14,

                          mainAxisSpacing: 14,

                          childAspectRatio: 2.2,
                        ),

                    itemBuilder: (context, index) {
                      final slot = slots[index];

                      final isSelected = value.slotChosenValue == slot;

                      return InkWell(
                        onTap: () {
                          value.slotChosenValue = slot;

                          value.notifyListeners();
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appColor(context).primary
                                : const Color(0xffEDEDFD),

                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: Center(
                            child: Text(
                              slot,

                              style: TextStyle(
                                fontSize: 22,

                                fontWeight: FontWeight.w600,

                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 35),

                /// BUTTON
                SizedBox(
                  width: double.infinity,

                  height: 60,

                  child: ElevatedButton(
                    onPressed: () {
                      value.saveSlotDateTime();

                      Navigator.pop(context);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor(context).primary,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Add Date & Time",

                      style: TextStyle(
                        fontSize: 22,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
