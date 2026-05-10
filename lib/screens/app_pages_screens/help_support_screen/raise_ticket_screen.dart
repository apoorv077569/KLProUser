import 'dart:io';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/providers/app_pages_providers/help_support_provider.dart';
import 'package:provider/provider.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  @override
  void dispose() {
    _subjectFocus.dispose();
    _categoryFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<HelpSupportProvider>(context, listen: false);
      provider.clearForm();
      provider.getBookings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, helpProvider, child) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 80,
            title: Text(
              language(context, "Raise Ticket"),
              style: appCss.dmDenseBold18
                  .textColor(appColor(context).darkText),
            ),
            centerTitle: true,
            backgroundColor: appColor(context).fieldCardBg,
            leading: CommonArrow(
              arrow: rtl(context) ? eSvgAssets.arrowRight : eSvgAssets.arrowLeft,
              color: appColor(context).whiteBg,
              onTap: () => route.pop(context),
            ).paddingDirectional(vertical: Insets.i8),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.i20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject
                TextFieldCommon(
                  controller: helpProvider.subjectCtrl,
                  hintText: "Subject *",
                  focusNode: _subjectFocus,
                  prefixIcon: eSvgAssets.edit,
                ),
                const VSpace(Sizes.s15),

                // Category
                TextFieldCommon(
                  controller: helpProvider.categoryCtrl,
                  hintText: "Category (e.g. Technical, Billing)",
                  focusNode: _categoryFocus,
                  prefixIcon: eSvgAssets.categorySmall,
                ),
                const VSpace(Sizes.s15),

                // Priority Dropdown
                Text("Priority",
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).lightText)),
                const VSpace(Sizes.s8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Insets.i15),
                  decoration: BoxDecoration(
                    color: appColor(context).whiteBg,
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    border:
                        Border.all(color: appColor(context).stroke),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: helpProvider.selectedPriority,
                      isExpanded: true,
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).darkText),
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: appColor(context).lightText),
                      items: ["low", "medium", "high"]
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (val) => helpProvider.setPriority(val),
                    ),
                  ),
                ),
                const VSpace(Sizes.s15),

                // Related Booking Dropdown (optional)
                Text("Related Booking (Optional)",
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).lightText)),
                const VSpace(Sizes.s8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Insets.i15),
                  decoration: BoxDecoration(
                    color: appColor(context).whiteBg,
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    border:
                        Border.all(color: appColor(context).stroke),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: helpProvider.isBookingLoading
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: Insets.i12),
                            child: Row(children: [
                              const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const HSpace(Sizes.s10),
                              Text("Loading bookings...",
                                  style: appCss.dmDenseRegular14.textColor(
                                      appColor(context).lightText)),
                            ]),
                          )
                        : DropdownButton<BookingModel>(
                            value: helpProvider.selectedBooking,
                            hint: Text(
                              "Select a booking",
                              style: appCss.dmDenseRegular14
                                  .textColor(appColor(context).lightText),
                            ),
                            isExpanded: true,
                            style: appCss.dmDenseMedium14
                                .textColor(appColor(context).darkText),
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: appColor(context).lightText),
                            items: helpProvider.bookings
                                .map((BookingModel booking) =>
                                    DropdownMenuItem<BookingModel>(
                                      value: booking,
                                      child: Text(
                                        "#${booking.bookingNumber ?? booking.id} - ${booking.service?.title ?? 'Service'}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                helpProvider.onBookingChange(val),
                          ),
                  ),
                ),
                const VSpace(Sizes.s15),

                // Description
                TextFieldCommon(
                  controller: helpProvider.descriptionCtrl,
                  hintText: "Description *",
                  focusNode: _descriptionFocus,
                  maxLines: 5,
                  minLines: 3,
                  prefixIcon: eSvgAssets.chat,
                ),
                const VSpace(Sizes.s15),

                // Attachments
                /* if (helpProvider.attachments.isNotEmpty) ...[
                  Text("Attachments",
                      style: appCss.dmDenseMedium14
                          .textColor(appColor(context).lightText)),
                  const VSpace(Sizes.s8),
                  SizedBox(
                    height: Sizes.s80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: helpProvider.attachments.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: Insets.i8),
                              width: Sizes.s80,
                              height: Sizes.s80,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r8),
                                image: DecorationImage(
                                  image: FileImage(File(
                                      helpProvider.attachments[index].path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 2,
                              right: 10,
                              child: GestureDetector(
                                onTap: () =>
                                    helpProvider.removeAttachment(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const VSpace(Sizes.s10),
                ],

                // Add Attachment Button
                GestureDetector(
                  onTap: () => helpProvider.onImagePick(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Insets.i15, vertical: Insets.i12),
                    decoration: BoxDecoration(
                      color: appColor(context).fieldCardBg,
                      borderRadius: BorderRadius.circular(AppRadius.r8),
                      border: Border.all(
                          color: appColor(context).primary.withOpacity(0.4),
                          style: BorderStyle.solid),
                    ),
                    child: Row(children: [
                      Icon(Icons.attach_file,
                          color: appColor(context).primary, size: 20),
                      const HSpace(Sizes.s8),
                      Text("Add Attachment (Optional)",
                          style: appCss.dmDenseRegular14
                              .textColor(appColor(context).primary)),
                    ]),
                  ),
                ), */

                const VSpace(Sizes.s30),
                ButtonCommon(
                  title: "Submit Ticket",
                  onTap: () => helpProvider.createTicket(context),
                  isLoading: helpProvider.isCreateTicketLoading,
                ),
                const VSpace(Sizes.s20),
              ],
            ),
          ),
        );
      },
    );
  }
}
