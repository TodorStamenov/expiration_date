import 'package:objectbox/objectbox.dart';

@Entity()
class ItemModel {
  int id;
  String name;
  int? shelfLife;
  DateTime? productionDate;
  DateTime expirationDate;

  ItemModel({
    this.id = 0,
    required this.name,
    required this.shelfLife,
    required this.productionDate,
    required this.expirationDate,
  });
}
