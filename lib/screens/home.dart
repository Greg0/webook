// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:webook/screens/devices.dart';
import 'package:flutter/material.dart';

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
      body: ListView.builder(
        itemCount: 100,
        cacheExtent: 20.0,
        controller: ScrollController(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ItemTile(index),
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
