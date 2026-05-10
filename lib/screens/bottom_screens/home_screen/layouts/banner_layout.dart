
import '../../../../config.dart';

class BannerLayout extends StatefulWidget {
  final List? bannerList;
  final bool isDubai;
  final bool? isBerlin;
  final Function(int index, CarouselPageChangedReason reason)? onPageChanged;
  final Function(String, String)? onTap;

  const BannerLayout({
    super.key,
    this.bannerList,
    this.onPageChanged,
    this.onTap,
    this.isBerlin,
    this.isDubai = false,
  });

  @override
  State<BannerLayout> createState() => _BannerLayoutState();
}

class _BannerLayoutState extends State<BannerLayout> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.bannerList!
        .where((i) => i.media != null && i.media!.isNotEmpty)
        .toList();

    if (filteredList.isEmpty) return const SizedBox.shrink();

    final double bannerHeight = widget.isDubai ? Sizes.s180 : Sizes.s240;
    final double br = widget.isDubai ? Sizes.s12 : 0;
    final EdgeInsets pad = EdgeInsets.only(
      top: Insets.i20,
      left: widget.isDubai ? Insets.i20 : 0,
      right: widget.isDubai ? Insets.i20 : 0,
    );

    // ── Single banner: plain static image (no carousel) ──
    if (filteredList.length == 1) {
      final item = filteredList.first;
      final mediaItem = item.media!.first;
      return Padding(
        padding: pad,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(br),
          child: SizedBox(
            height: bannerHeight,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: mediaItem.originalUrl!,
              fit: BoxFit.fill,
              placeholder: (context, url) => Container(
                color: appColor(context).fieldCardBg,
                child: Image.asset(
                  eImageAssets.noImageFound2,
                  fit: BoxFit.fill,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                eImageAssets.noImageFound2,
                fit: BoxFit.fill,
              ),
            ).inkWell(onTap: () {
              widget.onTap?.call(item.type!, item.relatedId.toString());
            }),
          ),
        ),
      );
    }

    // ── Multiple banners: auto-sliding carousel, no arrows ──
    return CarouselSlider(
      carouselController: _controller,
      options: CarouselOptions(
        autoPlay: true,
        height: bannerHeight + Insets.i20,
        viewportFraction: 1,
        enlargeCenterPage: false,
        reverse: false,
        onPageChanged: (index, reason) {
          setState(() => _current = index);
          widget.onPageChanged?.call(index, reason);
        },
      ),
      items: filteredList.map((i) {
        final mediaItem = i.media!.first;
        return Padding(
          padding: pad,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(br),
            child: CachedNetworkImage(
              imageUrl: mediaItem.originalUrl!,
              height: bannerHeight,
              width: double.infinity,
              fit: BoxFit.fill,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                color: appColor(context).fieldCardBg,
                child: Image.asset(
                  eImageAssets.noImageFound2,
                  fit: BoxFit.fill,
                ),
              ),
              errorWidget: (context, url, error) => Image.asset(
                eImageAssets.noImageFound2,
                fit: BoxFit.fill,
              ),
            ).inkWell(onTap: () {
              widget.onTap?.call(i.type!, i.relatedId.toString());
            }),
          ),
        );
      }).toList(),
    );
  }
}
