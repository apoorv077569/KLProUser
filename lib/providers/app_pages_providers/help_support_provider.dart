import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/widgets/alert_message_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../models/help_ticket_model.dart';
import '../../screens/app_pages_screens/profile_detail_screen/layouts/selection_option_layout.dart';

class HelpSupportProvider with ChangeNotifier {
  List<HelpTicketModel> helpTickets = [];
  HelpTicketModel? ticketDetail;
  bool isTicketListLoading = false;
  bool isTicketDetailLoading = false;
  bool isCreateTicketLoading = false;
  bool isReplyLoading = false;

  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController categoryCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  String selectedPriority = "high";
  List<XFile> attachments = [];

  // Booking List for Dropdown
  List<BookingModel> bookings = [];
  BookingModel? selectedBooking;
  bool isBookingLoading = false;

  TextEditingController replyCtrl = TextEditingController();
  List<XFile> replyAttachments = [];

  final ImagePicker _picker = ImagePicker();

  void clearForm() {
    subjectCtrl.clear();
    categoryCtrl.clear();
    descriptionCtrl.clear();
    selectedPriority = "high";
    selectedBooking = null;
    attachments.clear();
    notifyListeners();
  }

  void clearReplyForm() {
    replyCtrl.clear();
    replyAttachments.clear();
    notifyListeners();
  }

  void setPriority(String? value) {
    if (value != null) {
      selectedPriority = value;
      notifyListeners();
    }
  }

  void onBookingChange(BookingModel? val) {
    selectedBooking = val;
    notifyListeners();
  }

  Future<void> onImagePick(context, {bool isReply = false}) async {
    showLayout(context, onTap: (index) async {
      final XFile? file = await _picker.pickImage(
        source: index == 0 ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 70,
      );
      if (file != null) {
        if (isReply) {
          replyAttachments.add(file);
        } else {
          attachments.add(file);
        }
        notifyListeners();
      }
      route.pop(context);
    });
  }

  void removeAttachment(int index, {bool isReply = false}) {
    if (isReply) {
      replyAttachments.removeAt(index);
    } else {
      attachments.removeAt(index);
    }
    notifyListeners();
  }

  Future<void> getHelpTickets() async {
    isTicketListLoading = true;
    notifyListeners();
    try {
      final response =
          await apiServices.getApi(api.helpTicket, [], isToken: true);
      if (response.isSuccess!) {
        helpTickets = (response.data as List)
            .map((e) => HelpTicketModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log("Error fetching help tickets: $e");
    } finally {
      isTicketListLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTicketDetails(int id) async {
    isTicketDetailLoading = true;
    ticketDetail = null;
    notifyListeners();
    try {
      final response = await apiServices
          .getApi("${api.helpTicket}/$id", [], isToken: true, isData: true);
      if (response.isSuccess!) {
        ticketDetail = HelpTicketModel.fromJson(response.data);
      }
    } catch (e) {
      log("Error fetching ticket details: $e");
    } finally {
      isTicketDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBookings() async {
    isBookingLoading = true;
    notifyListeners();
    try {
      final response =
          await apiServices.getApi(api.booking, {}, isToken: true);
      if (response.isSuccess!) {
        bookings = (response.data as List)
            .map((e) => BookingModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      log("Error fetching bookings: $e");
    } finally {
      isBookingLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTicket(context) async {
    if (subjectCtrl.text.isEmpty || descriptionCtrl.text.isEmpty) {
      snackBarMessengers(context, message: "Please fill required fields");
      return;
    }
    isCreateTicketLoading = true;
    notifyListeners();
    try {
      dio.FormData formData = dio.FormData.fromMap({
        'subject': subjectCtrl.text,
        'category': categoryCtrl.text,
        'priority': selectedPriority,
        'description': descriptionCtrl.text,
        if (selectedBooking?.id != null) 'booking_id': selectedBooking!.id,
      });
      for (var file in attachments) {
        formData.files.add(MapEntry(
            'attachments[]',
            await dio.MultipartFile.fromFile(file.path,
                filename: file.name)));
      }
      final response = await apiServices
          .postApi(api.helpTicket, formData, isToken: true, isData: true);
      if (response.isSuccess!) {
        snackBarMessengers(context,
            message: response.message,
            color: appColor(context).primary);
        clearForm();
        await getHelpTickets();
        route.pop(context);
      } else {
        snackBarMessengers(context, message: response.message);
      }
    } catch (e) {
      log("Error creating ticket: $e");
      snackBarMessengers(context, message: "Something went wrong");
    } finally {
      isCreateTicketLoading = false;
      notifyListeners();
    }
  }

  Future<void> replyToTicket(context, int ticketId) async {
    if (replyCtrl.text.isEmpty && replyAttachments.isEmpty) return;
    isReplyLoading = true;
    notifyListeners();
    try {
      dio.FormData formData =
          dio.FormData.fromMap({'message': replyCtrl.text});
      for (var file in replyAttachments) {
        formData.files.add(MapEntry(
            'attachments[]',
            await dio.MultipartFile.fromFile(file.path,
                filename: file.name)));
      }
      final response = await apiServices.postApi(
          "${api.helpTicket}/$ticketId/reply", formData,
          isToken: true, isData: true);
      if (response.isSuccess!) {
        clearReplyForm();
        await getTicketDetails(ticketId);
      } else {
        snackBarMessengers(context, message: response.message);
      }
    } catch (e) {
      log("Error replying to ticket: $e");
      snackBarMessengers(context, message: "Something went wrong");
    } finally {
      isReplyLoading = false;
      notifyListeners();
    }
  }

  // Image picker bottom sheet — same pattern as AddJobRequestProvider
  showLayout(context, {Function(int)? onTap}) async {
    showDialog(
      context: context,
      builder: (context1) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.r12))),
          content: Consumer<LanguageProvider>(builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language(context, translations!.selectOne),
                          style: appCss.dmDenseBold18
                              .textColor(appColor(context).darkText)),
                      const Icon(CupertinoIcons.multiply)
                          .inkWell(onTap: () => route.pop(context))
                    ]),
                const VSpace(Sizes.s20),
                ...appArray.selectList
                    .asMap()
                    .entries
                    .map((e) => SelectOptionLayout(
                          data: e.value,
                          index: e.key,
                          list: appArray.selectList,
                          onTap: () => onTap!(e.key),
                        ))
              ],
            );
          }),
        );
      },
    );
  }
}
