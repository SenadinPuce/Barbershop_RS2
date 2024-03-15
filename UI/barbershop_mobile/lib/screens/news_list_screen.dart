import 'package:barbershop_mobile/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';
import '../providers/news_provider.dart';
import '../widgets/master_screen.dart';
import 'news_details_screen.dart';

class NewsListScreen extends StatefulWidget {
  static const routeName = '/news';
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late NewsProvider _newsProvider;
  List<News>? _news;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _newsProvider = context.read<NewsProvider>();

    var newsData = await _newsProvider.get();

    setState(() {
      _news = newsData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildHeader(), _buildView()],
      )),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
        child: Text(
          "News",
          style: GoogleFonts.tiltNeon(color: Colors.black, fontSize: 35),
        ),
      ),
    );
  }

  Widget _buildView() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _news?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return _buildNewsTile(_news?[index]);
          });
    }
  }

  Widget _buildNewsTile(News? news) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetailsScreen(
                          news: news!,
                        )));
          },
          tileColor: Colors.grey[200],
          contentPadding: const EdgeInsets.all(10),
          leading: news?.photo != null
              ? imageFromBase64String(news!.photo!)
              : const SizedBox(),
          title: Text(news?.title ?? ''),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.calendar_today,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(formatDate(news?.createdDateTime) ?? 'Unknown'),
            ],
          ),
        ),
      ),
    );
  }
}
