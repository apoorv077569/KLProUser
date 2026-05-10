
import 'package:flutter_svg/svg.dart';
import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/common/extension/widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../config.dart';

class ServiceImageLayout extends StatelessWidget {
  final String? image, rating, title;
  final GestureTapCallback? favTap, removeTap;

  // final bool? isFav;
  final bool isJobRequest;
  final GestureTapCallback? onBack, editTap;
  final data;

  const ServiceImageLayout(
      {super.key,
      this.rating,
      this.image,
      this.favTap,
      this.removeTap,
      this.title,
      // this.isFav,
      this.editTap,
      this.onBack,
      this.isJobRequest = false,
      this.data});

  @override
  Widget build(BuildContext context) {
    final sevrviceDetails =
        Provider.of<ServicesDetailsProvider>(context, listen: false);

    YoutubePlayerController? playerController = YoutubePlayerController(
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
        initialVideoId: YoutubePlayer.convertUrlToId(
                sevrviceDetails.service?.video ?? "") ??
            '');
    return Consumer<ServicesDetailsProvider>(builder: (context, value, child) {
      return Stack(children: [
        value.isVideo == true
            ? SizedBox(
                height: Sizes.s230,
                child: GestureDetector(
                  onTap: () {
                    print("object=-=-=-=-=-=-=-=-=-");
                    if (playerController.value.isPlaying) {
                      playerController.play();
                    } else {
                      playerController.pause();
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: playerController.value.isPlaying,
                    child: YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller:
                            playerController /* YoutubePlayerController(
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                            disableDragSeek: true,
                          ),
                          initialVideoId: YoutubePlayer.convertUrlToId(
                                  value.services?.video ?? "") ??
                              '') */
                        ,
                        showVideoProgressIndicator: true,
                      ),
                      /*  YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                                value.services?.video ?? "") ??
                            '',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      ),
                      // showVideoProgressIndicator: true,
                    ), */
                      builder: (context, player) {
                        return player;
                      },
                    ),
                  ),
                )).inkWell(onTap: () {
                print("object=-=-=-=-=-=-=-=-=-=-=-");
                if (playerController.value.isPlaying) {
                  playerController.play();
                } else {
                  playerController.pause();
                }
                /*  if (value.videoControllers!.value.isPlaying) {
                  value.videoControllers?.play();
                } else {
                  value.videoControllers?.pause();
                } */
              })
            : Container(
                width: MediaQuery.of(context).size.width,
                height: Sizes.s300,
                color: Colors.black,
                child: CachedNetworkImage(
                  imageUrl: image!,
                  width: MediaQuery.of(context).size.width,
                  height: Sizes.s300,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  errorWidget: (context, url, error) => Image.asset(
                      eImageAssets.noImageFound2,
                      fit: BoxFit.contain),
                ),
              ),
        if (value.isVideo != true)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        appColor(context).darkText.withOpacity(0.15),
                        appColor(context).darkText.withOpacity(0.5)
                      ])),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonArrow(
                              arrow: eSvgAssets.arrowLeft, onTap: onBack),
                          isJobRequest
                              ? const SizedBox()
                              : data.isFavourite == 1
                                  ? SvgPicture.asset(eSvgAssets.heart,
                                          height: Sizes.s40,
                                          width: Sizes.s40)
                                      .inkWell(onTap: removeTap)
                                  : CommonArrow(
                                      arrow: eSvgAssets.like, onTap: favTap)
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(title!,
                                style: appCss.dmDenseSemiBold18.textColor(
                                    appColor(context).whiteColor)),
                          ),
                          if (rating != null)
                            Row(children: [
                              SvgPicture.asset(eSvgAssets.star),
                              const HSpace(Sizes.s4),
                              Text(rating!,
                                  style: appCss.dmDenseMedium13.textColor(
                                      appColor(context).whiteColor))
                            ])
                        ])
                  ]).padding(
                  horizontal: Insets.i20,
                  top: MediaQuery.of(context).padding.top + Insets.i10,
                  bottom: Insets.i20),
            ),
          )
      ]);
    });
  }
}
