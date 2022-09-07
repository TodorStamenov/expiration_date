import 'package:expiration_date/data/objectbox.g.dart';
import 'package:expiration_date/models/item_model.dart';
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
  bool _hasBeenInitialized = false;
  String _searchText = '';

  late Stream<List<ItemModel>> _stream;

  final _searchTerm = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _stream = getStream();
      _hasBeenInitialized = true;
    });
  }

  @override
  void dispose() {
    widget.store.close();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      _searchTerm.clear();
      _showSearch = !_showSearch;
      _stream = getStream();
    });
  }

  void clearSearch() {
    _searchTerm.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _stream = getStream();
    });
  }

  void sortByName() {
    setState(() {
      final query = widget.store.box<ItemModel>().query();
      query.order(ItemModel_.name, flags: 0);

      _stream = query.watch(triggerImmediately: true).map((query) => query.find());
    });
  }

  void sortByDate() {
    setState(() {
      final query = widget.store.box<ItemModel>().query();
      query.order(ItemModel_.expirationDate, flags: Order.descending);

      _stream = query.watch(triggerImmediately: true).map((query) => query.find());
    });
  }

  void filterItems(String text) {
    setState(() {
      _searchText = text;
    });
  }

  Stream<List<ItemModel>> getStream() {
    return widget.store
        .box<ItemModel>()
        .query(ItemModel_.name.contains(_searchText.toLowerCase()))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
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
            if (!_hasBeenInitialized) ...[
              const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
            ] else ...[
              StreamBuilder(
                stream: _stream,
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  }

                  final itemsList = snapshot.data! as List<ItemModel>;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: itemsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ItemDetails.routeName,
                          arguments: itemsList[index].id,
                        ),
                        child: ListTile(
                          title: Text(itemsList[index].name),
                          subtitle: Text(DateFormat('dd.MM.yyyy').format(itemsList[index].expirationDate)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
