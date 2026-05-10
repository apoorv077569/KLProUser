import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common_shimmer/service_shimmer.dart';
import 'package:klpro_user/config.dart';
import 'package:provider/provider.dart';
import './layouts/user_zone_serviceman_layout.dart';

class UserZoneServicemanScreen extends StatefulWidget {
  const UserZoneServicemanScreen({super.key});

  @override
  State<UserZoneServicemanScreen> createState() => _UserZoneServicemanScreenState();
}

class _UserZoneServicemanScreenState extends State<UserZoneServicemanScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserZoneServicemanProvider>(context, listen: false);
      provider.getUserZoneServicemen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserZoneServicemanProvider>(builder: (context, provider, child) {
      return LoadingComponent(
        child: Scaffold(
          appBar: AppBarCommon(title: language(context, "Provider in Your Area")),
          body: provider.isLoading
              ? const ServicesShimmer(count: 5)
              : provider.userZoneServicemanList.isEmpty
                    ? EmptyLayout(
                        widget: SvgPicture.asset(eSvgAssets.location),
                        title: language(context, "No Servicemen Found"),
                        subtitle: language(context, "There are no servicemen in your current zone."),
                        isButtonShow: false,
                      )
                  : ListView.builder(
                      itemCount: provider.userZoneServicemanList.length,
                      padding: EdgeInsets.all(Insets.i15),
                      itemBuilder: (context, index) {
                        return UserZoneServicemanLayout(
                          data: provider.userZoneServicemanList[index],
                          onTap: () => route.pushNamed(
                            context,
                            routeName.userZoneServicemanDetail,
                            arg: provider.userZoneServicemanList[index].id,
                          ),
                        );
                      },
                    ),
        ),
      );
    });
  }
}
