import 'package:email_validator/email_validator.dart';
import 'package:webook/main.dart';
import 'package:webook/models/device.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeviceFormPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int? deviceIndex;

  DeviceFormPage({Key? key, required this.deviceIndex}) : super(key: key);

  Device? get initialDevice {
    if (deviceIndex != null) {
      return Hive.box<Device>(devicesBox).getAt(deviceIndex!);
    }

    return null;
  }

  @override
  DeviceFormState createState() => DeviceFormState();
}

class DeviceFormState extends State<DeviceFormPage> {
  late Device formState;

  void onFormSubmit() {
    var currentState2 = widget.formKey.currentState;
    if (currentState2 != null && currentState2.validate()) {
      Box<Device> box = Hive.box<Device>(devicesBox);
      if (widget.deviceIndex != null) {
        box.putAt(widget.deviceIndex!, formState);
      } else {
        box.add(formState);
      }
      Navigator.of(context).pop();
    }
  }


  @override
  void initState() {
    super.initState();
    formState = widget.initialDevice ?? Device('', '', EbookFormat.EPUB, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage device'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
        child: Form(
          key: widget.formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              TextFormField(
                maxLength: 20,
                autofocus: true,
                initialValue: widget.initialDevice?.name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    formState.name = value;
                  });
                },
                validator: (val) =>
                    val!.isNotEmpty ? null : 'Name must not be empty',
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                initialValue: widget.initialDevice?.email,
                decoration: const InputDecoration(
                  labelText: "Device e-mail",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    formState.email = value;
                  });
                },
                validator: (val) {
                    if (val!.isNotEmpty == false) {
                      return 'E-mail must not be empty';
                    }
                    if (EmailValidator.validate(val) == false) {
                      return 'Wrong e-mail format';
                    }
                }
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButtonFormField(
                items: ebookFormats.keys.map((EbookFormat value) {
                  return DropdownMenuItem<EbookFormat>(
                    value: value,
                    child: Text(ebookFormats[value] ?? ''),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: widget.initialDevice?.format ?? EbookFormat.EPUB,
                hint: const Text("Ebook format"),
                onChanged: (EbookFormat? value) {
                  setState(() {
                    formState.format = value ?? EbookFormat.EPUB;
                  });
                },
              ),
              ElevatedButton(
                onPressed: onFormSubmit,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
