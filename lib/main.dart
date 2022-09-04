import 'package:expiration_date/pages/item_details.dart';
import 'package:expiration_date/pages/store_items.dart';
import 'package:flutter/material.dart';

void main() {
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
        home: const StoreItems(),
        routes: {
          StoreItems.routeName: (context) => const StoreItems(),
          ItemDetails.routeName: (context) => const ItemDetails(),
        },
      ),
    ),
  );
}
