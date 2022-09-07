import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../models/item_model.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 826546144119806252),
      name: 'ItemModel',
      lastPropertyId: const IdUid(5, 6685045111405984756),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(id: const IdUid(1, 6026087805763686712), name: 'id', type: 6, flags: 1),
        ModelProperty(id: const IdUid(2, 6597578411738905234), name: 'name', type: 9, flags: 0),
        ModelProperty(id: const IdUid(3, 8493926663785787028), name: 'shelfLife', type: 6, flags: 0),
        ModelProperty(id: const IdUid(4, 7529060670442599914), name: 'productionDate', type: 10, flags: 0),
        ModelProperty(id: const IdUid(5, 6685045111405984756), name: 'expirationDate', type: 10, flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 826546144119806252),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    ItemModel: EntityDefinition<ItemModel>(
        model: _entities[0],
        toOneRelations: (ItemModel object) => [],
        toManyRelations: (ItemModel object) => {},
        getId: (ItemModel object) => object.id,
        setId: (ItemModel object, int id) {
          object.id = id;
        },
        objectToFB: (ItemModel object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addInt64(2, object.shelfLife);
          fbb.addInt64(3, object.productionDate?.millisecondsSinceEpoch);
          fbb.addInt64(4, object.expirationDate.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final productionDateValue = const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);
          final object = ItemModel(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              name: const fb.StringReader(asciiOptimization: true).vTableGet(buffer, rootOffset, 6, ''),
              shelfLife: const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 8),
              productionDate:
                  productionDateValue == null ? null : DateTime.fromMillisecondsSinceEpoch(productionDateValue),
              expirationDate:
                  DateTime.fromMillisecondsSinceEpoch(const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0)));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [ItemModel] entity fields to define ObjectBox queries.
class ItemModel_ {
  /// see [ItemModel.id]
  static final id = QueryIntegerProperty<ItemModel>(_entities[0].properties[0]);

  /// see [ItemModel.name]
  static final name = QueryStringProperty<ItemModel>(_entities[0].properties[1]);

  /// see [ItemModel.shelfLife]
  static final shelfLife = QueryIntegerProperty<ItemModel>(_entities[0].properties[2]);

  /// see [ItemModel.productionDate]
  static final productionDate = QueryIntegerProperty<ItemModel>(_entities[0].properties[3]);

  /// see [ItemModel.expirationDate]
  static final expirationDate = QueryIntegerProperty<ItemModel>(_entities[0].properties[4]);
}
