import 'package:klpro_user/common/extension/text_style_extensions.dart';
import 'package:klpro_user/config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_pages_providers/live_tracking_provider.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveTrackingProvider>(
      builder: (context, value, child) {
        return StatefulWrapper(
          onInit: () => Future.delayed(DurationClass.ms150).then((_) => value.onReady(context)),
          child: Scaffold(
            appBar: AppBarCommon(
              title: language(context, "Track Location"),
              onTap: () => route.pop(context),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: value.userLocation ?? const LatLng(0, 0),
                    zoom: 15,
                  ),
                  onMapCreated: value.onMapCreated,
                  markers: value.markers,
                  polylines: value.polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
                if (value.isLoading && value.providerLocation == null)
                  const Center(child: CircularProgressIndicator()),
                
                // Legend overlay (Aligned with Provider App UX)
                Positioned(
                  bottom: 120, // Above the "Provider is on the way" card
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: appColor(context).whiteBg.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 18),
                          const HSpace(Sizes.s5),
                          Text(language(context, 'You (Customer)'),
                              style: appCss.dmDenseMedium12.textColor(appColor(context).darkText)),
                        ]),
                        Row(children: [
                          const Icon(Icons.location_on, color: Colors.blue, size: 18),
                          const HSpace(Sizes.s5),
                          Text(language(context, 'Provider'),
                              style: appCss.dmDenseMedium12.textColor(appColor(context).darkText)),
                        ]),
                      ],
                    ),
                  ),
                ),

                // Bottom Status Card
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(Insets.i15),
                    decoration: BoxDecoration(
                      color: appColor(context).whiteBg,
                      borderRadius: BorderRadius.circular(AppRadius.r15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: Sizes.s50,
                          width: Sizes.s50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appColor(context).fieldCardBg,
                          ),
                          child: Icon(Icons.delivery_dining, color: appColor(context).primary),
                        ),
                        const HSpace(Sizes.s15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                language(context, "Provider is on the way"),
                                style: appCss.dmDenseBold16.textColor(appColor(context).darkText),
                              ),
                              Text(
                                language(context, "Tracking your service provider in real-time"),
                                style: appCss.dmDenseMedium12.textColor(appColor(context).lightText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Map Control Buttons
                Positioned(
                  top: 20,
                  right: 20,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: "fit",
                        backgroundColor: appColor(context).whiteBg,
                        onPressed: () => value.onMapCreated(value.mapController!), // Re-fit bounds
                        child: Icon(Icons.zoom_out_map, color: appColor(context).primary),
                      ),
                      const VSpace(Sizes.s10),
                      FloatingActionButton.small(
                        heroTag: "my_loc",
                        backgroundColor: appColor(context).whiteBg,
                        onPressed: () {
                          if (value.userLocation != null) {
                            value.mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(value.userLocation!, 15),
                            );
                          }
                        },
                        child: Icon(Icons.my_location, color: appColor(context).primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
