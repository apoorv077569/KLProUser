import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/models/help_ticket_model.dart';
import 'package:klpro_user/providers/app_pages_providers/help_support_provider.dart';

class HelpTicketListLayout extends StatelessWidget {
  final HelpTicketModel ticket;
  const HelpTicketListLayout({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Insets.i20, vertical: Insets.i8),
      decoration: BoxDecoration(
        color: appColor(context).fieldCardBg,
        borderRadius: BorderRadius.circular(AppRadius.r12),
        border: Border.all(color: appColor(context).stroke.withOpacity(0.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        onTap: () => route.pushNamed(context, routeName.helpTicketDetails, arg: ticket.id),
        child: Padding(
          padding: const EdgeInsets.all(Insets.i15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject ?? "No Subject",
                      style: appCss.dmDenseBold16.textColor(appColor(context).darkText),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const HSpace(Sizes.s8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Insets.i10, vertical: Insets.i4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppRadius.r5),
                    ),
                    child: Text(
                      (ticket.status ?? "open").toUpperCase(),
                      style: appCss.dmDenseMedium12
                          .textColor(_getStatusColor(ticket.status)),
                    ),
                  ),
                ],
              ),
              const VSpace(Sizes.s8),
              Row(children: [
                Text("Ticket ID: ",
                    style: appCss.dmDenseMedium13
                        .textColor(appColor(context).lightText)),
                Text(ticket.ticketId ?? "",
                    style: appCss.dmDenseBold13
                        .textColor(appColor(context).primary)),
              ]),
              const VSpace(Sizes.s5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (ticket.category != null && ticket.category!.isNotEmpty)
                    Text(ticket.category!,
                        style: appCss.dmDenseRegular12
                            .textColor(appColor(context).primary)),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: appCss.dmDenseRegular12
                        .textColor(appColor(context).lightText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
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

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "";
    try {
      final dt = DateTime.parse(raw);
      return "${dt.day.toString().padLeft(2, '0')} "
          "${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return raw;
    }
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }
}
