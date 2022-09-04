class ItemModel {
  final int id;
  final String name;
  final int shelfLife;
  final DateTime productionDate;
  final DateTime expirationDate;

  ItemModel(
    this.id,
    this.name,
    this.shelfLife,
    this.productionDate,
    this.expirationDate,
  );
}
