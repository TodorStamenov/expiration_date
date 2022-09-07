import 'package:expiration_date/data/objectbox.g.dart';
import 'package:expiration_date/pages/import_items.dart';
import 'package:expiration_date/pages/item_details.dart';
import 'package:expiration_date/pages/store_items.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final store = Store(
    getObjectBoxModel(),
    directory: join(dir.path, 'objecbox'),
  );

  Widget unfocusOnTap(Widget child) {
    return GestureDetector(
      child: child,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }

  runApp(
    unfocusOnTap(
      MaterialApp(
        title: 'Expiration Date',
        debugShowCheckedModeBanner: false,
        home: StoreItems(store: store),
        routes: {
          StoreItems.routeName: (context) => StoreItems(store: store),
          ItemDetails.routeName: (context) => ItemDetails(store: store),
          ImportItems.routeName: (context) => const ImportItems(),
        },
      ),
    ),
  );
}
