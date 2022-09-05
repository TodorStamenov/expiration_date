import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/widgets/action_button.dart';
import 'package:expiration_date/widgets/input_field.dart';
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  static const String routeName = '/item-details';

  const ItemDetails({Key? key}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  bool _isEditMode = true;
  String _headerText = 'Edit Item';

  final _name = TextEditingController();
  final _productionDate = TextEditingController();
  final _shelfLife = TextEditingController();
  final _expirationDate = TextEditingController();

  @override
  void didChangeDependencies() {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null) {
      setState(() {
        _isEditMode = false;
        _headerText = 'Create Item';
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: _headerText),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            PrimaryInputField(
              label: 'Name',
              textEditor: _name,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            PrimaryInputField(
              label: 'Production Date',
              textEditor: _productionDate,
              textInputType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            PrimaryInputField(
              label: 'Shelf Life',
              textEditor: _shelfLife,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            PrimaryInputField(
              label: 'Expiration Date',
              textEditor: _expirationDate,
              textInputType: TextInputType.datetime,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PrimaryActionButton(
                  icon: Icons.check,
                  action: () {
                    Navigator.pop(context);
                  },
                ),
                PrimaryActionButton(
                  icon: Icons.close,
                  action: () {
                    Navigator.pop(context);
                  },
                ),
                if (_isEditMode) ...[
                  PrimaryActionButton(
                    icon: Icons.delete_forever,
                    action: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
