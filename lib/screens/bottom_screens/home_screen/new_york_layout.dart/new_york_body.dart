import 'dart:developer';

import '../../../../config.dart';
import '../layouts/horizontal_blog_list.dart';
import '../layouts/new_job_request_layout.dart';

class NewYorkBody extends StatelessWidget {
  const NewYorkBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DashboardProvider, HomeScreenProvider, CommonApiProvider>(
      builder: (context3, dash, value, commonApi, child) {
        return StatefulWrapper(
          onInit: () {
            Future.delayed(const Duration(milliseconds: 150)).then((value) {
              /*  dash.getOffer(); */
            });
          },
          child: ListView(
            children: [
              Column(
                children: [
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.banners!.isNotEmpty)
                    BannerLayout(
                      isDubai: true,
                      bannerList: commonApi.dashboardModel!.banners,
                      onPageChanged: (index, reason) =>
                          value.onSlideBanner(index),
                      onTap: commonApi.isLoading == true
                          ? (type, id) {
                              log("object=-===-=-=-=-=-=-=-=-=");
                            }
                          : (type, id) => value.onBannerTap(context, type, id),
                    ),
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.banners!.length > 1 &&
                      dash.bannerList.any((banner) => banner.media!.isNotEmpty))
                    const VSpace(Sizes.s12),
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.banners!.length > 1 &&
                      commonApi.dashboardModel!.banners!.any(
                        (banner) => banner.media!.isNotEmpty,
                      ))
                    DotIndicator(
                      list: commonApi.dashboardModel!.banners!,
                      selectedIndex: value.selectIndex,
                    ).padding(top: Sizes.s12),
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.banners!.isNotEmpty &&
                      commonApi.dashboardModel!.banners!.any(
                        (banner) => banner.media!.isNotEmpty,
                      ))
                    const VSpace(Sizes.s20),
                ],
              ),
              Column(
                children: [
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.coupons!.isNotEmpty)
                    HeadingRowCommon(
                      title: translations!.coupons,
                      isTextSize: true,
                      onTap: () {
                        dash.getCoupons();
                        route.pushNamed(
                          context,
                          routeName.couponListScreen,
                          arg: true,
                        );
                      },
                    ).paddingSymmetric(horizontal: Insets.i20),
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.coupons!.isNotEmpty)
                    const VSpace(Sizes.s15),
                  if (commonApi.dashboardModel != null &&
                      commonApi.dashboardModel!.coupons!.isNotEmpty)
                    SizedBox(
                      height: Sizes.s70,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: commonApi.dashboardModel!.coupons?.length,
                        itemBuilder: (context, index) {
                          return HomeCouponLayout(
                            data: commonApi.dashboardModel!.coupons![index],
                          );
                        },
                      ),
                    ),
                ],
              ),
              VSpace(
                commonApi.dashboardModel != null &&
                        commonApi.dashboardModel!.coupons!.isNotEmpty
                    ? Sizes.s25
                    : Sizes.s15,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    const TextField(
                      decoration: InputDecoration(
                        hintText: "Search for 'AC service'",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Color(0xffF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          gradient: LinearGradient(
                            colors: [Color(0xff0057FF), Color(0xff0B8BFF)],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Treat her to\nultimate pampering",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Native Smart Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),

              const CategoryFeaturePackageServices(isNewYork: true),
              const VSpace(Sizes.s25),
              if (appSettingModel != null &&
                  appSettingModel!.activation!.blogsEnable == "1")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (commonApi.dashboardModel2 != null &&
                        commonApi.dashboardModel != null &&
                        commonApi.dashboardModel2!.blogs!.isNotEmpty)
                      HeadingRowCommon(
                        title: translations!.latestBlog,
                        isTextSize: true,
                        onTap: () {
                          dash.getBlog().then((value) {
                            route.pushNamed(
                              context,
                              routeName.latestBlogViewAll,
                            );
                          });
                        },
                      ).paddingSymmetric(horizontal: Insets.i20),
                    if (commonApi.dashboardModel2 != null)
                      HorizontalBlogList(
                        blogList: commonApi.dashboardModel2!.blogs,
                      ),
                    const VSpace(Sizes.s25),
                  ],
                ),
              /*if (commonApi.dashboardModel != null)
              if (appSettingModel != null &&
                  appSettingModel?.serviceRequest?.status == "1")
                const NewJobRequestLayout(),*/
              const VSpace(Sizes.s50),
            ],
          ),
        );
      },
    );
  }
}
