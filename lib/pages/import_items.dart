import 'dart:io';

import 'package:expiration_date/data/objectbox.g.dart';
import 'package:expiration_date/models/item_model.dart';
import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/utils/toaster.dart';
import 'package:expiration_date/widgets/input_field.dart';
import 'package:expiration_date/widgets/primary_button.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class ImportItems extends StatefulWidget {
  static const String routeName = '/import';

  final Store store;

  const ImportItems({
    super.key,
    required this.store,
  });

  @override
  State<ImportItems> createState() => _ImportItemsState();
}

class _ImportItemsState extends State<ImportItems> {
  static const _dateFormat = 'dd.MM.yyyy';

  final _formKey = GlobalKey<FormState>();
  final _fileName = TextEditingController();

  void importFile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    var fileName = _fileName.text;

    if (!fileName.endsWith('.csv')) {
      fileName = '$fileName.csv';
    }

    final path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    final file = File(join(path, fileName));

    if (!(await file.exists())) {
      showToastMessage('File with name $fileName doesn\'t exist in Download folder!');
      setState(() {
        _fileName.clear();
      });

      return;
    }

    final fileContent = await file.readAsLines();

    final items = <ItemModel>[];
    for (var line in fileContent) {
      final tokens = line.split(',').map((t) => t.trim()).toList();

      items.add(
        ItemModel(
          name: tokens[0],
          productionDate: DateFormat(_dateFormat).parse(tokens[1]),
          shelfLife: int.parse(tokens[2]),
          expirationDate: DateFormat(_dateFormat).parse(tokens[3]),
        ),
      );
    }

    widget.store.box<ItemModel>().removeAll();
    widget.store.box<ItemModel>().putMany(items);

    showToastMessage('Items imported successfully!');

    if (mounted) {
      Navigator.pop(this.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Import CSV'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              PrimaryInputField(
                label: 'File Name',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textEditor: _fileName,
                isRequired: true,
              ),
              const SizedBox(height: 50),
              Center(
                child: PrimaryButton(
                  text: 'Import',
                  action: importFile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
