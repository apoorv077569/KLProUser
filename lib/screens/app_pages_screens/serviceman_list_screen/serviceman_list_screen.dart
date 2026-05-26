/// ==========================================
/// SERVICEMAN LIST SCREEN
/// ==========================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config.dart';

class ServicemanListScreen extends StatelessWidget {
  const ServicemanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SelectServicemanProvider>(
        context,
        listen: false,
      ).onReady(context);
    });

    return Consumer<SelectServicemanProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "Select Serviceman",
            ),
          ),

          body: value.providerList.isEmpty
              ? const Center(
                  child: Text(
                    "No Serviceman Found",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: value.providerList.length,

                  itemBuilder: (context, index) {

                    final serviceman =
                        value.providerList[index];

                    String imageUrl = "";

                    if (serviceman.media != null &&
                        serviceman.media!.isNotEmpty) {

                      imageUrl =
                          serviceman.media!.first.originalUrl ??
                              "";
                    }

                    return Container(

                      margin: const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding: const EdgeInsets.all(
                        14,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          /// PROFILE IMAGE
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(50),

                            child: imageUrl.isNotEmpty

                                ? Image.network(

                                    imageUrl,

                                    width: 70,
                                    height: 70,

                                    fit: BoxFit.cover,

                                    errorBuilder:
                                        (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                      return Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey.shade200,

                                        child: const Icon(
                                          Icons.person,
                                          size: 35,
                                        ),
                                      );
                                    },
                                  )

                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade200,

                                    child: const Icon(
                                      Icons.person,
                                      size: 35,
                                    ),
                                  ),
                          ),

                          const SizedBox(width: 16),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  serviceman.name ?? "",

                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 18,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      "${serviceman.reviewRatings ?? 0}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  serviceman.email ?? "",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// BUTTON
                          ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),

                            onPressed: () {

                              debugPrint(
                                "APPU_DEBUG SERVICEMAN SELECTED",
                              );

                              Navigator.pushNamed(
                                context,
                                routeName.slotBookingScreen,
                              );
                            },

                            child: const Text(
                              "Select",
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}