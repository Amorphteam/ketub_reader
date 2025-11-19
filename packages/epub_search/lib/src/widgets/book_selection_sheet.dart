import 'package:flutter/material.dart';
import '../interfaces.dart';

class BookSelectionSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<Book> books;
  final Map<String, bool> initialSelectedBooks;

  const BookSelectionSheetWidget({
    Key? key,
    required this.scrollController,
    required this.books,
    required this.initialSelectedBooks,
  }) : super(key: key);

  @override
  _BookSelectionSheetWidgetState createState() =>
      _BookSelectionSheetWidgetState();
}

class _BookSelectionSheetWidgetState extends State<BookSelectionSheetWidget> {
  late Map<String, bool> selectedBooks;

  @override
  void initState() {
    super.initState();
    selectedBooks = Map.from(widget.initialSelectedBooks);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "اختر الکتب لبدء البحث",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    final allSelected = selectedBooks.values.every((value) => value);
                    selectedBooks.updateAll((key, value) => !allSelected);
                  });
                },
                child: Text(
                  selectedBooks.values.every((value) => value)
                      ? "إلغاء الكل"
                      : "تحديد الكل",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: widget.books.length,
              itemBuilder: (context, index) {
                final book = widget.books[index];
                return _buildBookTile(book);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, selectedBooks);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            child: const Text("موافق"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTile(Book book) {
    if (book.series == null || book.series!.isEmpty) {
      return ListTile(
        leading: Checkbox(
          value: selectedBooks[book.epub] ?? false,
          onChanged: (value) {
            setState(() {
              selectedBooks[book.epub] = value ?? false;
            });
          },
        ),
        title: Text(book.title ?? "Untitled Book"),
      );
    } else {
      return ExpansionTile(
        title: Row(
          children: [
            Checkbox(
              value: selectedBooks[book.epub] ?? false,
              onChanged: (value) {
                setState(() {
                  final newValue = value ?? false;
                  selectedBooks[book.epub] = newValue;
                  for (var series in book.series ?? []) {
                    selectedBooks[series.epub] = newValue;
                  }
                });
              },
            ),
            Text(book.title ?? "Untitled Book"),
          ],
        ),
        children: (book.series ?? [])
            .map(
              (series) => Padding(
                padding: const EdgeInsets.only(right: 28.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedBooks[series.epub] ?? false,
                      onChanged: (value) {
                        setState(() {
                          selectedBooks[series.epub] = value ?? false;
                          final allSelected = book.series!
                              .every((s) => selectedBooks[s.epub] == true);
                          selectedBooks[book.epub] = allSelected;
                        });
                      },
                    ),
                    Text(series.title ?? "Untitled Series"),
                  ],
                ),
              ),
            )
            .toList(),
      );
    }
  }
}

