import 'package:intl/date_symbol_data_local.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:webook/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/ebook.dart';

class EbookFormPage extends StatefulWidget {
  final formKey = GlobalKey<FormState>();
  final int? ebookIndex;

  EbookFormPage({Key? key, required this.ebookIndex}) : super(key: key);

  Book? get initialEbook {
    if (ebookIndex != null) {
      return Hive.box<Book>(ebooksBox).getAt(ebookIndex!);
    }

    return null;
  }

  @override
  EbookFormState createState() => EbookFormState();
}

class EbookFormState extends State<EbookFormPage> {
  late Book formState;

  void onFormSubmit() {
    var currentState2 = widget.formKey.currentState;
    if (currentState2 != null && currentState2.validate()) {
      Box<Book> box = Hive.box<Book>(ebooksBox);
      if (widget.ebookIndex != null) {
        box.putAt(widget.ebookIndex!, formState);
      } else {
        box.add(formState);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    initializeDateFormatting(Platform.localeName, null);
    formState = widget.initialEbook ??
        Book('Ebook ' + DateFormat.yMd(Platform.localeName).format(currentDate),
            '', 'webook', 'ebook', '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage ebook'),
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
                initialValue: formState.title,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    formState.title = value;
                  });
                },
                validator: (val) =>
                    val!.isNotEmpty ? null : 'Title must not be empty',
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                  maxLength: 100,
                  initialValue: formState.description,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      formState.description = value;
                    });
                  }),
              TextFormField(
                  keyboardType: TextInputType.url,
                  initialValue: formState.url,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Article URL",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      formState.url = value;
                    });
                  },
                  validator: (val) {
                    if (val!.isNotEmpty == false) {
                      return 'URL must not be empty';
                    }
                    if (Uri.tryParse(val)?.isAbsolute == false) {
                      return 'Type correct url';
                    }
                  }),
              const SizedBox(
                height: 16,
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
