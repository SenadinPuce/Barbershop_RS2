import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news.dart';
import '../providers/news_provider.dart';
import '../utils/util.dart';
import 'news_details_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late NewsProvider _newsProvider;
  final TextEditingController _newsTitleController = TextEditingController();
  List<News>? _news;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  loadNews() async {
    _newsProvider = context.read<NewsProvider>();

    var newsData = await _newsProvider.get(
        filter: {'title': _newsTitleController.text, 'includeAuthor': true});

    setState(() {
      _news = newsData;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _newsTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearch(),
          const SizedBox(
            height: 20,
          ),
          _buildDataListView()
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
            child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'News title',
            hintText: 'Enter news title',
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          ),
          controller: _newsTitleController,
        )),
        const SizedBox(width: 8),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(213, 178, 99, 1),
            ),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              loadNews();
            },
            child: const Text("Search")),
        const SizedBox(
          width: 8,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(84, 181, 166, 1),
          ),
          onPressed: () async {
            _isLoading = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NewsDetailsScreen()));
            if (_isLoading) {
              setState(() {});
              loadNews();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text("News saved successfully.")
                  ],
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.green,
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  textColor: Colors.white,
                ),
              ));
            }
          },
          child: const Text("Add news"),
        ),
      ],
    );
  }

  Widget _buildDataListView() {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                dataRowMaxHeight: 70,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) {
                    return const Color.fromRGBO(236, 239, 241, 1);
                  },
                ),
                columns: const [
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Title',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Picture',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Date created',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Author',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  )),
                  DataColumn(
                    label: Expanded(
                      child: Text('Edit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
                ],
                rows: (_news ?? [])
                    .map((News n) => DataRow(cells: [
                          DataCell(Text(n.title.toString())),
                          DataCell(n.photo != null
                              ? Container(
                                  width: 70,
                                  height: 70,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: imageFromBase64String(n.photo!)),
                                )
                              : const Text("")),
                          DataCell(Text(formatDate(n.createdDateTime))),
                          DataCell(Text(n.authorFullName.toString())),
                          DataCell(IconButton(
                            icon: const Icon(
                              Icons.edit_document,
                              color: Color.fromRGBO(84, 181, 166, 1),
                            ),
                            onPressed: () {
                              _editNews(n);
                            },
                          )),
                          DataCell(IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Color(0xfff71133),
                            ),
                            onPressed: () {
                              _deleteNews(n);
                            },
                          ))
                        ]))
                    .toList(),
              ),
            ),
          );
  }

  void _editNews(News n) async {
    _isLoading = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewsDetailsScreen(
              news: n,
            )));
    if (_isLoading == true) {
      setState(() {});
      loadNews();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text("News saved successfully.")
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ));
    }
  }

  void _deleteNews(News n) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text(
                'Are you sure you want to delete this news? This action is not reversible.'),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              ElevatedButton(
                child: const Text("Yes"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    await _newsProvider.delete(n.id!);

                    setState(() {
                      _news?.removeWhere((element) => element.id == n.id);
                    });

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text("News deleted successfully.")
                        ],
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.green,
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                        textColor: Colors.white,
                      ),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Failed to delete news. Please try again.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red,
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                          textColor: Colors.white,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        });
  }
}
