import 'package:klpro_user/models/media_model.dart';
import 'package:klpro_user/models/user_model.dart';

import '../config.dart';

class HelpTicketModel {
  int? id;
  String? ticketId;
  int? userId;
  int? bookingId;
  String? subject;
  String? category;
  String? priority;
  String? description;
  String? status;
  String? createdAt;
  BookingModel? booking;
  List<TicketReplyModel>? replies;

  HelpTicketModel({
    this.id,
    this.ticketId,
    this.userId,
    this.bookingId,
    this.subject,
    this.category,
    this.priority,
    this.description,
    this.status,
    this.createdAt,
    this.booking,
    this.replies,
  });

  HelpTicketModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    userId = json['user_id'];
    bookingId = json['booking_id'];
    subject = json['subject'];
    category = json['category'];
    priority = json['priority'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    booking =
        json['booking'] != null ? BookingModel.fromJson(json['booking']) : null;
    if (json['replies'] != null) {
      replies = <TicketReplyModel>[];
      json['replies'].forEach((v) {
        replies!.add(TicketReplyModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticketId;
    data['user_id'] = userId;
    data['booking_id'] = bookingId;
    data['subject'] = subject;
    data['category'] = category;
    data['priority'] = priority;
    data['description'] = description;
    data['status'] = status;
    data['created_at'] = createdAt;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TicketReplyModel {
  int? id;
  int? ticketId;
  int? userId;
  String? message;
  List<Media>? attachments;
  String? createdAt;
  UserModel? user;

  TicketReplyModel({
    this.id,
    this.ticketId,
    this.userId,
    this.message,
    this.attachments,
    this.createdAt,
    this.user,
  });

  TicketReplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    userId = json['user_id'];
    message = json['message'];
    if (json['attachments'] != null) {
      attachments = <Media>[];
      json['attachments'].forEach((v) {
        attachments!.add(Media.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ticket_id'] = ticketId;
    data['user_id'] = userId;
    data['message'] = message;
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
