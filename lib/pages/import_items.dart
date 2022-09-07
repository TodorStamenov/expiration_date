import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/utils/toaster.dart';
import 'package:expiration_date/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ImportItems extends StatefulWidget {
  static const String routeName = '/import';

  const ImportItems({super.key});

  @override
  State<ImportItems> createState() => _ImportItemsState();
}

class _ImportItemsState extends State<ImportItems> {
  final _path = TextEditingController();

  void importFile() {
    if (_path.text == '') {
      showToastMessage('File name is required!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Import CSV'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            PrimaryInputField(
              label: 'File Name',
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textEditor: _path,
            ),
            const SizedBox(height: 50),
            Center(
              child: MaterialButton(
                color: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                onPressed: importFile,
                child: const Text(
                  'Import',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
