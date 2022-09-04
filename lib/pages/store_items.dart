import 'package:expiration_date/models/item_model.dart';
import 'package:expiration_date/pages/item_details.dart';
import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/widgets/action_button.dart';
import 'package:flutter/material.dart';

class StoreItems extends StatefulWidget {
  static const String routeName = '/items';

  const StoreItems({Key? key}) : super(key: key);

  @override
  State<StoreItems> createState() => _StoreItemsState();
}

class _StoreItemsState extends State<StoreItems> {
  bool _showSearch = false;
  List<ItemModel> _filteredList = [];

  final List<ItemModel> _items = [];
  final _searchTerm = TextEditingController();

  @override
  void initState() {
    for (var i = 0; i < 300; i++) {
      _items.add(
        ItemModel(
          i,
          'Name $i',
          2,
          DateTime.now().subtract(const Duration(days: 100)),
          DateTime.now().add(Duration(days: i)),
        ),
      );
    }

    _filteredList = _items.toList();
    super.initState();
  }

  void toggleSearch() {
    setState(() {
      _searchTerm.clear();
      _showSearch = !_showSearch;
      _filteredList = _items.toList();
    });
  }

  void clearSearch() {
    _searchTerm.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _filteredList = _items.toList();
    });
  }

  void sortByName() {
    setState(() {
      _filteredList.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  void sortByDate() {
    setState(() {
      _filteredList.sort((a, b) => b.expirationDate.compareTo(a.expirationDate));
    });
  }

  void filterItems(String text) {
    setState(() {
      _filteredList = _items.where((item) => item.name.toLowerCase().contains(text.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(title: 'Items'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryActionButton(
                  icon: Icons.add,
                  action: () => Navigator.pushNamed(
                    context,
                    ItemDetails.routeName,
                  ),
                ),
                PrimaryActionButton(
                  icon: Icons.keyboard_double_arrow_down,
                  action: () {},
                ),
                PrimaryActionButton(
                  icon: Icons.abc,
                  action: sortByName,
                ),
                PrimaryActionButton(
                  icon: Icons.calendar_month,
                  action: sortByDate,
                ),
                PrimaryActionButton(
                  icon: Icons.search,
                  action: toggleSearch,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_showSearch) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: TextFormField(
                  controller: _searchTerm,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      icon: const Icon(Icons.close),
                      onPressed: clearSearch,
                    ),
                  ),
                  onChanged: filterItems,
                ),
              ),
              const SizedBox(height: 10),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _filteredList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      ItemDetails.routeName,
                      arguments: _filteredList[index].id,
                    ),
                    child: Text(_filteredList[index].name),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
