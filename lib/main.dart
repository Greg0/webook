import 'package:webook/models/device.dart';
import 'package:webook/models/ebook.dart';
import 'package:webook/screens/devices.dart';
import 'package:flutter/material.dart';
import 'package:hive/src/box/default_key_comparator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webook/screens/home.dart';

const webookApi = 'https://epub.press';

const devicesBox = 'devices';
const ebooksBox = 'ebooks';

Future main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(EbookFormatAdapter());
  Hive.registerAdapter(BookAdapter());

  await Hive.openBox<Device>(devicesBox);
  await Hive.openBox<Book>(
      ebooksBox,
      keyComparator: (dynamic k1, dynamic k2) => -1 * defaultKeyComparator(k1, k2) // DESC ordering
  );
  runApp(WEBookApp());
}

class WEBookApp extends StatelessWidget {
  const WEBookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WEBook',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        EBooksPage.routeName: (context) => const EBooksPage(),
        DevicesPage.routeName: (context) => DevicesPage(),
      },
      initialRoute: EBooksPage.routeName,
    );
  }
}
