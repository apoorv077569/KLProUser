import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/common_shimmer/service_shimmer.dart';
import 'package:klpro_user/screens/bottom_screens/home_screen/layouts/featured_service_layout.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

import '../../../config.dart';

class FeaturedServiceScreen extends StatefulWidget {
  const FeaturedServiceScreen({super.key});

  @override
  State<FeaturedServiceScreen> createState() => _FeaturedServiceScreenState();
}

class _FeaturedServiceScreenState extends State<FeaturedServiceScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final dash = Provider.of<DashboardProvider>(context, listen: true);
    return Consumer<FeaturedServiceProvider>(builder: (context1, value, child) {
      return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            value.onBack(context, false);
            if (didPop) return;
          },
          child: StatefulWrapper(
              onInit: () => Future.delayed(DurationClass.ms50)
                  .then((_) => value.onReady(context, this)),
              child: Scaffold(
                  appBar: AppBarCommon(
                      title: translations!.featuredService,
                      onTap: () => value.onBack(context, true)),
                  body:
                      Consumer<CartProvider>(builder: (context2, cart, child) {
                    return RefreshIndicator(
                        onRefresh: () async {
                          value.pagingController.refresh();
                        },
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  SearchTextFieldCommon(
                                          focusNode: value.searchFocus,
                                          controller: value.txtFeaturedSearch,
                                          suffixIcon: value.txtFeaturedSearch.text.isNotEmpty
                                              ? Icon(
                                                  Icons.cancel,
                                                  color: appColor(context).darkText,
                                                ).inkWell(onTap: () {
                                                  value.txtFeaturedSearch.text = "";
                                                  value.getFeaturedPackage();
                                                  value.notifyListeners();
                                                })
                                              : null,
                                          onChanged: (v) {
                                            if (v.isEmpty || v.length > 3) {
                                              value.getFeaturedPackage();
                                            }
                                            value.notifyListeners();
                                          },
                                          onFieldSubmitted: (v) => value.getFeaturedPackage())
                                      .paddingSymmetric(horizontal: Insets.i20),
                                  const VSpace(Sizes.s20),
                                ],
                              ),
                            ),
                            PagedSliverList<int, Services>(
                              pagingController: value.pagingController,
                              builderDelegate: PagedChildBuilderDelegate<Services>(
                                itemBuilder: (context, item, index) => FeaturedServicesLayout(
                                    data: item,
                                    addTap: () async {
                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                      if (pref.getBool(session.isContinueAsGuest) == true) {
                                        route.pushNamedAndRemoveUntil(context, routeName.login);
                                      } else {
                                        value.onFeatured(context, item, index,
                                            inCart: isInCart(context, item.id));
                                      }
                                    },
                                    onTap: () {
                                      Provider.of<ServicesDetailsProvider>(context, listen: false)
                                          .getServiceById(context, item.id);
                                      route.pushNamed(context, routeName.servicesDetailsScreen,
                                          arg: {'serviceId': item.id});
                                    }).paddingSymmetric(horizontal: Insets.i20),
                                firstPageProgressIndicatorBuilder: (_) => const ServicesShimmer(count: 5),
                                newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
                                noItemsFoundIndicatorBuilder: (_) => EmptyLayout(
                                  isButtonShow: false,
                                  title: translations!.noDataFound,
                                  subtitle: translations!.noDataFound,
                                  widget: SizedBox(
                                    height: Sizes.s230,
                                    width: double.infinity,
                                    child: Image.asset(
                                      eImageAssets.noList,
                                      height: Sizes.s230,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(child: VSpace(Sizes.s50)),
                          ],
                        ));
                  }))));
    });
  }
}


