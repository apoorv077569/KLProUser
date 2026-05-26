import 'package:klpro_user/common/assets/index.dart';
import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _shineAnimation = Tween<double>(
      begin: 1.2,
      end: -1.2,
    ).animate(
      CurvedAnimation(
        parent: _shineController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final splash = Provider.of<SplashProvider>(context, listen: false);
      splash.onReady(context);
    });
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splash, child) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: appColor(context).primary.withOpacity(0.7),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  eImageAssets.splashBg,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // LOGO + SHINE
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _shineAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Bigger Logo
                        Image.asset(
                          eImageAssets.appLogo,
                          height: 170,
                          width: 170,
                        ),

                        // Shine Effect
                        ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              _shineAnimation.value * 200,
                            ),
                            child: Container(
                              height: 220,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  appFonts.fixit,
                  style: appCss.outfitSemiBold25
                      .textColor(appColor(context).whiteColor),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}