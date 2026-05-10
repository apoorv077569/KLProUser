
import '../../../../config.dart';

class TopCategoriesLayout extends StatefulWidget {
  final data;
  final GestureTapCallback? onTap;
  final int? index, selectedIndex;
  final double? rPadding;
  final bool isCategories, isExapnded, isCircle;
  final bool showShimmer;

  const TopCategoriesLayout({
    super.key,
    this.onTap,
    this.data,
    this.index,
    this.selectedIndex,
    this.isCategories = false,
    this.isExapnded = true,
    this.isCircle = false,
    this.rPadding,
    this.showShimmer = false,
  });

  @override
  State<TopCategoriesLayout> createState() => _TopCategoriesLayoutState();
}

class _TopCategoriesLayoutState extends State<TopCategoriesLayout>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Category Detail Screen: original icon-chip style ──
    if (widget.isCategories) {
      return _buildOriginalChipStyle(context);
    }
    // ── Home / View-All Grid: new full-bleed cover style ──
    return _buildGridCoverStyle(context);
  }

  // ─────────────────────────────────────────────────────────
  // ORIGINAL design used in category detail screen subcategory row
  // ─────────────────────────────────────────────────────────
  Widget _buildOriginalChipStyle(BuildContext context) {
    final bool isSelected = widget.selectedIndex == widget.index;
    return Column(children: [
       ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r10),
        child: Container(
          height: Sizes.s70,
          width: Sizes.s70,
          decoration: ShapeDecoration(
              color: isSelected
                  ? appColor(context).primary.withOpacity(0.2)
                  : appColor(context).fieldCardBg,
              shape: SmoothRectangleBorder(
                  side: BorderSide(
                      color: isSelected
                          ? appColor(context).primary
                          : appColor(context).trans,
                      width: 2),
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
          // Real network image → full-bleed cover
          // "All" or no-media → small padded icon (original style)
          child: widget.data?.media != null &&
                  widget.data!.media!.isNotEmpty &&
                  widget.data?.title != "All"
              ? CachedNetworkImage(
                  imageUrl: widget.data?.media?.first.originalUrl ?? "",
                  fit: BoxFit.cover,
                  width: Sizes.s70,
                  height: Sizes.s70,
                  placeholder: (context, url) => Container(
                    color: appColor(context).fieldCardBg,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    eImageAssets.noImageFound1,
                    fit: BoxFit.fill,
                    height: Sizes.s22,
                    width: Sizes.s22,
                  ).paddingAll(Insets.i18),
                )
              // "All" icon or fallback → small centered icon with padding
              : Image.asset(
                  widget.data?.title == "All"
                      ? eImageAssets.all
                      : eImageAssets.noImageFound1,
                  fit: BoxFit.contain,
                  height: Sizes.s22,
                  width: Sizes.s22,
                  color: isSelected ? appColor(context).primary : null,
                ).paddingAll(Insets.i18)),
      ),
      const VSpace(Sizes.s8),
      if (widget.isExapnded)
        Text(
          widget.data?.title ?? "",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: appCss.dmDenseRegular12.textColor(
            isSelected
                ? appColor(context).primary
                : appColor(context).darkText,
          ),
        ).width(Sizes.s76).paddingDirectional(horizontal: Sizes.s5),
      if (!widget.isExapnded)
        Text(
          widget.data?.title ?? "",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: appCss.dmDenseRegular11.textColor(
            isSelected
                ? appColor(context).primary
                : appColor(context).darkText,
          ),
        ).width(Sizes.s76).paddingDirectional(horizontal: Sizes.s5),
    ]).inkWell(onTap: widget.onTap);
  }

  // ─────────────────────────────────────────────────────────
  // NEW design used in home screen / view-all grid (4-column)
  // ─────────────────────────────────────────────────────────
  Widget _buildGridCoverStyle(BuildContext context) {
    final bool isSelected = widget.selectedIndex == widget.index;
    const double imageH = 80;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Image Card ──
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: imageH,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? appColor(context).primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Category Image ──
                  widget.data?.media != null &&
                          widget.data!.media!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              widget.data?.media?.first.originalUrl ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: imageH,
                          placeholder: (context, url) => Container(
                            color: appColor(context).fieldCardBg,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: appColor(context).fieldCardBg,
                            child: Image.asset(
                              widget.data?.title == "All"
                                  ? eImageAssets.all
                                  : eImageAssets.noImageFound1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          color: isSelected
                              ? appColor(context).primary.withOpacity(0.12)
                              : appColor(context).fieldCardBg,
                          child: Image.asset(
                            widget.data?.title == "All"
                                ? eImageAssets.all
                                : eImageAssets.noImageFound1,
                            fit: BoxFit.cover,
                            color: isSelected
                                ? appColor(context).primary
                                : null,
                          ),
                        ),

                  // ── Animated diagonal shimmer (only on home screen) ──
                  if (widget.showShimmer)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedBuilder(
                          animation: _shimmerAnim,
                          builder: (_, __) {
                            final v = _shimmerAnim.value;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(v - 1, v - 1),
                                  end: Alignment(v, v),
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white.withOpacity(0.22),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // ── Selected highlight ──
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              appColor(context).primary.withOpacity(0.15),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const VSpace(Sizes.s6),

          // ── Category name — bold, max 2 lines, ellipsis ──
          Flexible(
            child: Text(
              widget.data?.title ?? "",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: appCss.dmDenseMedium12.textColor(
                isSelected
                    ? appColor(context).primary
                    : appColor(context).darkText,
              ),
            ).paddingDirectional(horizontal: Sizes.s4),
          ),
        ],
      ),
    );
  }
}
