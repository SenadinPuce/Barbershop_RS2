import 'package:barbershop_mobile/models/review.dart';
import 'package:barbershop_mobile/providers/review_provider.dart';
import 'package:barbershop_mobile/screens/review_add_screen.dart';
import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

class ReviewsListScreen extends StatefulWidget {
  static const routeName = '/Reviews';
  const ReviewsListScreen({super.key});

  @override
  State<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  late ReviewProvider _reviewProvider;
  List<Review>? _reviews;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _reviewProvider = context.read<ReviewProvider>();

    var reviewsData = await _reviewProvider.get();

    setState(() {
      _reviews = reviewsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildView(),
            const SizedBox(
              height: 80,
            )
          ],
        )),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await PersistentNavBarNavigator.pushNewScreen(context,
              screen: const ReviewAddScreen());
          if (result != null && result == true) {
            setState(() {
              isLoading = true;
            });
            loadData();
          }
        },
        backgroundColor: const Color.fromRGBO(99, 134, 213, 1),
        label: const Text("Rate Us"),
        icon: const Icon(
          Icons.rate_review_rounded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: const Center(
        child: Text(
          "Reviews",
          style: TextStyle(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return Container();
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _reviews!.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Card(
              color: Colors.blueGrey[50],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Client: ",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${_reviews![index].clientFirstName} ${_reviews![index].clientLastName}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _buildRatingStars(_reviews![index].rating!)
                    ]),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _reviews![index].comment!,
                      style: const TextStyle(
                          fontSize: 17.0,
                          color: Color.fromRGBO(57, 131, 120, 1),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatDate(_reviews![index].createdDateTime) ?? "",
                      style:
                          const TextStyle(fontSize: 15.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = i < rating ? Icons.star : Icons.star_border;
      Color color = i < rating ? const Color.fromRGBO(213, 178, 99, 1) : Colors.grey;
      stars.add(
        Icon(
          iconData,
          color: color,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: stars,
    );
  }
}
