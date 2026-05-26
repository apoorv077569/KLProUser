import 'package:flutter/material.dart';
import 'package:klpro_user/config.dart';
import 'package:klpro_user/screens/app_pages_screens/ServiceViewDetailScreen/ServiceViewDetail.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> services;

  const ServiceDetailsScreen({
    super.key,
    required this.title,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("APPU_DEBUG SCREEN SERVICES => $services");

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          title,

          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.search, color: Colors.black),
          ),

          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.share, color: Colors.black),
          ),
        ],
      ),

      body: services.isEmpty
          ? const Center(child: Text("No services found"))
          : ListView.builder(
              itemCount: services.length,

              itemBuilder: (context, index) {
                final item = services[index];

                debugPrint("APPU_DEBUG ITEM => $item");

                return Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      /// LEFT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              item["title"]?.toString() ?? "",

                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Colors.black,
                                ),

                                const SizedBox(width: 5),

                                Expanded(
                                  child: Text(
                                    "${item["rating"] ?? ""} (${item["reviews"] ?? ""})",

                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Starts at ${item["price"] ?? "₹0"}",

                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            bullet(item["desc1"]?.toString() ?? ""),

                            bullet(item["desc2"]?.toString() ?? ""),

                            const SizedBox(height: 18),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ServiceViewDetailScreen(item: item),
                                  ),
                                );
                              },

                              child: const Text(
                                "View details",

                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 18),

                      /// RIGHT
                      Column(
                        children: [
                          Container(
                            height: 150,
                            width: 150,

                            padding: const EdgeInsets.all(20),

                            decoration: BoxDecoration(
                              color: const Color(0xffF5F5F5),

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: Image.asset(
                              item["image"]?.toString() ??
                                  "assets/icons/cleaning.png",

                              fit: BoxFit.contain,

                              errorBuilder: (context, error, stackTrace) {
                                debugPrint("APPU_DEBUG IMAGE ERROR => $error");

                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                );
                              },
                            ),
                          ),

                          Transform.translate(
                            offset: const Offset(0, -18),

                            child: SizedBox(
                              width: 110,
                              height: 48,

                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,

                                  foregroundColor: Colors.deepPurple,

                                  elevation: 3,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),

                                onPressed: () {
                                  try {
                                    debugPrint(
                                      "APPU_DEBUG ADD BUTTON ITEM => $item",
                                    );

                                    debugPrint(
                                      "APPU_DEBUG PRICE TYPE => ${item["price"].runtimeType}",
                                    );

                                    debugPrint(
                                      "APPU_DEBUG PRICE VALUE => ${item["price"]}",
                                    );

                                    final price =
                                        int.tryParse(
                                          item["price"].toString().replaceAll(
                                            "₹",
                                            "",
                                          ),
                                        ) ??
                                        0;

                                    debugPrint(
                                      "APPU_DEBUG FINAL PRICE => $price",
                                    );

                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );

                                    CartModel newCart = CartModel(
                                      isPackage: false,

                                      serviceList: Services(
                                        title: item["title"].toString(),

                                        serviceRate: price,

                                        requiredServicemen: 1,

                                        selectedRequiredServiceMan: 1,

                                        type: "fixed",
                                      ),
                                    );

                                    cartProvider.cartList.add(newCart);

                                    cartProvider.notifyListeners();

                                    debugPrint(
                                      "APPU_DEBUG ADDED TO CART SUCCESS",
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${item["title"]} added to cart",
                                        ),
                                      ),
                                    );
                                  } catch (e, s) {
                                    debugPrint(
                                      "APPU_DEBUG ADD CART ERROR => $e",
                                    );

                                    debugPrint(
                                      "APPU_DEBUG ADD CART STACK => $s",
                                    );
                                  }
                                },

                                child: const Text(
                                  "Add",

                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const Text(
                            "5 options",

                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

      /// BOTTOM BAR
      bottomNavigationBar: Container(
        height: 70,

        padding: const EdgeInsets.symmetric(horizontal: 20),

        decoration: const BoxDecoration(color: Color(0xffEAF7EE)),

        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.green),

            const SizedBox(width: 10),

            const Expanded(
              child: Text(
                "Save 10% on every order get Plus now",

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                debugPrint("APPU_DEBUG VIEW CART CLICK");

                route.pushNamed(context, routeName.cartScreen);
              },

              child: const Text("View Cart"),
            ),
          ],
        ),
      ),
    );
  }

  Widget bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text("• ", style: TextStyle(fontSize: 18)),

          Expanded(
            child: Text(
              text,

              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
