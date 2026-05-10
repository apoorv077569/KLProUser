import 'package:klpro_user/packages_list.dart';
import 'package:klpro_user/screens/app_pages_screens/service_select_user_screen/layouts/service_select_user_step_one.dart';
import 'package:klpro_user/screens/app_pages_screens/service_select_user_screen/layouts/service_select_user_step_two.dart';

import '../../../config.dart';

class ServiceSelectedUserScreen extends StatelessWidget {
  const ServiceSelectedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceSelectProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () => Future.delayed(
              const Duration(milliseconds: 100), () => value.onInit(context)),
          child: Scaffold(
              appBar: AppBarCommon(
                  onTap: () {
                    if (value.isStep2 == true) {
                      value.isStep2 = false;
                    } else {
                      route.pop(context);
                    }
                  },
                  title:
                      "${language(context, translations!.step)} ${value.isStep2 == false ? "1" : "2"}"),
              body: value.isStep2 == false
                  ? const ServiceSelectUserStepOne()
                  : const ServiceSelectUserStepTwo()));
    });
  }
}
