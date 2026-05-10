import 'dart:io';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/providers/app_pages_providers/help_support_provider.dart';
import 'package:intl/intl.dart';
import 'package:klpro_user/users_services.dart';
import 'package:provider/provider.dart';

class HelpTicketDetailsScreen extends StatefulWidget {
  const HelpTicketDetailsScreen({super.key});

  @override
  State<HelpTicketDetailsScreen> createState() =>
      _HelpTicketDetailsScreenState();
}

class _HelpTicketDetailsScreenState extends State<HelpTicketDetailsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final helpProvider =
          Provider.of<HelpSupportProvider>(context, listen: false);
      final ticketId = ModalRoute.of(context)!.settings.arguments as int;
      helpProvider.getTicketDetails(ticketId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HelpSupportProvider>(
      builder: (context, helpProvider, child) {
        final ticket = helpProvider.ticketDetail;
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 80,
            title: Text(
              language(context, "Ticket Details"),
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
          body: helpProvider.isTicketDetailLoading || ticket == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(Insets.i20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Ticket Header Card ──
                            Container(
                              padding: const EdgeInsets.all(Insets.i15),
                              decoration: BoxDecoration(
                                color: appColor(context)
                                    .primary
                                    .withOpacity(0.05),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r12),
                                border: Border.all(
                                    color: appColor(context)
                                        .primary
                                        .withOpacity(0.25)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ticket.ticketId ?? "",
                                        style: appCss.dmDenseBold16
                                            .textColor(
                                                appColor(context).primary),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Insets.i10,
                                            vertical: Insets.i4),
                                        decoration: BoxDecoration(
                                          color: _statusColor(ticket.status)
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(
                                                  AppRadius.r5),
                                        ),
                                        child: Text(
                                          (ticket.status ?? "open")
                                              .toUpperCase(),
                                          style: appCss.dmDenseMedium12
                                              .textColor(_statusColor(
                                                  ticket.status)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const VSpace(Sizes.s10),
                                  Text(
                                    ticket.subject ?? "",
                                    style: appCss.dmDenseBold18.textColor(
                                        appColor(context).darkText),
                                  ),
                                  const VSpace(Sizes.s8),
                                  Text(
                                    ticket.description ?? "",
                                    style: appCss.dmDenseRegular14
                                        .textColor(
                                            appColor(context).darkText),
                                  ),
                                  const VSpace(Sizes.s12),
                                  Divider(color: appColor(context).stroke),
                                  const VSpace(Sizes.s8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _infoChip(context, "Category",
                                          ticket.category ?? "-"),
                                      _infoChip(context, "Priority",
                                          ticket.priority ?? "-",
                                          isAccent: true),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const VSpace(Sizes.s20),

                            Text(
                              language(context, "Conversation"),
                              style: appCss.dmDenseBold16
                                  .textColor(appColor(context).darkText),
                            ),
                            const VSpace(Sizes.s15),

                            // ── Replies ──
                            ticket.replies == null || ticket.replies!.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Insets.i20),
                                    child: Center(
                                      child: Text(
                                        language(
                                            context, "No replies yet"),
                                        style: appCss.dmDenseRegular14
                                            .textColor(appColor(context)
                                                .lightText),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: ticket.replies!.length,
                                    itemBuilder: (context, index) {
                                      final reply =
                                          ticket.replies![index];
                                      final bool isMe =
                                          reply.userId == userModel?.id;
                                      return _buildReplyBubble(
                                          context, reply, isMe);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),

                    // ── Reply Input Bar ──
                    Container(
                      padding: EdgeInsets.only(
                        left: Insets.i15,
                        right: Insets.i10,
                        top: Insets.i10,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Insets.i10,
                      ),
                      decoration: BoxDecoration(
                        color: appColor(context).fieldCardBg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: helpProvider.replyCtrl,
                              textInputAction: TextInputAction.newline,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText:
                                    language(context, "Type your reply..."),
                                border: InputBorder.none,
                                hintStyle: appCss.dmDenseRegular14.textColor(
                                    appColor(context).lightText),
                              ),
                            ),
                          ),
                          helpProvider.isReplyLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(Insets.i12),
                                  child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2)),
                                )
                              : IconButton(
                                  onPressed: () => helpProvider.replyToTicket(
                                      context, ticket.id!),
                                  icon: Icon(Icons.send_rounded,
                                      color: appColor(context).primary),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildReplyBubble(context, reply, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.i15),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.i15, vertical: Insets.i12),
            decoration: BoxDecoration(
              color: isMe
                  ? appColor(context).primary
                  : appColor(context).fieldCardBg,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppRadius.r15),
                topRight: const Radius.circular(AppRadius.r15),
                bottomLeft:
                    Radius.circular(isMe ? AppRadius.r15 : 0),
                bottomRight:
                    Radius.circular(isMe ? 0 : AppRadius.r15),
              ),
              border: isMe
                  ? null
                  : Border.all(
                      color: appColor(context).stroke.withOpacity(0.5)),
            ),
            child: Text(
              reply.message ?? "",
              style: appCss.dmDenseRegular14.textColor(
                  isMe ? Colors.white : appColor(context).darkText),
            ),
          ),
          const VSpace(Sizes.s4),
          Text(
            _formatDateTime(reply.createdAt),
            style: appCss.dmDenseRegular11
                .textColor(appColor(context).lightText),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(context, String label, String value,
      {bool isAccent = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: appCss.dmDenseRegular12
                .textColor(appColor(context).lightText)),
        const VSpace(Sizes.s2),
        Text(value.toUpperCase(),
            style: appCss.dmDenseMedium13.textColor(isAccent
                ? _priorityColor(value)
                : appColor(context).darkText)),
      ],
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }
}
