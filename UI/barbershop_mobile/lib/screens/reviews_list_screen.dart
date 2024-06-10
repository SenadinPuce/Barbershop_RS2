import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/review.dart';
import '../providers/review_provider.dart';
import '../utils/util.dart';
import '../widgets/custom_app_bar.dart';
import 'review_add_screen.dart';

class ReviewsListScreen extends StatefulWidget {
  static const routeName = '/Reviews';
  const ReviewsListScreen({required this.barberId, super.key});

  final int barberId;

  @override
  State<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends State<ReviewsListScreen> {
  late ReviewProvider _reviewProvider;
  List<Review>? _reviews;
  bool _isLoading = true;

  double _averageRating = 0.0;
  Map<int, int> _starCounts = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _reviewProvider = context.read<ReviewProvider>();

    var reviewsData = await _reviewProvider.get(
      filter: {
        'barberId': widget.barberId,
      },
    );

    setState(() {
      _reviews = reviewsData;
      _isLoading = false;
      _calculateRatings();
    });
  }

  void _calculateRatings() {
    if (_reviews == null || _reviews!.isEmpty) return;

    int totalRating = 0;
    _starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in _reviews!) {
      totalRating += review.rating!;
      _starCounts[review.rating!] = (_starCounts[review.rating!] ?? 0) + 1;
    }

    _averageRating = totalRating / _reviews!.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildAverageRating(),
            _buildStarCounts(),
            _buildView(),
            const SizedBox(
              height: 80,
            )
          ],
        )),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btn_add',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewAddScreen(
                barberId: widget.barberId,
              ),
            ),
          );

          setState(() {
            _isLoading = true;
          });
          loadData();
        },
        backgroundColor: const Color.fromRGBO(99, 134, 213, 1),
        label: const Text("Write A Review"),
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

  Widget _buildAverageRating() {
    if (_isLoading) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Average Rating: ${_averageRating.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < _averageRating ? Icons.star : Icons.star_border,
                  color: const Color.fromRGBO(213, 178, 99, 1),
                );
              }),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStarCounts() {
    if (_isLoading) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (index) {
            int star = 5 - index;
            return Text(
              "$star stars: ${_starCounts[star] ?? 0}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            );
          }),
        ),
      );
    }
  }

  Widget _buildView() {
    if (_isLoading) {
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
      Color color =
          i < rating ? const Color.fromRGBO(213, 178, 99, 1) : Colors.grey;
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
