/// ===========================================================
/// FILE:
/// custom_time_picker.dart
/// FULL WORKING CODE
/// ===========================================================

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../config.dart';

class CustomTimePicker extends StatelessWidget {

  final String title;

  final Function(int) onScroll;

  final CarouselSliderController
  carouselController;

  final List<String> itemList;

  const CustomTimePicker({

    super.key,

    required this.title,

    required this.onScroll,

    required this.carouselController,

    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      height: 90,

      width: 90,

      decoration: BoxDecoration(

        color:
        appColor(context)
            .fieldCardBg,

        borderRadius:
        BorderRadius.circular(
          20,
        ),
      ),

      child: CarouselSlider.builder(

        carouselController:
        carouselController,

        itemCount:
        itemList.length,

        itemBuilder:
            (
            context,
            index,
            realIndex,
            ) {

          return Center(

            child: Text(

              itemList[index],

              style:
              appCss.dmDenseBold24
                  .textColor(

                appColor(context)
                    .primary,
              ),
            ),
          );
        },

        options: CarouselOptions(

          initialPage: 0,

          height: 90,

          viewportFraction: 0.35,

          enlargeCenterPage: true,

          enableInfiniteScroll:
          false,

          autoPlay: false,

          scrollDirection:
          Axis.vertical,

          onPageChanged:
              (
              index,
              reason,
              ) {

            debugPrint(

              "APPU_DEBUG_TIME_SCROLL => "
                  "${itemList[index]}",
            );

            onScroll(index);
          },
        ),
      ),
    );
  }
}