import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:klpro_user/config.dart';

class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: EmptyLayout(
            title: " Internal server error",
            subtitle: "",
            isButtonShow: false,
            widget: Image.asset(
              eImageAssets.maintenanceImage,
              height: Sizes.s346,
            ).center()));
  }
}
