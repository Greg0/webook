// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:bmprogresshud/bmprogresshud.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:webook/api/client.dart';
import 'package:webook/api/request/create.dart';
import 'package:webook/api/request/download.dart';
import 'package:webook/api/request/filetype.dart';
import 'package:webook/api/request/status.dart';
import 'package:webook/api/response/create.dart';
import 'package:webook/api/response/download.dart';
import 'package:webook/api/response/status.dart';
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
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "eBooks"),
          NavigationDestination(icon: Icon(Icons.devices), label: "Devices"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
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
                  applicationLegalese: 'Powered by Epub.press');
              // Navigator.pushNamed(context, FavoritesPage.routeName);
            },
            icon: const Icon(Icons.info_outline),
            // label: const Text('About'),
          ),
        ],
      ),
      // drawer: const NavigationDrawer(),
      body: ProgressHud(
        child: ValueListenableBuilder(
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
                            builder: (context) =>
                                EbookFormPage(ebookIndex: index)));
                      },
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Wrap(children: [
                                downloadIconButton(context, book, box, index),
                                deleteIconButton(context, book, box, index)
                              ]),
                              title: Text(book.title),
                              subtitle: Text(book.url),
                            )
                          ],
                        ),
                      )),
                    );
                  });
            }),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EbookFormPage(ebookIndex: null)));
              });
        },
      ),
    );
  }

  IconButton deleteIconButton(
      BuildContext context, Book book, Box<Book> box, int index) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => AlertDialog(
            content: Text(
              "Do you want to delete \"${book.title}\" ebook?",
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
    );
  }

  IconButton downloadIconButton(
      BuildContext context, Book book, Box<Book> box, int index) {
    return IconButton(
        icon: const Icon(Icons.download),
        onPressed: () async {
          ApiClient api = ApiClient(webookApi);
          CreateResponse createResponse = await api.create(CreateRequest(
              title: book.title,
              urls: [book.url],
              author: book.author,
              description: book.description));

          var hud = ProgressHud.of(context);
          hud?.show(ProgressHudType.progress, "Preparing");
          StatusResponse statusResponse;
          do {
            statusResponse = await api.status(StatusRequest(createResponse.id));
            hud?.updateProgress(
                statusResponse.progress / 100, statusResponse.message);

            sleep(Duration(milliseconds: 200));
          } while (statusResponse.progress != 100);
          hud?.showAndDismiss(ProgressHudType.success, statusResponse.message);
          downloadBook(Filetype filetype) async {
            DownloadResponse downloadResponse = await api
                .download(DownloadRequest(createResponse.id, filetype));
            Directory? dir = await getApplicationDocumentsDirectory();
            // if (dir == null) {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Can\'t access storage'),
            //     action: SnackBarAction(
            //         label: 'Retry', onPressed: () => downloadBook(filetype)),
            //   ));
            //   return;
            // }
            File file = new File(p.join(dir.path, "${p.basename(book.title)}.${filetype.value}"));
            file.writeAsBytes(downloadResponse.bookContent);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Book saved'),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFile.open(file.path),
              ),
            ));
          }

          sleep(Duration(seconds: 2));
          showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                    title: Text("Choose book format"),
                    children: [
                      TextButton(
                          onPressed: () {
                            downloadBook(Filetype.MOBI);
                            Navigator.of(context).pop();
                          },
                          child: Text("MOBI")),
                      TextButton(
                          onPressed: () {
                            downloadBook(Filetype.EPUB);
                            Navigator.of(context).pop();
                          },
                          child: Text("EPUB")),
                    ],
                  ));
        });
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
