
import 'package:klpro_user/common_tap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../config.dart';

class FeaturedServiceProvider with ChangeNotifier {
  List<Services> featuredServiceList = [];
  List<Services> searchList = [];
  final FocusNode searchFocus = FocusNode();
  TextEditingController txtFeaturedSearch = TextEditingController();
  final PagingController<int, Services> pagingController =
      PagingController(firstPageKey: 1);
  AnimationController? animationController;
  
  FeaturedServiceProvider() {
    pagingController.addPageRequestListener(fetchPage);
  }

  //featured package list
  getFeaturedPackage() async {
    pagingController.refresh();
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      String apiLink = "${api.featuredServices}?paginate=10&page=$pageKey";
      if (txtFeaturedSearch.text.isNotEmpty) {
        apiLink += "&search=${txtFeaturedSearch.text}";
      }

      await apiServices.getApi(apiLink, [], isToken: true).then((value) {
        if (value.isSuccess!) {
          List<Services> newItems = [];
          bool isLastPage = false;

          if (value.data is List) {
            newItems = (value.data as List).map((e) => Services.fromJson(e)).toList();
            isLastPage = newItems.length < 10;
          } else if (value.data is Map && value.data['data'] != null) {
            newItems = (value.data['data'] as List).map((e) => Services.fromJson(e)).toList();
            isLastPage = value.data['next_page_url'] == null;
          }

          if (isLastPage) {
            pagingController.appendLastPage(newItems);
          } else {
            final nextPageKey = pageKey + 1;
            pagingController.appendPage(newItems, nextPageKey);
          }
        } else {
          pagingController.error = value.message;
        }
      });
    } catch (e) {
      pagingController.error = e;
    }
  }

  onBack(context, isBack) {
    txtFeaturedSearch.text = "";
    searchList = [];
    pagingController.refresh();
    notifyListeners();
    if (isBack) {
      route.pop(context);
    }
  }

  onReady(context, TickerProvider sync) async {
    animationController = AnimationController(
        vsync: sync, duration: const Duration(milliseconds: 1200));
    _runAnimation();
    
    notifyListeners();
  }

  Future<List<Services>> fetchData(context) async {
    // This is now used by PagedListView indirectly or can be removed if switching entirely
    return [];
  }

  void _runAnimation() async {
    for (int i = 0; i < 300; i++) {
      await animationController!.forward();
      await animationController!.reverse();
    }
  }

  onFeatured(context, Services? services, id,
      {inCart, isSearch = false}) async {
    if (inCart) {
      route.pop(context);
      route.pushNamed(context, routeName.cartScreen);
    } else {
      final providerDetail =
          Provider.of<ProviderDetailsProvider>(context, listen: false);
      providerDetail.selectProviderIndex = 0;
      providerDetail.notifyListeners();
      onBook(context, services!,
              addTap: () => onAdd(context, id, isSearch: isSearch),
              minusTap: () => onRemoveService(context, id, isSearch: isSearch))!
          .then((e) {
        searchList[id].selectedRequiredServiceMan =
            searchList[id].requiredServicemen;
        notifyListeners();
      });
    }
  }

  onRemoveService(context, index, {isSearch = false}) async {
    if (isSearch) {
      if ((searchList[index].selectedRequiredServiceMan!) == 1) {
        route.pop(context);
        isAlert = false;
        notifyListeners();
      } else {
        if ((searchList[index].requiredServicemen!) ==
            (searchList[index].selectedRequiredServiceMan!)) {
          isAlert = true;
          notifyListeners();
          await Future.delayed(DurationClass.s3);
          isAlert = false;
          notifyListeners();
        } else {
          isAlert = false;
          notifyListeners();
          searchList[index].selectedRequiredServiceMan =
              ((searchList[index].selectedRequiredServiceMan!) - 1);
        }
      }
    } else {
      final dash = Provider.of<DashboardProvider>(context, listen: false);
      dash.onRemoveService(context, index);
      dash.notifyListeners();
    }
    notifyListeners();
  }

  onAdd(context, index, {isSearch = false}) {
    isAlert = false;
    notifyListeners();
    if (isSearch) {
      int count = (searchList[index].selectedRequiredServiceMan!);
      count++;
      searchList[index].selectedRequiredServiceMan = count;
    } else {
      final dash = Provider.of<DashboardProvider>(context, listen: false);
      dash.onAdd(index);
      dash.notifyListeners();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController!.dispose();
    super.dispose();
  }
}
