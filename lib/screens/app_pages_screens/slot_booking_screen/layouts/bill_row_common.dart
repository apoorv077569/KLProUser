
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';

import '../../../../config.dart';

class BillRowCommon extends StatelessWidget {
  final String? title,price;
  final Color? color;
  final TextStyle? style,styleTitle;
  const BillRowCommon({super.key,this.title,this.price,this.color,this.style,this.styleTitle});

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(language(context, title!),
              style: styleTitle ?? appCss.dmDenseRegular14
                  .textColor(appColor(context).lightText)),
        ),
        Text(price!,
            style: style ?? appCss.dmDenseRegular14
                .textColor( color ?? appColor(context).darkText))
      ],
    ).paddingSymmetric(horizontal: Insets.i15);
  }
}