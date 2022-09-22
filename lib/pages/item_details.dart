import 'package:expiration_date/data/objectbox.g.dart';
import 'package:expiration_date/models/item_model.dart';
import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/utils/toaster.dart';
import 'package:expiration_date/widgets/action_button.dart';
import 'package:expiration_date/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetails extends StatefulWidget {
  static const String routeName = '/item-details';

  final Store store;

  const ItemDetails({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  static const _dateFormat = 'dd.MM.yyyy';

  int? _itemId;
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
    } else {
      final itemId = arguments as int;
      final item = widget.store.box<ItemModel>().query(ItemModel_.id.equals(itemId)).build().findFirst();

      if (item == null) {
        return;
      }

      setState(() {
        _itemId = itemId;
        _name.text = item.name;
        _productionDate.text = item.productionDate == null ? '' : DateFormat(_dateFormat).format(item.productionDate!);
        _shelfLife.text = item.shelfLife == null ? '' : item.shelfLife.toString();
        _expirationDate.text = DateFormat(_dateFormat).format(item.expirationDate);
      });
    }

    super.didChangeDependencies();
  }

  void saveItem() async {
    if (_name.text == '') {
      showToastMessage('Product Name is required!');
      return;
    }

    final shelfLife = int.tryParse(_shelfLife.text);
    final productionDate = _productionDate.text == '' ? null : DateFormat(_dateFormat).parse(_productionDate.text);
    DateTime? expirationDate;

    if (_expirationDate.text != '') {
      expirationDate = DateFormat(_dateFormat).parse(_expirationDate.text);
    } else if (shelfLife != null && productionDate != null && expirationDate == null) {
      expirationDate = DateTime(productionDate.year + shelfLife, productionDate.month, productionDate.day);
    } else {
      showToastMessage('You have to provide Expiration Date or Production Date and Shelf Life!');
      return;
    }

    final item = ItemModel(
      name: _name.text,
      productionDate: productionDate,
      shelfLife: shelfLife,
      expirationDate: expirationDate,
    );

    if (_itemId != null) {
      item.id = _itemId!;
    }

    await widget.store.box<ItemModel>().putAsync(item);

    showToastMessage('Item saved successfully!');

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void removeItem() {
    widget.store.box<ItemModel>().remove(_itemId!);
    showToastMessage('Item deleted successfully!');
    Navigator.pop(context);
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
              textInputType: TextInputType.text,
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
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PrimaryActionButton(
                  icon: Icons.check,
                  action: saveItem,
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
                    action: removeItem,
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
