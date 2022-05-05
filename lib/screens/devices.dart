import 'package:webook/main.dart';
import 'package:webook/models/device.dart';
import 'package:webook/screens/device_form.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DevicesPage extends StatelessWidget {
  static const routeName = '/devices';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Devices')),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<Device>(devicesBox).listenable(),
          builder: (context, Box<Device> box, _) {
            if (box.values.isEmpty) {
              return const Center(child: Text('No devices'));
            }

            return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  Device? dev = box.getAt(index);
                  if (dev == null) {
                    return const SizedBox.shrink();
                  }
                  String format = dev.ebookFormat;

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DeviceFormPage(deviceIndex: index)));
                    },
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.devices),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) => AlertDialog(
                                    content: Text(
                                      "Do you want to delete \"${dev.name}\" device?",
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
                            title: Text(dev.name),
                            subtitle: Text('${dev.ebookFormat} | ${dev.email}'),
                          )
                        ],
                      ),
                    )),
                  );
                });
          }),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DeviceFormPage(deviceIndex: null)));
              });
        },
      ),
    );
  }
}
