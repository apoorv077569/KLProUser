import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/providers/app_pages_providers/help_support_provider.dart';
import 'package:klpro_user/screens/app_pages_screens/help_support_screen/layouts/help_ticket_list_layout.dart';
import 'package:provider/provider.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HelpSupportProvider>(context, listen: false).getHelpTickets();
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
              language(context, translations!.helpSupport),
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
            actions: [
              IconButton(
                onPressed: () =>
                    route.pushNamed(context, routeName.raiseTicket),
                icon: Icon(Icons.add_circle_outline,
                    color: appColor(context).primary),
              ).paddingDirectional(end: Insets.i10),
            ],
          ),
          body: helpProvider.isTicketListLoading
              ? const Center(child: CircularProgressIndicator())
              : helpProvider.helpTickets.isEmpty
                  ? _buildEmptyState(context, helpProvider)
                  : RefreshIndicator(
                      onRefresh: () => helpProvider.getHelpTickets(),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: Insets.i20),
                        children: helpProvider.helpTickets
                            .map((ticket) => HelpTicketListLayout(ticket: ticket))
                            .toList(),
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildEmptyState(context, HelpSupportProvider helpProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(eImageAssets.helpSupport, height: Sizes.s200),
          const VSpace(Sizes.s20),
          Text(
            language(context, "No tickets found"),
            style: appCss.dmDenseMedium16
                .textColor(appColor(context).lightText),
          ),
          const VSpace(Sizes.s30),
          ButtonCommon(
            title: "Raise New Ticket",
            onTap: () => route.pushNamed(context, routeName.raiseTicket).then(
                (_) => helpProvider.getHelpTickets()),
          ).paddingSymmetric(horizontal: Insets.i50),
        ],
      ).paddingSymmetric(horizontal: Insets.i20),
    );
  }
}
