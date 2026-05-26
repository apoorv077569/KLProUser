//app file
import 'package:klpro_user/screens/app_pages_screens/accepted_booking_screen/accepted_booking_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/add_new_location/add_new_location.dart';
import 'package:klpro_user/screens/app_pages_screens/app_details_screen/app_details_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/cancelled_booking_Screen/cancelled_booking_Screen.dart';
import 'package:klpro_user/screens/app_pages_screens/categories_list_screen/categories_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/category_detail_screen/category_detail_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/change_language_screen/change_language_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/chat_history_screen/chat_history_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/chat_screen/chat_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/chat_with_staff_screen/chat_with_staff_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/completed_service_screen/completed_service_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/contact_us_screen/contact_us_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/coupon_list_screen/coupon_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/current_location_screen/current_location_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/custom_job_request/add_job_request/add_job_request.dart';
import 'package:klpro_user/screens/app_pages_screens/custom_job_request/job_request_details/job_request_details.dart';
import 'package:klpro_user/screens/app_pages_screens/custom_job_request/job_request_list/job_request_list.dart';
import 'package:klpro_user/screens/app_pages_screens/edit_review_screen/edit_review_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/expert_service_screen/expert_service_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/favourite_list_screen/favourite_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/featured_service_screen/featured_service_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/help_support_screen/help_support_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/latest_blog_details/latest_blog_details.dart';
import 'package:klpro_user/screens/app_pages_screens/latest_blog_view_all/latest_blog_view_all.dart';
import 'package:klpro_user/screens/app_pages_screens/live_tracking_screen/live_tracking_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/location_screen/location_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/maintenance_mode.dart';
import 'package:klpro_user/screens/app_pages_screens/maintenance_screen/maintenance_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/my_location_screen/my_location_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/notification_screen/notification_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/ongoing_booking_screen/ongoing_booking_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/package_details_screen/package_details_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/payment_screen/payment_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/payment_web_view.dart';
import 'package:klpro_user/screens/app_pages_screens/pending_booking_screen/pending_booking_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/profile_detail_screen/profile_detail_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/provider_details_screen/provider_details_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/rate_app/rate_app.dart';
import 'package:klpro_user/screens/app_pages_screens/referral_screen/referral_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/referral_screen/referral_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/review_screen/review_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/search_screen/search_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/select_serviceman_screen/select_serviceman_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/service_packages_screen/service_packages_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/service_review_screen/service_review_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/service_select_user_screen/service_select_user_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/serviceman_detail_screen/serviceman_detail_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/serviceman_list_screen/serviceman_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/services_details_screen/services_details_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/slot_booking_screen/slot_booking_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/support_ticket_screen/support_ticket_list_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/user_zone_serviceman_screen/user_zone_serviceman_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/user_zone_serviceman_screen/user_zone_serviceman_detail_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/help_support_screen/raise_ticket_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/help_support_screen/help_ticket_details_screen.dart';
import 'package:klpro_user/screens/app_pages_screens/wallet_balance_screen/wallet_balance_screen.dart';
import 'package:klpro_user/screens/app_setting_screen/app_setting_screen.dart';
import 'package:klpro_user/screens/auth_screens/change_password_screen/change_password_screen.dart';
import 'package:klpro_user/screens/auth_screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:klpro_user/screens/auth_screens/login_screen/login_screen.dart';
import 'package:klpro_user/screens/auth_screens/login_with_phone_screen/login_with_phone_screen.dart';
import 'package:klpro_user/screens/auth_screens/on_boarding_screen/on_boarding_screen.dart';
import 'package:klpro_user/screens/auth_screens/register_screen/register_screen.dart';
import 'package:klpro_user/screens/auth_screens/reset_password_screen/reset_password_screen.dart';
import 'package:klpro_user/screens/auth_screens/splash_screen/splash_screen.dart';
import 'package:klpro_user/screens/auth_screens/verify_otp_screen/verify_otp_screen.dart';
import 'package:klpro_user/screens/bottom_screens/booking_screen/booking_screen.dart';
import 'package:klpro_user/screens/bottom_screens/cart_screen/cart_screen.dart';
import 'package:klpro_user/screens/bottom_screens/dashboard/dashboard.dart';
import 'package:klpro_user/screens/no_internet_screen.dart';
import '../config.dart';
import '../screens/app_pages_screens/provider_chat_screen/provider_chat_screen.dart';

class AppRoute {
  Map<String, Widget Function(BuildContext)> route = {
    routeName.splash: (p0) => const SplashScreen(),
    routeName.onBoarding: (p0) => const OnBoardingScreen(),
    routeName.login: (p0) => const LoginScreen(),
    routeName.loginWithPhone: (p0) => const LoginWithPhoneScreen(),
    routeName.verifyOtp: (p0) => const VerifyOtpScreen(),
    routeName.forgetPassword: (p0) => const ForgotPasswordScreen(),
    routeName.resetPass: (p0) => const ResetPasswordScreen(),
    routeName.registerUser: (p0) => const RegisterScreen(),
    routeName.dashboard: (p0) => const Dashboard(),
    routeName.changePass: (p0) => const ChangePasswordScreen(),
    routeName.appSetting: (p0) => const AppSettingScreen(),
    routeName.changeLanguage: (p0) => const ChangeLanguageScreen(),
    routeName.profileDetail: (p0) => const ProfileDetailScreen(),
    routeName.walletBalance: (p0) => const WalletBalanceScreen(),
    routeName.favoriteList: (p0) => const FavouriteListScreen(),
    routeName.myLocation: (p0) => const MyLocationScreen(),
    routeName.review: (p0) => const ReviewScreen(),
    routeName.editReview: (p0) => const EditReviewScreen(),
    routeName.appDetails: (p0) => const AppDetailsScreen(),
    routeName.rateApp: (p0) => const RateAppScreen(),
    routeName.contactUs: (p0) => const ContactUsScreen(),
    routeName.helpSupport: (p0) => const HelpSupportScreen(),
    routeName.notifications: (p0) => const NotificationScreen(),
    routeName.location: (p0) => const LocationScreen(),
    // routeName.currentLocation: (p0) => const CurrentLocationScreen(),
    routeName.addNewLocation: (p0) => const AddNewLocation(),
    routeName.search: (p0) => const SearchScreen(),
    routeName.latestBlogViewAll: (p0) => const LatestBlogViewAll(),
    routeName.latestBlogDetails: (p0) => const LatestBlogDetailsScreen(),
    routeName.noInternet: (p0) => const NoInternetScreen(),
    routeName.bookingList: (p0) => const BookingScreen(),
    routeName.categoriesListScreen: (p0) => const CategoriesListScreen(),
    routeName.categoriesDetailsScreen: (p0) => const CategoryDetailScreen(),
    routeName.servicesDetailsScreen: (p0) => const ServicesDetailsScreen(),
    routeName.servicesReviewScreen: (p0) => const ServiceReviewScreen(),
    routeName.providerDetailsScreen: (p0) => const ProviderDetailsScreen(),
    routeName.slotBookingScreen: (p0) => const SlotBookingScreen(),
    routeName.cartScreen: (p0) => const CartScreen(),
    routeName.couponListScreen: (p0) => const CouponListScreen(),
    routeName.paymentScreen: (p0) => const PaymentScreen(),
    routeName.serviceSelectedUserScreen: (p0) =>
        const ServiceSelectedUserScreen(),
    routeName.servicemanListScreen: (p0) => const ServicemanListScreen(),
    routeName.servicemanDetailScreen: (p0) => const ServicemanDetailScreen(),
    routeName.featuredServiceScreen: (p0) => const FeaturedServiceScreen(),
    routeName.expertServiceScreen: (p0) => const ExpertServiceScreen(),
    routeName.servicePackagesScreen: (p0) => const ServicePackagesScreen(),
    routeName.packageDetailsScreen: (p0) => const PackageDetailsScreen(),
    routeName.selectServiceScreen: (p0) => const SelectServiceScreen(),
    routeName.pendingBookingScreen: (p0) => const PendingBookingScreen(),
    routeName.acceptedBookingScreen: (p0) => const AcceptedBookingScreen(),
    routeName.chatScreen: (p0) => const ChatScreen(),
    routeName.ongoingBookingScreen: (p0) => const OngoingBookingScreen(),
    routeName.completedServiceScreen: (p0) => const CompletedServiceScreen(),
    routeName.cancelledServiceScreen: (p0) => const CancelledBookingScreen(),
    routeName.checkoutWebView: (p0) => const CheckoutWebView(),
    routeName.chatHistory: (p0) => const ChatHistoryScreen(),
    routeName.jobRequestList: (p0) => const JobRequestList(),
    routeName.jobRequestDetail: (p0) => const JobRequestDetails(),
    routeName.addJobRequestList: (p0) => const AddJobRequest(),
    routeName.maintenanceMode: (p0) => const MaintenanceMode(),
    // routeName.audioCall  : (p0) => const AudioCall(),
    // routeName.videoCall  : (p0) => const VideoCall(),
    routeName.providerChatScreen: (p0) => const ProviderChatScreen(),
    routeName.referralScreen: (p0) => const ReferralScreen(),
    routeName.referralList: (p0) => const ReferralListScreen(),
    routeName.maintenance: (p0) => const MaintenanceScreen(),
    routeName.supportTicketListScreen: (p0) => const SupportTicketListScreen(),
    routeName.chatWithStaffScreen: (p0) => const ChatWithStaffScreen(),
    routeName.userZoneServiceman: (p0) => const UserZoneServicemanScreen(),
    routeName.userZoneServicemanDetail: (p0) => const UserZoneServicemanDetailScreen(),
    routeName.liveTracking: (p0) => const LiveTrackingScreen(),
    routeName.raiseTicket: (p0) => const RaiseTicketScreen(),
    routeName.helpTicketDetails: (p0) => const HelpTicketDetailsScreen(),
  };
}
