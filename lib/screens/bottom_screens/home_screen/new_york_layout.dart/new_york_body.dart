import 'package:klpro_user/screens/app_pages_screens/service_detail_screen/service_detail_screen.dart';

import '../../../../config.dart';

class NewYorkBody extends StatelessWidget {
  const NewYorkBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 30),
      children: [
        /// TOP SEARCH + BANNER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 4),

              TextField(
                decoration: InputDecoration(
                  hintText: "Search for 'AC service'",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// BLUE BANNER
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xff0057FF), Color(0xff0B8BFF)],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/banner.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        /// SERVICES GRID
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 14,
            crossAxisSpacing: 10,
            mainAxisExtent: 125,
            children: const [
              ServiceItem(
                image: "assets/icons/women_saloon.png",
                title: "Women's\nSalon",
              ),

              ServiceItem(
                image: "assets/icons/saloon.png",
                title: "Men's Salon",
              ),

              ServiceItem(
                image: "assets/icons/cleaning.png",
                title: "Cleaning &\nPest Control",
              ),

              ServiceItem(
                image: "assets/icons/painting.png",
                title: "Wall\nMakeover",
              ),

              ServiceItem(
                image: "assets/icons/painting.png",
                title: "Painting &\nWaterproofing",
              ),

              ServiceItem(image: "assets/icons/ac.png", title: "AC &\nRepair"),

              ServiceItem(
                image: "assets/icons/plumbing.png",
                title: "Electrician\nPlumber",
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// SMART PRODUCTS
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Native Smart Products",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              ProductItem(
                image: "assets/icons/water_purifier.png",
                title: "Native Water\nPurifier",
              ),

              SizedBox(width: 14),

              ProductItem(
                image: "assets/icons/smart_lock.png",
                title: "Native Smart\nLocks",
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// REBOOK SERVICES
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Rebook services",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              RebookItem(image: "assets/icons/massage.png", title: "Massage"),

              SizedBox(width: 12),

              RebookItem(image: "assets/icons/facial.png", title: "Facial"),

              SizedBox(width: 12),

              RebookItem(image: "assets/icons/cleaning.png", title: "Cleaning"),

              SizedBox(width: 12),

              RebookItem(
                image: "assets/icons/sofa_cleaning.png",
                title: "Sofa Cleaning",
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),
      ],
    );
  }
}

/// ================= SERVICE ITEM =================

class ServiceItem extends StatelessWidget {
  final String image;
  final String title;

  const ServiceItem({super.key, required this.image, required this.title});

  /// ================= MAIN BOTTOM SHEET =================

  void openServiceBottomSheet(BuildContext context) {
    /// ONLY CLEANING FLOW
    if (title == "Cleaning &\nPest Control") {
      final List<Map<String, dynamic>> mainCategory = [
        {"title": "Cleaning", "image": "assets/icons/cleaning.png"},

        {"title": "Pest Control", "image": "assets/icons/cleaning.png"},
      ];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,

        builder: (context) {
          return Container(
            height: 420,

            decoration: const BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),

            child: Column(
              children: [
                /// HANDLE
                Container(
                  margin: const EdgeInsets.only(top: 12),

                  height: 5,
                  width: 60,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,

                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                /// TITLE
                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Cleaning & Pest Control",

                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),

                /// GRID
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    itemCount: mainCategory.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 220,
                        ),

                    itemBuilder: (context, index) {
                      final item = mainCategory[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(22),

                        /// ================= CLICK =================
                        onTap: () {
                          Navigator.pop(context);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            if (item["title"] == "Cleaning") {
                              openCleaningSheet(context);
                            } else {
                              openPestControlSheet(context);
                            }
                          });
                        },

                        child: Container(
                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),

                            borderRadius: BorderRadius.circular(22),

                            border: Border.all(color: Colors.grey.shade200),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              /// IMAGE
                              Container(
                                height: 100,
                                width: 100,

                                padding: const EdgeInsets.all(18),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(22),
                                ),

                                child: Image.asset(
                                  item["image"],
                                  fit: BoxFit.contain,
                                ),
                              ),

                              const SizedBox(height: 18),

                              /// TITLE
                              Text(
                                item["title"],

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );

      return;
    }

    void openDetailsScreen(
      BuildContext context, {
      required String title,
      required String image,
    }) {
      final List<Map<String, dynamic>> services = [
        {
          "title": "$title Premium",

          "price": "₹399",

          "rating": "4.8",

          "reviews": "12K reviews",

          "image": image,

          "desc1": "Professional service included",

          "desc2": "Premium quality work",
        },

        {
          "title": "$title Deluxe",

          "price": "₹699",

          "rating": "4.9",

          "reviews": "20K reviews",

          "image": image,

          "desc1": "Deep cleaning & support",

          "desc2": "Top rated professionals",
        },
      ];

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              ServiceDetailsScreen(title: title, services: services),
        ),
      );
    }

    /// ================= NORMAL SERVICES =================

    final List<String> serviceList = [
      "$title Basic",
      "$title Premium",
      "$title Deluxe",
      "$title Express",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),

      builder: (bottomContext) {
        return Padding(
          padding: const EdgeInsets.all(16),

          child: SizedBox(
            height: 320,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: serviceList.length,

                    itemBuilder: (context, index) {
                      return InkWell(
                        /// DIRECT ADD TO CART
                        onTap: () {
                          debugPrint("APPU_DEBUG NORMAL SERVICE CLICK");

                          Navigator.pop(context);

                          Future.delayed(const Duration(milliseconds: 200), () {
                            openDetailsScreen(
                              context,

                              title: serviceList[index],

                              image: image,
                            );
                          });
                        },

                        child: Container(
                          width: 170,

                          margin: const EdgeInsets.only(right: 14),

                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: const Color(0xffF8F8F8),

                            borderRadius: BorderRadius.circular(18),
                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Container(
                                height: 80,
                                width: 80,

                                padding: const EdgeInsets.all(16),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius: BorderRadius.circular(16),
                                ),

                                child: Image.asset(image),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                serviceList[index],

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "₹399",

                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= CLEANING SHEET =================

  void openCleaningSheet(BuildContext context) {
    final List<Map<String, dynamic>> cleaningList = [
      {
        "title": "Bathroom & Kitchen Cleaning",

        "image": "assets/icons/cleaning.png",

        "services": [
          {
            "title": "Bathroom Cleaning",
            "price": "₹499",
            "rating": "4.81",
            "reviews": "120K reviews",
            "image": "assets/icons/cleaning.png",

            "desc1": "Complete bathroom deep cleaning",

            "desc2": "Tiles, sink & fittings cleaning",
          },

          {
            "title": "Kitchen Cleaning",
            "price": "₹699",
            "rating": "4.74",
            "reviews": "89K reviews",
            "image": "assets/icons/cleaning.png",

            "desc1": "Complete kitchen cleaning",

            "desc2": "Oil & grease stain removal",
          },
        ],
      },

      {
        "title": "Sofa & Carpet Cleaning",

        "image": "assets/icons/cleaning.png",

        "services": [
          {
            "title": "Carpet cleaning",
            "price": "₹399",
            "rating": "4.79",
            "reviews": "102K reviews",
            "image": "assets/icons/cleaning.png",

            "desc1": "Dry vacuuming to remove crumbs",

            "desc2": "Wet shampooing & vacuuming",
          },

          {
            "title": "Dining table & chairs cleaning",

            "price": "₹499",
            "rating": "4.82",
            "reviews": "57K reviews",
            "image": "assets/icons/cleaning.png",

            "desc1": "Dusting & wet wiping",

            "desc2": "Wet shampooing of chairs",
          },
        ],
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          height: 420,

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),

          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),

                height: 5,
                width: 60,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(20),

                child: Align(
                  alignment: Alignment.centerLeft,

                  child: Text(
                    "Cleaning",

                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  itemCount: cleaningList.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 220,
                  ),

                  itemBuilder: (context, index) {
                    final item = cleaningList[index];

                    return InkWell(
                      /// ================= OPEN SERVICE PAGE =================
                      onTap: () {
                        try {
                          final item = cleaningList[index];

                          debugPrint("APPU_DEBUG STEP 1 CLICKED");

                          debugPrint("APPU_DEBUG STEP 2 ITEM => $item");

                          debugPrint(
                            "APPU_DEBUG STEP 3 TITLE => ${item["title"]}",
                          );

                          debugPrint(
                            "APPU_DEBUG STEP 4 SERVICES => ${item["services"]}",
                          );

                          final services = List<Map<String, dynamic>>.from(
                            item["services"],
                          );

                          debugPrint(
                            "APPU_DEBUG STEP 5 CONVERTED SERVICES => $services",
                          );

                          Navigator.pop(context);

                          debugPrint("APPU_DEBUG STEP 6 BOTTOM SHEET CLOSED");

                          Future.delayed(const Duration(milliseconds: 200), () {
                            debugPrint("APPU_DEBUG STEP 7 NAVIGATING");

                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) {
                                  debugPrint(
                                    "APPU_DEBUG STEP 8 SCREEN BUILD START",
                                  );

                                  return ServiceDetailsScreen(
                                    title: item["title"],
                                    services: services,
                                  );
                                },
                              ),
                            );

                            debugPrint("APPU_DEBUG STEP 9 NAVIGATION COMPLETE");
                          });
                        } catch (e, s) {
                          debugPrint("APPU_DEBUG CRASH ERROR => $e");

                          debugPrint("APPU_DEBUG CRASH STACK => $s");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),

                        decoration: BoxDecoration(
                          color: const Color(0xffF8F8F8),

                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              height: 100,
                              width: 100,

                              padding: const EdgeInsets.all(18),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(22),
                              ),

                              child: Image.asset(
                                item["image"],
                                fit: BoxFit.contain,
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(
                              item["title"],

                              maxLines: 2,

                              overflow: TextOverflow.ellipsis,

                              textAlign: TextAlign.center,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= PEST CONTROL SHEET =================

  void openPestControlSheet(BuildContext context) {
    final List<String> pestList = [
      "Cockroach Control",
      "Termite Control",
      "Ant Control",
      "Bed Bugs Control",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,

      builder: (context) {
        return Container(
          height: 340,

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text(
                "Pest Control",

                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: pestList.length,

                  itemBuilder: (context, index) {
                    return InkWell(
                      /// DIRECT ADD TO CART
                      onTap: () {
                        final services = [
                          {
                            "title": pestList[index],

                            "price": "₹299",

                            "rating": "4.8",

                            "reviews": "10K reviews",

                            "image": "assets/icons/cleaning.png",

                            "desc1": "Professional pest treatment",

                            "desc2": "Safe chemical spray included",
                          },
                        ];
                        Navigator.pop(context);

                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (!context.mounted) return;

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) => ServiceDetailsScreen(
                                title: pestList[index],

                                services: services,
                              ),
                            ),
                          );
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),

                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.bug_report),

                            const SizedBox(width: 12),

                            Text(
                              pestList[index],

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openServiceBottomSheet(context),

      borderRadius: BorderRadius.circular(14),

      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          /// ICON
          Container(
            height: 72,
            width: 72,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),

              borderRadius: BorderRadius.circular(16),
            ),

            child: Image.asset(image, fit: BoxFit.contain),
          ),

          const SizedBox(height: 8),

          /// TITLE
          Text(
            title,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String image;
  final String title;

  const ProductItem({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,

      child: Column(
        children: [
          Container(
            height: 78,
            width: 78,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Image.asset(image, fit: BoxFit.contain),
          ),

          const SizedBox(height: 10),

          Text(
            title,

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// ================= REBOOK ITEM =================

class RebookItem extends StatelessWidget {
  final String image;
  final String title;

  const RebookItem({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          Container(
            height: 82,
            width: 110,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
