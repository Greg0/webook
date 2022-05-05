import 'package:webook/models/device.dart';
import 'package:webook/screens/devices.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webook/screens/home.dart';

const devicesBox = 'devices';

Future main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(EbookFormatAdapter());

  await Hive.openBox<Device>(devicesBox);
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
