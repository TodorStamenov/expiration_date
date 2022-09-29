import 'package:expiration_date/data/objectbox.g.dart';
import 'package:expiration_date/enum/sort_order.dart';
import 'package:expiration_date/models/item_model.dart';
import 'package:expiration_date/pages/import_items.dart';
import 'package:expiration_date/pages/item_details.dart';
import 'package:expiration_date/shared/header.dart';
import 'package:expiration_date/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoreItems extends StatefulWidget {
  static const String routeName = '/items';

  final Store store;

  const StoreItems({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  State<StoreItems> createState() => _StoreItemsState();
}

class _StoreItemsState extends State<StoreItems> {
  bool _showSearch = false;
  String _searchText = '';
  SortOrder _order = SortOrder.id;

  late Stream<List<ItemModel>> _itemsStream;

  final _searchTerm = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _itemsStream = getItemsStream();
    });
  }

  @override
  void dispose() {
    widget.store.close();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      _searchText = '';
      _searchTerm.clear();
      _showSearch = !_showSearch;
      _itemsStream = getItemsStream();
      _order = SortOrder.id;
    });
  }

  void clearSearch() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _searchText = '';
      _searchTerm.clear();
      _itemsStream = getItemsStream();
      _order = SortOrder.id;
    });
  }

  void sortByName() {
    setState(() {
      final query = widget.store.box<ItemModel>().query(
            ItemModel_.name.contains(
              _searchText.toLowerCase(),
              caseSensitive: false,
            ),
          );

      query.order(ItemModel_.name, flags: 0);

      _itemsStream = query.watch(triggerImmediately: true).map((query) => query.find());
      _order = SortOrder.name;
    });
  }

  void sortByDate() {
    setState(() {
      final query = widget.store.box<ItemModel>().query(
            ItemModel_.name.contains(
              _searchText.toLowerCase(),
              caseSensitive: false,
            ),
          );

      query.order(ItemModel_.expirationDate, flags: 0);

      _itemsStream = query.watch(triggerImmediately: true).map((query) => query.find());
      _order = SortOrder.date;
    });
  }

  void filterItems(String text) {
    setState(() {
      _searchText = text;
      final query = widget.store.box<ItemModel>().query(
            ItemModel_.name.contains(
              text.toLowerCase(),
              caseSensitive: false,
            ),
          );

      if (_order == SortOrder.id) {
        query.order(ItemModel_.id, flags: 0);
      } else if (_order == SortOrder.name) {
        query.order(ItemModel_.name, flags: 0);
      } else if (_order == SortOrder.date) {
        query.order(ItemModel_.expirationDate, flags: 0);
      }

      _itemsStream = query.watch(triggerImmediately: true).map((query) => query.find());
    });
  }

  Stream<List<ItemModel>> getItemsStream() {
    final query = widget.store.box<ItemModel>().query();
    query.order(ItemModel_.id, flags: 0);

    return query.watch(triggerImmediately: true).map((query) => query.find());
  }

  Widget? getTrailingIcon(DateTime expirationDate) {
    final now = DateTime.now();
    if (expirationDate.isBefore(now)) {
      return const Icon(
        Icons.warning,
        color: Colors.red,
      );
    }

    if (expirationDate.difference(now).inDays < 30) {
      return const Icon(
        Icons.warning,
        color: Colors.yellow,
      );
    }

    return null;
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
                  action: () {
                    Navigator.pushNamed(
                      context,
                      ItemDetails.routeName,
                    );
                  },
                ),
                PrimaryActionButton(
                  icon: Icons.keyboard_double_arrow_down,
                  action: () {
                    Navigator.pushNamed(
                      context,
                      ImportItems.routeName,
                    );
                  },
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
            StreamBuilder<List<ItemModel>>(
              stream: _itemsStream,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ),
                  );
                }

                final itemsList = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: itemsList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(itemsList[index].name),
                      subtitle: Text(DateFormat('dd.MM.yyyy').format(itemsList[index].expirationDate)),
                      trailing: getTrailingIcon(itemsList[index].expirationDate),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ItemDetails.routeName,
                          arguments: itemsList[index].id,
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
