import 'package:flutter/material.dart';

class ServiceViewDetailScreen extends StatelessWidget {

  final Map<String, dynamic> item;

  const ServiceViewDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: CustomScrollView(
        slivers: [

          /// APP BAR
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,

            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },

              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                item["image"] ??
                    "assets/images/cleaning_banner.jpg",

                fit: BoxFit.cover,
              ),
            ),
          ),

          /// BODY
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  /// TITLE
                  Text(
                    item["title"] ?? "",

                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// RATING
                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "${item["rating"]} (${item["reviews"]} reviews)",

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// PRICE
                  Text(
                    "Starts at ${item["price"]}",

                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ABOUT
                  const Text(
                    "About Service",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    item["desc1"] ?? "",

                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    item["desc2"] ?? "",

                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// FEATURES
                  const Text(
                    "What's Included",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  featureTile(
                    Icons.check_circle,
                    "Verified Professionals",
                  ),

                  featureTile(
                    Icons.cleaning_services,
                    "Deep Cleaning",
                  ),

                  featureTile(
                    Icons.health_and_safety,
                    "Safe Chemicals",
                  ),

                  featureTile(
                    Icons.access_time,
                    "Quick Service",
                  ),

                  const SizedBox(height: 35),

                  /// REVIEW TITLE
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(
                        "Customer Reviews",

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius:
                          BorderRadius.circular(30),
                        ),

                        child: Text(
                          "${item["rating"]} ★",

                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  /// REVIEW CARD
                  reviewCard(
                    "Rahul Sharma",
                    "Amazing cleaning service. Staff was professional and arrived on time.",
                    "5.0",
                  ),

                  reviewCard(
                    "Aman Verma",
                    "Very good experience. House looks fresh and clean.",
                    "4.8",
                  ),

                  reviewCard(
                    "Priya Singh",
                    "Affordable pricing and quality work.",
                    "4.9",
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,

        child: SizedBox(
          height: 58,

          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
            ),

            onPressed: () {},

            child: const Text(
              "Book Service",

              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget featureTile(
      IconData icon,
      String text,
      ) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 14),

          Text(
            text,

            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewCard(
      String name,
      String review,
      String rating,
      ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.08),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 24,
                backgroundColor:
                Colors.deepPurple.shade50,

                child: const Icon(
                  Icons.person,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      name,

                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [

                        const Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.orange,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          rating,

                          style: const TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            review,

            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}