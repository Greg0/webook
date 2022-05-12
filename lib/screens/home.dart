// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:webook/main.dart';
import 'package:webook/screens/devices.dart';
import 'package:flutter/material.dart';
import 'package:webook/screens/ebook_form.dart';

import '../models/ebook.dart';

class EBooksPage extends StatelessWidget {
  static const routeName = '/';

  const EBooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of ebooks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, DevicesPage.routeName);
            },
            icon: const Icon(Icons.settings),
            // label: const Text('Settings'),
          ),
          IconButton(
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationLegalese: 'Powered by Epub.press'
              );
              // Navigator.pushNamed(context, FavoritesPage.routeName);
            },
            icon: const Icon(Icons.info_outline),
            // label: const Text('About'),
          ),
        ],
      ),
      // drawer: const NavigationDrawer(),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Book>(ebooksBox).listenable(),
          builder: (context, Box<Book> box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text('Books list is empty'));
            }

            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Book? book = box.getAt(index);
                  if (book == null) {
                    return const SizedBox.shrink();
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EbookFormPage(ebookIndex: index)));
                    },
                    child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) => AlertDialog(
                                        content: Text(
                                          "Do you want to delete \"${book.title}\" device?",
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("No"),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                          TextButton(
                                            child: const Text("Yes"),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await box.deleteAt(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                title: Text(book.title),
                                subtitle: Text(book.url),
                              )
                            ],
                          ),
                        )),
                  );
                });
          }),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EbookFormPage(ebookIndex: null)));
              }
          );
        },
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile(this.itemNo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Item $itemNo',
          key: Key('text_$itemNo'),
        ),
      ),
    );
  }
}
